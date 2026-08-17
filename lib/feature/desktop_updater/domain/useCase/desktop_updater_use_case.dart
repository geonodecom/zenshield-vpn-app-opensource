import 'package:flutter/foundation.dart';

abstract class AbstractDesktopUpdaterUseCase {
  Future<void> initializeUpdater();
  void disposeUpdater();

  bool get needUpdate;
  bool get isDownloading;
  bool get isDownloaded;
  bool get downloadHadError;

  /// Whether the last failure happened after handing off to the OS
  /// installer (as opposed to failing during the download itself). Such
  /// failures (e.g. a signing-key mismatch) won't be fixed by retrying, so
  /// the UI should offer a bypass even for a mandatory update.
  bool get isInstallFailure;
  bool get isMandatory;
  String? get appVersion;
  double get downloadProgress;

  void addListener(VoidCallback listener);
  void removeListener(VoidCallback listener);

  Future<void> checkVersion();
  Future<void> downloadUpdate();
  Future<void> restartApp();

  /// Re-checks the real installed version against the update target.
  ///
  /// On Android the OS installer takes over the foreground, which tears
  /// down the plugin's event stream — so its outcome (success/failure) can
  /// be silently lost. Call this when the app resumes to find out what
  /// actually happened instead of trusting stale in-memory state.
  Future<bool> hasUpdateSucceeded();
}
