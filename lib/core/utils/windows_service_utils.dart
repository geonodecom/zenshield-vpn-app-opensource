import 'dart:io';

class WindowsServiceUtils {
  static const String serviceName = 'singbox-tunnel';

  static bool hasSingboxTunnelExe() {
    if (!Platform.isWindows) return false;

    try {
      final executablePath = Platform.resolvedExecutable;
      final executableDir = File(executablePath).parent;
      final tunnelExe = File(
        '${executableDir.path}${Platform.pathSeparator}update${Platform.pathSeparator}singbox-tunnel.exe',
      );

      return tunnelExe.existsSync();
    } catch (e) {
      return false;
    }
  }

  static bool hasSingboxTunnelExeInUpdateFolder(String updateDir) {
    if (!Platform.isWindows || updateDir.isEmpty) return false;

    try {
      final tunnelExe = File(
        '$updateDir${Platform.pathSeparator}singbox-tunnel.exe',
      );
      return tunnelExe.existsSync();
    } catch (e) {
      return false;
    }
  }

  static String getStopAndDeleteServiceCommand() =>
      'sc.exe stop $serviceName && timeout /t 2 /nobreak >nul && sc.exe delete $serviceName';
}
