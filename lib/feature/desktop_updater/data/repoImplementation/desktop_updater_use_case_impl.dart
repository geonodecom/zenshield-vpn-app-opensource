import 'dart:io';

import 'package:desktop_updater/updater_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/core/utils/windows_service_utils.dart';
import 'package:zenshield/feature/desktop_updater/domain/useCase/desktop_updater_use_case.dart';

@injectable
class DesktopUpdaterUseCase extends ChangeNotifier
    implements AbstractDesktopUpdaterUseCase {
  DesktopUpdaterUseCase(this._logger);

  final Talker _logger;
  DesktopUpdaterController? _controller;

  double _downloadProgress = 0.0;

  @override
  bool get needUpdate => _controller?.needUpdate ?? false;

  @override
  bool get isDownloading => _controller?.isDownloading ?? false;

  @override
  bool get isDownloaded => _controller?.isDownloaded ?? false;

  @override
  bool get downloadHadError => _controller?.downloadHadError ?? false;

  @override
  bool get isInstallFailure => false;

  @override
  bool get isMandatory => _controller?.isMandatory ?? false;

  @override
  String? get appVersion => _controller?.appVersion;

  @override
  double get downloadProgress {
    _downloadProgress =
        (_controller?.downloadProgress ?? 0.0) > _downloadProgress
        ? (_controller?.downloadProgress ?? 0.0)
        : _downloadProgress;
    return _downloadProgress;
  }

  @override
  Future<void> initializeUpdater() async {
    try {
      if (!Platform.isWindows && !Platform.isMacOS) {
        _logger.info('Desktop updater is only available on desktop platforms');
        return;
      }

      if (_controller != null) {
        _logger.info('Desktop updater already initialized');
        return;
      }

      final appConfigUrl = Uri.parse(Api.endpoints.appConfig);
      _controller = DesktopUpdaterController(appArchiveUrl: appConfigUrl);

      _controller?.addListener(_onControllerChanged);

      _logger.info('Desktop updater initialized successfully');
      notifyListeners();
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize desktop updater', e, stackTrace);
    }
  }

  @override
  void dispose() {
    disposeUpdater();
    super.dispose();
  }

  @override
  void disposeUpdater() {
    if (_controller == null) return;

    try {
      _controller?.removeListener(_onControllerChanged);
      _controller?.dispose();
      _controller = null;
      _logger.info('Desktop updater disposed successfully');
      notifyListeners();
    } catch (e, stackTrace) {
      _logger.error('Failed to dispose desktop updater', e, stackTrace);
    }
  }

  void _onControllerChanged() {
    notifyListeners();
  }

  @override
  Future<void> checkVersion() async {
    if (_controller == null) {
      _logger.warning('Desktop updater controller is not initialized');
      return;
    }
    await _controller!.checkVersion();
  }

  @override
  Future<void> downloadUpdate() async {
    if (_controller == null) {
      _logger.warning('Desktop updater controller is not initialized');
      return;
    }
    await _controller!.downloadUpdate();
  }

  @override
  Future<void> restartApp() async {
    if (_controller == null) {
      _logger.warning('Desktop updater controller is not initialized');
      return;
    }
    String? preElevatedCommand;
    if (Platform.isWindows) {
      final dir = await getApplicationSupportDirectory();
      final updatePath = '${dir.path}${Platform.pathSeparator}update';
      if (WindowsServiceUtils.hasSingboxTunnelExeInUpdateFolder(updatePath)) {
        preElevatedCommand =
            WindowsServiceUtils.getStopAndDeleteServiceCommand();
        _logger.info(
          '[App Update] Stop/delete singbox-tunnel will run in same elevated script',
        );
      }
    }
    _controller!.restartApp(preElevatedCommand: preElevatedCommand);
  }

  @override
  Future<bool> hasUpdateSucceeded() async => false;
}
