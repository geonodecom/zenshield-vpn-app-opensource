// ignore_for_file: unused-code
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/interceptors/auth_interceptor.dart';
import 'package:zenshield/di/injection_container.config.dart';
import 'package:zenshield/feature/singbox/data/command_client/command_client_factory.dart';
import 'package:zenshield/feature/singbox/data/command_client/socket_service.dart';
import 'package:zenshield/feature/singbox/data/ffi_singbox_service.dart';
import 'package:zenshield/feature/singbox/data/platform_singbox_service.dart';
import 'package:zenshield/feature/singbox/data/singbox_service.dart';
import 'package:zenshield/core/utils/talker_observer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/route/app_router.dart';
import 'package:zenshield/core/loggers/file_talker_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@module
abstract class EventBusModule {
  @lazySingleton
  EventBus get eventBus => EventBus();
}

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(TalkerDioLogger talkerDioLogger, AuthInterceptor authInterceptor) {
    final dio = Dio();
    dio.interceptors.add(talkerDioLogger);
    dio.interceptors.add(authInterceptor);
    return dio;
  }
}

@module
abstract class DeviceInfoModule {
  @lazySingleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();
}

@module
abstract class ConnectivityModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}

@module
abstract class PackageInfoModule {
  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}

@module
abstract class SharedPreferencesModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}

@module
abstract class LoggerModule {
  @lazySingleton
  Talker talker() {
    final talker = TalkerFlutter.init(
      settings: TalkerSettings(
        useConsoleLogs: !kReleaseMode,
        useHistory: true,
        colors: {TalkerLogType.info.key: AnsiPen()..cyan()},
      ),
    );

    final fileLogger = FileTalkerLogger(enableInRelease: false);
    fileLogger.startLogging(talker);

    fileLogger.getLogFilePath().then((path) {
      if (path != null) {
        talker.info('Logs will be saved to: $path');
      }
    });

    return talker;
  }

  @lazySingleton
  TalkerDioLogger talkerDioLogger(Talker talker) {
    return TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: false,
        printRequestData: true,
        printResponseData: true,
      ),
    );
  }

  @preResolve
  @lazySingleton
  Future<CustomTalkerBlocObserver> talkerBlocObserver(Talker talker) async {
    final observer = CustomTalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEvents: true,
        printTransitions: true,
        printEventFullData: true,
        printStateFullData: true,
      ),
    );

    Bloc.observer = observer;
    return observer;
  }
}

@module
abstract class SecureStorageModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}

@module
abstract class SingboxModule {
  @lazySingleton
  SingboxService singboxService(
    AbstractCommandClientFactory commandClientFactory,
    AbstractSocketService socketService,
    Talker logger,
  ) {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      return PlatformSingboxService(
        commandClientFactory: commandClientFactory,
        logger: logger,
      );
    } else if (Platform.isWindows) {
      return FFISingboxService(
        commandClientFactory: commandClientFactory,
        logger: logger,
      );
    }
    throw UnsupportedError('Unsupported platform');
  }
}

@module
abstract class RouterModule {
  @LazySingleton()
  AppRouter appRouter() => AppRouter();
}

@InjectableInit()
Future<void> configureDependencies() => getIt.init();
