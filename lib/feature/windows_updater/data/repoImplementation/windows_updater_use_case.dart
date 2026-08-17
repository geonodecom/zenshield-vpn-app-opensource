import 'dart:io';

import 'package:desktop_updater/desktop_updater.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/feature/desktop_updater/domain/useCase/desktop_updater_use_case.dart';

/// Windows updater backed by the signed Inno Setup installer.
///
/// The backend hands out a direct `…-setup.exe` URL, so there is no per-file
/// hash diff to compute: download the installer, launch it, and let it close
/// the app, replace the files and relaunch. This mirrors
/// `AndroidUpdaterUseCase`, which does the same with an APK and the system
/// installer, rather than the file-by-file flow the `desktop_updater` package
/// still uses for macOS/Linux.
@injectable
class WindowsUpdaterUseCase extends ChangeNotifier
    implements AbstractDesktopUpdaterUseCase {
  WindowsUpdaterUseCase(this._dio, this._logger);

  final Dio _dio;
  final Talker _logger;

  bool _needUpdate = false;
  bool _isDownloading = false;
  bool _isDownloaded = false;
  bool _downloadHadError = false;
  bool _isMandatory = false;
  String? _appVersion;
  String? _downloadUrl;
  double _downloadProgress = 0.0;
  int _targetBuildNumber = 0;
  File? _installerFile;

  @override
  bool get needUpdate => _needUpdate;

  @override
  bool get isDownloading => _isDownloading;

  @override
  bool get isDownloaded => _isDownloaded;

  @override
  bool get downloadHadError => _downloadHadError;

  /// Once the installer is launched this process is gone, so an install-stage
  /// failure can never be observed from here.
  @override
  bool get isInstallFailure => false;

  @override
  bool get isMandatory => _isMandatory;

  @override
  String? get appVersion => _appVersion;

  @override
  double get downloadProgress => _downloadProgress;

  @override
  Future<void> initializeUpdater() async {}

  @override
  void disposeUpdater() {}

  @override
  Future<void> checkVersion() async {
    // HomeBloc re-checks every 30 minutes; don't disturb a download in flight.
    if (_isDownloading || _isDownloaded) return;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        Api.endpoints.appConfig,
      );
      final json = response.data;

      if (json == null) {
        _logger.warning('[WindowsUpdater] Empty body from the version feed');
        return;
      }

      final windowsItems = AppArchiveModel.fromJson(
        json,
      ).items.where((item) => item.platform == 'windows').toList();

      // Nothing on offer for Windows is not a failure — carry on as if the
      // app were already up to date instead of blocking on an update error.
      if (windowsItems.isEmpty) {
        _logger.warning('[WindowsUpdater] No windows entry in version feed');
        _clearTarget();
        return;
      }

      final currentBuild = await _currentBuildNumber();
      final selection = selectVersionTarget(windowsItems, currentBuild);

      if (selection == null) {
        _clearTarget();
        return;
      }

      final target = selection.item;
      _logger.info(
        '[WindowsUpdater] Target: ${target.version} '
        '(build ${target.shortVersion}, isLatest: ${target.isLatest}), '
        'current: $currentBuild',
      );

      if (!selection.needUpdate) {
        _clearTarget();
        return;
      }

      _needUpdate = true;
      _isMandatory = target.mandatory;
      _appVersion = target.version;
      _downloadUrl = target.url;
      _targetBuildNumber = target.shortVersion;
      notifyListeners();
    } catch (e, st) {
      // Genuine failures (network, malformed feed) still surface as an error
      // screen with Retry, via AppUpdateBloc's retry loop.
      _logger.error('[WindowsUpdater] checkVersion failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> downloadUpdate() async {
    if (_isDownloading || _downloadUrl == null) return;

    _isDownloading = true;
    _isDownloaded = false;
    _downloadHadError = false;
    _downloadProgress = 0.0;
    notifyListeners();

    try {
      final target = await _prepareInstallerPath(_downloadUrl!);

      // A bare Dio on purpose: the injected client's AuthInterceptor attaches
      // the user's bearer token to every request, and the installer usually
      // lives on a third-party CDN.
      await Dio().download(
        _downloadUrl!,
        target,
        onReceiveProgress: (received, total) {
          if (total <= 0) return;
          final progress = received / total;
          // Progress fires per chunk; only rebuild on visible movement.
          if (progress - _downloadProgress < 0.01 && progress < 1.0) return;
          _downloadProgress = progress;
          notifyListeners();
        },
      );

      _installerFile = File(target);
      _downloadProgress = 1.0;
      _isDownloading = false;
      _isDownloaded = true;
      _logger.info('[WindowsUpdater] Installer downloaded to $target');
      notifyListeners();
    } catch (e, st) {
      _logger.error('[WindowsUpdater] downloadUpdate failed', e, st);
      _downloadHadError = true;
      _isDownloading = false;
      _isDownloaded = false;
      notifyListeners();
    }
  }

  /// Launches the installer and quits, leaving it to replace the app.
  ///
  /// The Inno script already force-closes `Zenshield.exe` / `singbox-tunnel`
  /// and relaunches the app afterwards, so nothing has to be copied here.
  @override
  Future<void> restartApp() async {
    final installer = _installerFile;

    if (installer == null || !installer.existsSync()) {
      _logger.error('[WindowsUpdater] Installer missing, cannot install');
      return;
    }

    // A successful Process.start only proves the shell/launcher ran, not that
    // the installer itself started — an admin-elevation prompt (this installs
    // to Program Files) can still be silently declined afterwards. Quitting
    // on that would make the app vanish with the update never applied, so
    // confirm the installer process is actually alive before leaving.
    if (!await _launchInstaller(installer)) return;

    final exeName = installer.uri.pathSegments.last;
    if (!await _waitForInstallerToStart(exeName)) {
      _logger.error(
        '[WindowsUpdater] Installer never appeared to be running (UAC '
        'declined or blocked?) — staying open instead of vanishing.',
      );
      return;
    }

    _logger.info('[WindowsUpdater] Installer confirmed running, quitting app');
    // FileTalkerLogger drains Talker history on a 500ms timer; give it a beat
    // so this hand-off is still on disk once the process is gone.
    await Future.delayed(const Duration(seconds: 1));
    // The installer force-closes us anyway; leaving on our own terms keeps the
    // shutdown ordered, so the tunnel is already down when files are replaced.
    exit(0);
  }

  /// Polls `tasklist` for [exeName] so a declined/blocked elevation prompt
  /// (which never starts the installer) can be told apart from it actually
  /// running. Checked repeatedly for [timeout] rather than once, since the
  /// process takes a moment to appear after the launch call returns.
  Future<bool> _waitForInstallerToStart(
    String exeName, {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 400),
  }) async {
    final attempts = (timeout.inMilliseconds / pollInterval.inMilliseconds)
        .ceil();
    for (var i = 0; i < attempts; i++) {
      if (await _isProcessRunning(exeName)) return true;
      await Future.delayed(pollInterval);
    }
    return false;
  }

  Future<bool> _isProcessRunning(String exeName) async {
    try {
      // Default TABLE output truncates the Image Name column at 25 chars,
      // so a longer installer filename would never match and we'd wrongly
      // conclude it isn't running. CSV reports the name in full.
      final result = await Process.run('tasklist', [
        '/FI',
        'IMAGENAME eq $exeName',
        '/FO',
        'CSV',
        '/NH',
      ]);
      return (result.stdout as String).toLowerCase().contains(
        exeName.toLowerCase(),
      );
    } catch (e, st) {
      // Can't confirm either way — don't block a real update on our own
      // tooling failing, so treat it as running.
      _logger.warning('[WindowsUpdater] tasklist check failed', e, st);
      return true;
    }
  }

  Future<bool> _launchInstaller(File installer) async {
    const args = ['/SILENT', '/NOCANCEL', '/NORESTART'];

    try {
      await Process.start(
        installer.path,
        args,
        mode: ProcessStartMode.detached,
      );
      return true;
    } on ProcessException catch (e) {
      // An installer manifested as requireAdministrator cannot be started
      // through CreateProcess (ERROR_ELEVATION_REQUIRED). `start` goes via
      // ShellExecute, which raises the UAC prompt instead of failing.
      _logger.warning(
        '[WindowsUpdater] Direct launch failed, retrying via shell',
        e,
      );
    }

    try {
      await Process.start('cmd', [
        '/c',
        'start',
        '',
        installer.path,
        ...args,
      ], mode: ProcessStartMode.detached);
      return true;
    } catch (e, st) {
      _logger.error('[WindowsUpdater] Shell launch failed too', e, st);
      return false;
    }
  }

  @override
  Future<bool> hasUpdateSucceeded() async =>
      await _currentBuildNumber() >= _targetBuildNumber;

  void _clearTarget() {
    if (!_needUpdate && _downloadUrl == null) return;

    _needUpdate = false;
    _isMandatory = false;
    _appVersion = null;
    _downloadUrl = null;
    _targetBuildNumber = 0;
    notifyListeners();
  }

  /// Build number of the running app, read off the exe's `ProductVersion`
  /// ("1.0.4+6" -> 6) by the native side.
  Future<int> _currentBuildNumber() async {
    final raw = await DesktopUpdater().getCurrentVersion();
    return int.tryParse(raw ?? '') ?? 0;
  }

  Future<String> _prepareInstallerPath(String url) async {
    final supportDir = await getApplicationSupportDirectory();
    final updatesDir = Directory(
      '${supportDir.path}${Platform.pathSeparator}updates',
    );

    // Drop whatever a previous, half-finished attempt left behind.
    if (updatesDir.existsSync()) {
      await updatesDir.delete(recursive: true);
    }
    await updatesDir.create(recursive: true);

    return '${updatesDir.path}${Platform.pathSeparator}${_installerName(url)}';
  }

  String _installerName(String url) {
    final segments = Uri.parse(url).pathSegments;
    final name = segments.isEmpty ? '' : segments.last;
    return name.toLowerCase().endsWith('.exe') ? name : 'Zenshield-setup.exe';
  }
}
