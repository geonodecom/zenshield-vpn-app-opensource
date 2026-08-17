import 'dart:io';
import 'dart:typed_data';

import 'package:win32_registry/win32_registry.dart';

/// Windows Run-key auto-start with quoted executable paths (required for
/// paths containing spaces, e.g. `C:\Program Files\...`).
class WindowsStartupRegistry {
  WindowsStartupRegistry({
    required this.appName,
    required String appPath,
  }) : _registryValue = _quotedExecutablePath(appPath);

  final String appName;
  final String _registryValue;

  static const _runKeyPath = r'Software\Microsoft\Windows\CurrentVersion\Run';
  static const _startupApprovedKeyPath =
      r'Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run';
  static const _startupApprovedRegKeyBytesLength = 12;

  RegistryKey? _openKey(String path, {bool writeAccess = false}) {
    try {
      return Registry.openPath(
        RegistryHive.currentUser,
        path: path,
        desiredAccessRights: writeAccess ? AccessRights.allAccess : AccessRights.readOnly,
      );
    } catch (_) {
      if (writeAccess) {
        // Fall back to read-only if write access fails (for checks)
        try {
          return Registry.openPath(
            RegistryHive.currentUser,
            path: path,
            desiredAccessRights: AccessRights.readOnly,
          );
        } catch (_) {
          return null;
        }
      }
      return null;
    }
  }

  RegistryKey? get _runKeyReadOnly => _openKey(_runKeyPath, writeAccess: false);
  RegistryKey? get _runKeyWrite => _openKey(_runKeyPath, writeAccess: true);

  RegistryKey? get _startupApprovedKeyReadOnly => _openKey(_startupApprovedKeyPath, writeAccess: false);
  RegistryKey? get _startupApprovedKeyWrite => _openKey(_startupApprovedKeyPath, writeAccess: true);

  static String _quotedExecutablePath(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('"') && trimmed.endsWith('"')) {
      return trimmed;
    }
    if (trimmed.contains(' ')) {
      return '"$trimmed"';
    }
    return trimmed;
  }

  Future<bool> isEnabled() async {
    try {
      final key = _runKeyReadOnly;
      if (key == null) return false;

      final value = key.getStringValue(appName);
      return value == _registryValue && await _isStartupApproved();
    } catch (_) {
      return false;
    }
  }

  Future<bool> enable() async {
    try {
      final key = _runKeyWrite;
      if (key == null) return false;
      key.createValue(
        RegistryValue.string(appName, _registryValue),
      );

      final approvedKey = _startupApprovedKeyWrite;
      if (approvedKey != null) {
        final bytes = Uint8List(_startupApprovedRegKeyBytesLength);
        bytes[0] = 2;
        approvedKey.createValue(RegistryValue.binary(appName, bytes));
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> disable() async {
    try {
      final key = _runKeyWrite;
      if (key != null) {
        _removeValue(key, appName);
      }
      final approvedKey = _startupApprovedKeyWrite;
      if (approvedKey != null) {
        _removeValue(approvedKey, appName);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _isStartupApproved() async {
    try {
      final approvedKey = _startupApprovedKeyReadOnly;
      if (approvedKey == null) {
        return true;
      }

      final bytes = approvedKey.getBinaryValue(appName);
      if (bytes == null || bytes.isEmpty) {
        return true;
      }

      return bytes[0].isEven;
    } catch (_) {
      return true;
    }
  }

  void _removeValue(RegistryKey key, String value) {
    try {
      if (key.getValue(value) != null) {
        key.deleteValue(value);
      }
    } catch (_) {}
  }
}

String windowsStartupAppName() {
  if (!Platform.isWindows) {
    throw StateError('windowsStartupAppName is only supported on Windows');
  }
  return 'Zenshield VPN';
}

