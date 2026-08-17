import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:zenshield/core/preferences.dart';

abstract class AbstractDeviceInfoProvider {
  Future<String> getDeviceOs();

  Future<String> getOsVersion();

  Future<String> getDeviceModel();

  Future<String?> getArchitecture();

  Future<String> getHwid();
}

@Injectable(as: AbstractDeviceInfoProvider)
class DeviceInfoProvider implements AbstractDeviceInfoProvider {
  DeviceInfoProvider({
    required DeviceInfoPlugin deviceInfo,
    required Preferences preferences,
  })  : _deviceInfo = deviceInfo,
        _preferences = preferences,
        _uuid = const Uuid();

  final DeviceInfoPlugin _deviceInfo;
  final Preferences _preferences;
  final Uuid _uuid;

  @override
  Future<String> getDeviceOs() async {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else if (Platform.isMacOS) {
      return 'macOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    }
    return 'Unknown';
  }

  @override
  Future<String> getOsVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfo.macOsInfo;
      return macInfo.osRelease;
    } else if (Platform.isWindows) {
      final windowsInfo = await _deviceInfo.windowsInfo;
      return windowsInfo.productName;
    }
    return 'Unknown';
  }

  @override
  Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfo.macOsInfo;
      return macInfo.model;
    } else if (Platform.isWindows) {
      final windowsInfo = await _deviceInfo.windowsInfo;
      return windowsInfo.computerName;
    }
    return 'Unknown';
  }

  @override
  Future<String?> getArchitecture() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.supportedAbis.isNotEmpty
          ? androidInfo.supportedAbis.first
          : null;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfo.macOsInfo;
      return macInfo.arch;
    } else if (Platform.isWindows) {
      return 'x64';
    }
    return null;
  }

  @override
  Future<String> getHwid() async {
    String? id;

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      final androidId = androidInfo.id;
      if (androidId.isNotEmpty) {
        id = androidId.replaceAll('-', '');
      }
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfo.macOsInfo;
      final guid = macInfo.systemGUID;
      if (guid != null && guid.isNotEmpty) {
        id = guid.replaceAll('{', '').replaceAll('}', '').replaceAll('-', '').toLowerCase();
      }
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      final vendorId = iosInfo.identifierForVendor;
      if (vendorId != null && vendorId.isNotEmpty) {
        id = vendorId.replaceAll('-', '');
      }
    } else if (Platform.isWindows) {
      final deviceInfo = await _deviceInfo.windowsInfo;
      final deviceId = deviceInfo.deviceId;
      id = deviceId.replaceAll('{', '').replaceAll('}', '').toLowerCase();
    }

    if (id != null) {
      return _normalizeHwid(id);
    }

    final savedHwid = await _preferences.hwid;
    if (savedHwid != null && savedHwid.isNotEmpty) {
      return savedHwid;
    }

    final generated = _uuid.v4();
    final cleaned = _normalizeHwid(generated);
    await _preferences.setHwid(cleaned);
    return cleaned;
  }

  String _normalizeHwid(String input) {
    final cleaned = input.replaceAll('-', '').toUpperCase();
    if (cleaned.isEmpty) {
      // Keep non-empty id contract even in unexpected edge cases.
      return 'UNKNOWNHWID000000';
    }
    final end = cleaned.length < 16 ? cleaned.length : 16;
    return cleaned.substring(0, end);
  }
}
