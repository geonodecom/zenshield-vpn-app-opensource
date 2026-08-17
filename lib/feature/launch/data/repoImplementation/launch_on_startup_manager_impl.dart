import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:launch_at_startup/launch_at_startup.dart' as launch_at_startup;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/feature/launch/data/dataSources/windows_startup_registry.dart';
import 'package:zenshield/feature/launch/domain/repositories/launch_on_startup_manager.dart';

@Injectable(as: AbstractLaunchOnStartupManager)
class LaunchOnStartupManager implements AbstractLaunchOnStartupManager {
  LaunchOnStartupManager({
    required PackageInfo packageInfo,
    required Preferences preferences,
    required Talker logger,
  })  : _packageInfo = packageInfo,
        _preferences = preferences,
        _logger = logger;

  final PackageInfo _packageInfo;
  final Preferences _preferences;
  final Talker _logger;

  WindowsStartupRegistry? _windowsStartupRegistry;

  String get _startupAppName =>
      Platform.isWindows ? windowsStartupAppName() : _packageInfo.appName;

  WindowsStartupRegistry get _windowsRegistry {
    return _windowsStartupRegistry ??= WindowsStartupRegistry(
      appName: _startupAppName,
      appPath: Platform.resolvedExecutable,
    );
  }

  @override
  Future<void> setup() async {
    try {
      if (!PlatformUtils.isDesktop) {
        return;
      }

      if (Platform.isWindows) {
        _windowsRegistry;
      } else {
        launch_at_startup.launchAtStartup.setup(
          appName: _startupAppName,
          appPath: Platform.resolvedExecutable,
        );
      }
      _logger.info('Launch on startup manager initialized');
    } catch (e, st) {
      _logger.error('Failed to setup launch on startup', e, st);
    }
  }

  @override
  Future<bool> isEnabled() async {
    try {
      if (!PlatformUtils.isDesktop) {
        return false;
      }
      if (Platform.isWindows) {
        return _windowsRegistry.isEnabled();
      }
      return launch_at_startup.launchAtStartup.isEnabled();
    } catch (e, st) {
      _logger.error('Failed to check launch on startup status', e, st);
      return false;
    }
  }

  @override
  Future<void> enable() async {
    try {
      if (!PlatformUtils.isDesktop) {
        _logger
            .info('Launch on startup is only available on desktop platforms');
        return;
      }

      if (Platform.isWindows) {
        await _windowsRegistry.enable();
      } else {
        await launch_at_startup.launchAtStartup.enable();
      }
      _logger.info('Launch on startup enabled successfully');
    } catch (e, st) {
      _logger.error('Failed to enable launch on startup', e, st);
      rethrow;
    }
  }

  @override
  Future<void> disable() async {
    try {
      if (!PlatformUtils.isDesktop) {
        _logger
            .info('Launch on startup is only available on desktop platforms');
        return;
      }

      if (Platform.isWindows) {
        await _windowsRegistry.disable();
      } else {
        await launch_at_startup.launchAtStartup.disable();
      }
      _logger.info('Launch on startup disabled successfully');
    } catch (e, st) {
      _logger.error('Failed to disable launch on startup', e, st);
      rethrow;
    }
  }

  @override
  Future<void> enableForBootRestoreIfNeeded() async {
    if (!Platform.isWindows) return;

    try {
      if (await isEnabled()) {
        return;
      }

      await enable();
      await _preferences.setBootRestoreManagedLaunchOnStartup(true);
      _logger.info('Launch on startup enabled for VPN boot restore');
    } catch (e, st) {
      _logger.error('Failed to enable launch on startup for boot restore', e, st);
    }
  }

  @override
  Future<void> disableForBootRestoreIfNeeded() async {
    if (!Platform.isWindows) return;

    try {
      if (!await _preferences.bootRestoreManagedLaunchOnStartup) {
        return;
      }

      await disable();
      await _preferences.setBootRestoreManagedLaunchOnStartup(false);
      _logger.info('Launch on startup disabled after VPN disconnect');
    } catch (e, st) {
      _logger.error('Failed to disable launch on startup for boot restore', e, st);
    }
  }
}
