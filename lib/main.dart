import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/feature/launch/domain/repositories/launch_on_startup_manager.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/core/managers/appsflyer_manager.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/firebase_options.dart';
import 'package:zenshield/feature/app/presentation/app_view.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'package:ambilytics/ambilytics.dart' as ambilytics;
// Peer SDK (dart_peer_repo) — replaced by geonode_sdk package
// import 'package:dart_peer_repo/dart_sdk.dart';
// ignore: implementation_imports
// import 'package:dart_peer_repo/src/classes/singbox_monitor.dart';
// ignore: implementation_imports
// import 'package:dart_peer_repo/src/shared/global.dart' as geonode_global;
import 'package:event_bus/event_bus.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:eventify/eventify.dart';
import 'package:zenshield/core/event_bus_events/lifecycle_events.dart';
import 'package:zenshield/core/managers/geonode_sdk_manager.dart';
import 'package:zenshield/config/constants/common_constants.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Lock the app to portrait (no landscape) on mobile.
      if (!PlatformUtils.isDesktop) {
        await SystemChrome.setPreferredOrientations(
          const [DeviceOrientation.portraitUp],
        );
      }

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );

      await configureDependencies();
      await _setupFirebase();
      await _initAnalyticsManager();
      await _initAppsFlyer();
      await _initGeonodeSdk();

      if (PlatformUtils.isDesktop) {
        await windowManager.ensureInitialized();

        await _initLaunchOnStartup();

        _setupLifecycleListener();

        const windowSize = Size(400, 800);
        await windowManager.waitUntilReadyToShow(
          const WindowOptions(size: windowSize, title: 'Zenshield VPN'),
          () async {
            await windowManager.setMinimumSize(windowSize);
            await windowManager.setMaximumSize(windowSize);
            await windowManager.show();
            await windowManager.focus();
          },
        );
      }

      runApp(
        DevicePreview(
          enabled: false,
          builder: (context) => const App(),
        ),
      );
    },
    (error, stack) {
      try {
        final logger = getIt<Talker>();
        logger.critical('Unhandled exception: $error', error, stack);

        if (_firebaseReady && !Platform.isWindows) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        }
      } catch (e) {
        debugPrint('Critical error: $error');
        debugPrint('Stack trace: $stack');
      }
    },
  );
}
Future<void> _initLaunchOnStartup() async {
  try {
    final launchOnStartupManager = getIt<AbstractLaunchOnStartupManager>();
    await launchOnStartupManager.setup();
  } catch (e) {
    getIt<Talker>().error('Failed to initialize launch at startup service', e);
  }
}

/// Whether `Firebase.initializeApp` succeeded. This repo ships a placeholder
/// `firebase_options.dart`/`google-services.json` (see .gitignore) so the app
/// builds and runs without any Firebase project configured — in that case
/// initialization fails here and Crashlytics/ambilytics are skipped for the
/// rest of the app's life instead of crashing. Run `flutterfire configure` to
/// set up a real project and enable them.
bool _firebaseReady = false;

Future<void> _setupFirebase() async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    _firebaseReady = true;
  } catch (e, st) {
    debugPrint(
      '[Firebase] initializeApp failed — Crashlytics and Windows analytics '
      'will be disabled for this run. Run `flutterfire configure` to set up '
      'your own Firebase project. Error: $e\n$st',
    );
  }

  FlutterError.onError = (details) {
    final logger = getIt<Talker>();
    logger.error(
      'Flutter rendering error: ${details.exception}. Stack trace: ${details.stack}',
      details.exception,
      details.stack,
    );

    if (_firebaseReady && !Platform.isWindows) {
      try {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      } catch (e) {
        debugPrint('[Crashlytics] recordFlutterFatalError failed: $e');
      }
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    final logger = getIt<Talker>();
    logger.critical('Platform error: $error', error, stack);

    if (_firebaseReady && !Platform.isWindows) {
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } catch (e) {
        debugPrint('[Crashlytics] recordError failed: $e');
      }
    }
    return true;
  };

  if (_firebaseReady && Platform.isWindows) {
    try {
      await ambilytics.initAnalytics(
        measurementId: CommonConstants.ambilyticsMeasurementId,
        apiSecret: CommonConstants.ambilyticsApiSecret,
        firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('[ambilytics] initAnalytics failed: $e');
    }
  }
}

