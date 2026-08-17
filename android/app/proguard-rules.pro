# gomobile / go.Seq runtime — must not be obfuscated or removed
-keep class go.** { *; }
-keep class com.vpnapp.zenshield.libbox.** { *; }

# Keep all classes that implement gomobile interfaces (callbacks from Go → Java)
-keep class * implements com.vpnapp.zenshield.libbox.PlatformInterface { *; }
-keep class * implements com.vpnapp.zenshield.libbox.CommandClientHandler { *; }
-keep class * implements com.vpnapp.zenshield.libbox.CommandServerHandler { *; }
-keep class * implements com.vpnapp.zenshield.libbox.InterfaceUpdateListener { *; }
-keep class * implements com.vpnapp.zenshield.libbox.LocalDNSTransport { *; }

# R8 full mode (default since AGP 8.0) was horizontally merging/inlining
# unrelated classes' constructors together, which corrupted
# DartExecutor's own constructor (it calls DartMessenger.setMessageHandler
# internally) and threw an NPE at app launch, before any app code runs.
# Flutter's bundled consumer rules assume compat-mode R8 and don't fully
# protect this under full mode. Keep the engine's dart/plugin machinery
# intact so its own init sequence isn't restructured.
-keep class io.flutter.embedding.engine.dart.** { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.embedding.engine.FlutterEngineGroup { *; }
-keep class io.flutter.plugin.common.** { *; }
