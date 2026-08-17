import 'package:desktop_updater/desktop_updater.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/feature/desktop_updater/domain/useCase/desktop_updater_use_case.dart';

@injectable
class AndroidUpdaterUseCase extends ChangeNotifier
    implements AbstractDesktopUpdaterUseCase {
  AndroidUpdaterUseCase(this._dio, this._logger);

  final Dio _dio;
  final Talker _logger;

  bool _versionChecked = false;
  double _lastNotifiedProgress = -1.0;
  bool _needUpdate = false;
  bool _isDownloading = false;
  bool _isDownloaded = false;
  bool _downloadHadError = false;
  bool _installStarted = false;
  bool _isMandatory = false;
  String? _appVersion;
  double _downloadProgress = 0.0;
  String? _downloadUrl;
  int _targetBuildNumber = 0;

  @override
  bool get needUpdate => _needUpdate;

  @override
  bool get isDownloading => _isDownloading;

  @override
  bool get isDownloaded => _isDownloaded;

  @override
  bool get downloadHadError => _downloadHadError;

  @override
  bool get isInstallFailure => _installStarted && _downloadHadError;

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
    if (_versionChecked) return;
    _versionChecked = true;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        Api.endpoints.appConfig,
      );
      final json = response.data as Map<String, dynamic>;

      final archive = AppArchiveModel.fromJson(json);

      final androidItems = archive.items
          .where((item) => item.platform == 'android')
          .toList();

      if (androidItems.isEmpty) {
        _logger.warning(
          '[AndroidUpdater] No android entry in app-archive.json',
        );
        return;
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;

      final selection = selectVersionTarget(androidItems, currentBuild);
      if (selection == null) return;
      final latest = selection.item;

      _logger.info(
        '[AndroidUpdater] Target: ${latest.shortVersion} '
        '(isLatest: ${latest.isLatest}), current: $currentBuild',
      );

      if (selection.needUpdate) {
        _needUpdate = true;
        _isMandatory = latest.mandatory;
        _appVersion = latest.version;
        _downloadUrl = latest.url;
        _targetBuildNumber = latest.shortVersion;
        notifyListeners();
      }
    } catch (e, st) {
      _logger.error('[AndroidUpdater] checkVersion failed', e, st);
      rethrow;
    }
  }

  @override
  Future<bool> hasUpdateSucceeded() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
    return currentBuild >= _targetBuildNumber;
  }

  @override
  Future<void> downloadUpdate() async {
    if (_isDownloading || _downloadUrl == null) return;

    _isDownloading = true;
    _downloadHadError = false;
    _installStarted = false;
    _downloadProgress = 0.0;
    notifyListeners();

    try {
      OtaUpdate()
          .execute(_downloadUrl!)
          .listen(
            (OtaEvent event) {
              switch (event.status) {
                case OtaStatus.DOWNLOADING:
                  final raw = double.tryParse(event.value ?? '0') ?? 0.0;
                  final progress = raw / 100.0;
                  if (progress == _lastNotifiedProgress) break;
                  _lastNotifiedProgress = progress;
                  _downloadProgress = progress;
                  notifyListeners();
                case OtaStatus.INSTALLING:
                  // System installer UI has launched; outcome is still
                  // pending (INSTALLATION_DONE / INSTALLATION_ERROR next).
                  _isDownloading = false;
                  _installStarted = true;
                  _downloadProgress = 1.0;
                  notifyListeners();
                case OtaStatus.INSTALLATION_DONE:
                  _isDownloading = false;
                  _isDownloaded = true;
                  notifyListeners();
                case OtaStatus.INSTALLATION_ERROR:
                case OtaStatus.ALREADY_RUNNING_ERROR:
                case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
                case OtaStatus.INTERNAL_ERROR:
                case OtaStatus.DOWNLOAD_ERROR:
                case OtaStatus.CHECKSUM_ERROR:
                case OtaStatus.CANCELED:
                  _logger.error('[AndroidUpdater] OTA error: ${event.status}');
                  _downloadHadError = true;
                  _isDownloading = false;
                  _isDownloaded = false;
                  notifyListeners();
              }
            },
            onError: (Object e) {
              _logger.error('[AndroidUpdater] downloadUpdate stream error', e);
              _downloadHadError = true;
              _isDownloading = false;
              notifyListeners();
            },
          );
    } catch (e, st) {
      _logger.error('[AndroidUpdater] downloadUpdate failed', e, st);
      _downloadHadError = true;
      _isDownloading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> restartApp() async {
    // ota_update triggers the system APK installer automatically;
    // no explicit restart call is needed.
  }
}
