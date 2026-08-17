import 'dart:io';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/channels/channels.dart';

abstract class AbstractPlatformSettingsService {
  Future<bool> isIgnoringBatteryOptimizations();
  Future<bool> requestIgnoreBatteryOptimizations();
  Future<void> openBatteryOptimizationSettings();
  Future<bool> checkVpnPermission();
  Future<bool> isVpnActive();
}

@LazySingleton(as: AbstractPlatformSettingsService)
class PlatformSettingsService implements AbstractPlatformSettingsService {
  static final _platformChannel = MethodChannel(Channels.platformMethodsChannel);
  static const _methodChannel = MethodChannel('com.zenshield.vpn/method');

  @override
  Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? result = await _platformChannel.invokeMethod('is_ignoring_battery_optimizations');
      return result ?? true;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<bool> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? result = await _platformChannel.invokeMethod('request_ignore_battery_optimizations');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> openBatteryOptimizationSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await _platformChannel.invokeMethod('open_battery_optimization_settings');
    } catch (_) {}
  }

  @override
  Future<bool> checkVpnPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? result = await _methodChannel.invokeMethod('check_vpn_permission');
      return result ?? true;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<bool> isVpnActive() async {
    if (!Platform.isAndroid) return false;
    try {
      final bool? result = await _platformChannel.invokeMethod('is_vpn_active');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }
}
