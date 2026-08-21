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
import 'package:zenshield/firebase_options.dart';
import 'package:zenshield/feature/app/presentation/app_view.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'package:ambilytics/ambilytics.dart' as ambilytics;
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

      if (PlatformUtils.isDesktop) {
        await windowManager.ensureInitialized();

        await _initLaunchOnStartup();

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

