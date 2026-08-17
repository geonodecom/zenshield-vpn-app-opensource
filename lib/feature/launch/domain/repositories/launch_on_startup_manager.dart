abstract class AbstractLaunchOnStartupManager {
  Future<bool> isEnabled();
  Future<void> enable();
  Future<void> disable();
  Future<void> setup();

  /// Registers the app in Windows Run key so it can reconnect VPN after reboot.
  Future<void> enableForBootRestoreIfNeeded();

  /// Removes boot-restore auto-start only when this manager enabled it.
  Future<void> disableForBootRestoreIfNeeded();
}