Future<void> _initAppsFlyer() async {
  if (!Platform.isAndroid) return;
  try {
    await getIt<AbstractAppsFlyerManager>().init();
  } catch (e) {
    getIt<Talker>().error('Failed to initialize AppsFlyer', e);
  }
}

Future<void> _initAnalyticsManager() async {
  final analyticsManager = getIt<AbstractAnalyticsManager>();
  await analyticsManager.init();

  final auth = getIt<AbstractAuthUserUseCase>();
  if (!await auth.isAuthorized()) return;
  final userId = await auth.getUserId();
  if (userId == null || userId.isEmpty) return;
  final email = await auth.getStoredAccountEmail();
  await analyticsManager.identify(distinctId: userId, email: email);
}

Future<void> _initGeonodeSdk() async {
  // --- Peer SDK (dart_peer_repo) — commented out, replaced by geonode_sdk ---
  // _setupCurlLogCallback();
  // _setupPeerMonitorLogCallback();
  // SDKPeerClient.init(
  //   sdkApiKey: Platform.isWindows ? CommonConstants.geonodeSdkApiKeyWindows
  //   : Platform.isAndroid ? CommonConstants.geonodeSdkApiKeyAndroid
  //   : Platform.isMacOS ? CommonConstants.geonodeSdkApiKeyMacOS : "",
  //   isDebug: true,
  // );
  // _setupGeonodeEventEmitterLogging();
  // SingboxMonitor().startMonitoring();

  final auth = getIt<AbstractAuthUserUseCase>();
  if (!await auth.isAuthorized()) return;

  final userId = await auth.getUserId();
  if (userId == null || userId.isEmpty) return;

  await getIt<AbstractGeonodeSdkManager>().connectForUser(userId);
}

// --- Peer SDK callbacks — commented out ---
// void _setupCurlLogCallback() {
//   final geonodeCurlLogManager = getIt<GeonodeCurlLogManager>();
//   geonode_global.setCurlLogCallback(geonodeCurlLogManager.saveCurlLog);
// }
//
// void _setupPeerMonitorLogCallback() {
//   final logger = getIt<Talker>();
//   geonode_global.setLogCallback((message) {
//     logger.info('[Geonode] $message');
//   });
// }
//
// void _setupGeonodeEventEmitterLogging() {
//   _trySetupEventEmitterLogging(attempt: 1);
// }
//
// void _trySetupEventEmitterLogging({
//   int attempt = 1,
//   int maxAttempts = 5,
// }) async {
//   try {
//     final emitter = await SDKPeerClient.getEventEmitter();
//     final logger = getIt<Talker>();
//
//     final events = [
//       'connected',
//       'disconnected',
//       'connecting',
//       'refresh_token',
//       'peer_server_error',
//       'peer_client_error',
//     ];
//
//     for (final eventName in events) {
//       emitter.on(eventName, null, (event, context) {
//         final eventData = event.eventData != null ? ': ${event.eventData}' : '';
//         logger.info('[GeoNode Status] Event: $eventName$eventData');
//       });
//     }
//
//     logger.info('[GeoNode Status] EventEmitter logging initialized');
//   } catch (e) {
//     if (attempt < maxAttempts) {
//       Future.delayed(const Duration(seconds: 1), () {
//         _trySetupEventEmitterLogging(
//           attempt: attempt + 1,
//           maxAttempts: maxAttempts,
//         );
//       });
//     } else {
//       final logger = getIt<Talker>();
//       logger.warning(
//         '[GeoNode Status] Failed to setup EventEmitter logging after $maxAttempts attempts: $e',
//       );
//     }
//   }
// }

void _setupLifecycleListener() {
  final eventBus = getIt<EventBus>();
  eventBus.on<OnDetachedLifecycleEvent>().listen((_) {
    getIt<AbstractGeonodeSdkManager>().disconnect();
  });
}
