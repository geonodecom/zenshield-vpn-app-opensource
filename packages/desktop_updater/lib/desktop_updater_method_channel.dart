import "dart:io";

import "package:desktop_updater/desktop_updater_platform_interface.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";

/// An implementation of [DesktopUpdaterPlatform] that uses method channels.
class MethodChannelDesktopUpdater extends DesktopUpdaterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel("desktop_updater");

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>("getPlatformVersion");
    return version;
  }

  @override
  Future<void> restartApp({String? preElevatedCommand}) async {
    final dir = await getApplicationSupportDirectory();
    final updatePath = p.join(dir.path, "update");
    final args = <String, dynamic>{"updateDirectory": updatePath};
    if (preElevatedCommand != null && preElevatedCommand.isNotEmpty) {
      args["preElevatedCommand"] = preElevatedCommand;
    }
    await methodChannel.invokeMethod<void>("restartApp", args);
  }

  @override
  Future<String?> sayHello() async {
    return methodChannel.invokeMethod<String>("sayHello");
  }

  @override
  Future<String?> getExecutablePath() async {
    return methodChannel.invokeMethod<String>("getExecutablePath");
  }

  @override
  Future<void> updateApp({required String remoteUpdateFolder}) async {
    return methodChannel.invokeMethod<void>("updateApp", [remoteUpdateFolder]);
  }

  @override
  Future<String?> getCurrentVersion() async {
    return methodChannel.invokeMethod<String>("getCurrentVersion");
  }
}
