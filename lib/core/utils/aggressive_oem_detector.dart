import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Detects Android OEMs whose custom battery managers kill background work
/// far more aggressively than stock Android (see dontkillmyapp.com). Only on
/// these devices is it worth interrupting the user with the battery
/// optimization prompt; stock/near-stock Android keeps an active VpnService
/// alive without an exemption.
class AggressiveOemDetector {
  AggressiveOemDetector._();

  static const _aggressiveOems = {
    'xiaomi',
    'redmi',
    'poco',
    'huawei',
    'honor',
    'oppo',
    'realme',
    'oneplus',
    'vivo',
    'iqoo',
    'meizu',
    'tecno',
    'infinix',
    'itel',
  };

  static bool? _cached;

  static Future<bool> isAggressiveBatteryOem() async {
    if (!Platform.isAndroid) return false;
    if (_cached != null) return _cached!;

    final info = await DeviceInfoPlugin().androidInfo;
    final identifiers = [
      info.manufacturer,
      info.brand,
    ].map((value) => value.toLowerCase());
    _cached = identifiers.any(
      (id) => _aggressiveOems.any(id.contains),
    );
    return _cached!;
  }
}
