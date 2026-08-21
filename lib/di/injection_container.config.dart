// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:dio/dio.dart' as _i361;
import 'package:event_bus/event_bus.dart' as _i1017;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart' as _i162;
import 'package:talker_flutter/talker_flutter.dart' as _i207;
import 'package:zenshield/core/interceptors/auth_interceptor.dart' as _i631;
import 'package:zenshield/core/preferences.dart' as _i927;
import 'package:zenshield/core/route/app_router.dart' as _i782;
import 'package:zenshield/core/services/platform_settings_service.dart' as _i11;
import 'package:zenshield/core/utils/talker_observer.dart' as _i161;
import 'package:zenshield/di/injection_container.dart' as _i721;
import 'package:zenshield/feature/auth/data/auth_repository.dart' as _i271;
import 'package:zenshield/feature/auth/data/auth_session_repository.dart'
    as _i771;
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart' as _i622;
import 'package:zenshield/feature/deep_links/data/dataSources/deep_link_service.dart'
    as _i550;
import 'package:zenshield/feature/deep_links/data/repoImplementation/deep_link_handler.dart'
    as _i237;
import 'package:zenshield/feature/launch/data/repoImplementation/launch_on_startup_manager_impl.dart'
    as _i62;
import 'package:zenshield/feature/launch/data/repoImplementation/launch_use_case_impl.dart'
    as _i471;
import 'package:zenshield/feature/launch/domain/repositories/launch_on_startup_manager.dart'
    as _i23;
import 'package:zenshield/feature/launch/domain/useCase/launch_use_case.dart'
    as _i906;
import 'package:zenshield/feature/network_monitor/data/repoImplementation/network_monitor_impl.dart'
    as _i494;
import 'package:zenshield/feature/network_monitor/domain/repositories/network_monitor.dart'
    as _i596;
import 'package:zenshield/feature/servers/data/repoImplementation/servers_repository_impl.dart'
    as _i826;
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart'
    as _i117;
import 'package:zenshield/feature/singbox/data/command_client/command_client_factory.dart'
    as _i336;
import 'package:zenshield/feature/singbox/data/command_client/message_buffer.dart'
    as _i323;
import 'package:zenshield/feature/singbox/data/command_client/socket_service.dart'
    as _i316;
import 'package:zenshield/feature/singbox/data/singbox_service.dart' as _i801;
import 'package:zenshield/feature/timer/data/repoImplementation/timer_control.dart'
    as _i868;
import 'package:zenshield/feature/timer/data/repoImplementation/timer_factory_impl.dart'
    as _i688;
import 'package:zenshield/feature/timer/domain/repositories/abstract_timer_control.dart'
    as _i767;
import 'package:zenshield/feature/timer/domain/repositories/timer_factory.dart'
    as _i884;
import 'package:zenshield/feature/user_info/data/repoImplementation/user_info_use_case_impl.dart'
    as _i475;
import 'package:zenshield/feature/user_info/domain/useCase/user_info_use_case.dart'
    as _i115;
import 'package:zenshield/feature/vpn_config/data/repoImplementation/vpn_config_repository_impl.dart'
    as _i962;
import 'package:zenshield/feature/vpn_config/domain/repositories/vpn_config_repository.dart'
    as _i262;
import 'package:zenshield/feature/vpn_connection/data/repoImplementation/vpn_manager.dart'
    as _i222;
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart'
    as _i603;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final packageInfoModule = _$PackageInfoModule();
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final eventBusModule = _$EventBusModule();
    final deviceInfoModule = _$DeviceInfoModule();
    final connectivityModule = _$ConnectivityModule();
    final loggerModule = _$LoggerModule();
    final secureStorageModule = _$SecureStorageModule();
    final routerModule = _$RouterModule();
    final singboxModule = _$SingboxModule();
    final dioModule = _$DioModule();
    await gh.factoryAsync<_i655.PackageInfo>(
      () => packageInfoModule.packageInfo,
      preResolve: true,
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i323.MessageBuffer>(() => _i323.MessageBuffer());
    gh.singleton<_i927.Preferences>(() => _i927.Preferences());
    gh.lazySingleton<_i1017.EventBus>(() => eventBusModule.eventBus);
    gh.lazySingleton<_i833.DeviceInfoPlugin>(
      () => deviceInfoModule.deviceInfoPlugin,
    );
    gh.lazySingleton<_i895.Connectivity>(() => connectivityModule.connectivity);
    gh.lazySingleton<_i207.Talker>(() => loggerModule.talker());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => secureStorageModule.secureStorage,
    );
    gh.lazySingleton<_i782.AppRouter>(() => routerModule.appRouter());
    gh.lazySingleton<_i550.DeepLinkService>(() => _i550.DeepLinkService());
    gh.factory<_i336.AbstractCommandClientFactory>(
      () => _i336.CommandClientFactory(logger: gh<_i207.Talker>()),
    );
    gh.factory<_i906.AbstractLaunchUseCase>(
      () => _i471.LaunchUseCaseImpl(preferences: gh<_i927.Preferences>()),
    );
    gh.lazySingleton<_i771.AuthSessionRepository>(
      () => _i771.InMemoryAuthSessionRepository(),
    );
    gh.lazySingleton<_i11.AbstractPlatformSettingsService>(
      () => _i11.PlatformSettingsService(),
    );
    gh.lazySingleton<_i162.TalkerDioLogger>(
      () => loggerModule.talkerDioLogger(gh<_i207.Talker>()),
    );
    await gh.lazySingletonAsync<_i161.CustomTalkerBlocObserver>(
      () => loggerModule.talkerBlocObserver(gh<_i207.Talker>()),
      preResolve: true,
    );
    gh.lazySingleton<_i237.DeepLinkHandler>(
      () => _i237.DeepLinkHandler(
        gh<_i550.DeepLinkService>(),
        gh<_i1017.EventBus>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i316.AbstractSocketService>(
      () => _i316.SocketService(gh<_i207.Talker>(), gh<_i323.MessageBuffer>()),
    );
    gh.lazySingleton<_i596.AbstractNetworkMonitor>(
      () => _i494.NetworkMonitor(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i801.SingboxService>(
      () => singboxModule.singboxService(
        gh<_i336.AbstractCommandClientFactory>(),
        gh<_i316.AbstractSocketService>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.lazySingleton<_i767.AbstractTimerControl>(
      () => _i868.TimerControl(
        eventBus: gh<_i1017.EventBus>(),
        preferences: gh<_i927.Preferences>(),
        logger: gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i23.AbstractLaunchOnStartupManager>(
      () => _i62.LaunchOnStartupManager(
        packageInfo: gh<_i655.PackageInfo>(),
        preferences: gh<_i927.Preferences>(),
        logger: gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i631.AuthInterceptor>(
      () => _i631.AuthInterceptor(
        secureStorage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i884.AbstractTimerFactory>(
      () => _i688.TimerFactory(timer: gh<_i767.AbstractTimerControl>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(
        gh<_i162.TalkerDioLogger>(),
        gh<_i631.AuthInterceptor>(),
      ),
    );
    gh.factory<_i271.AbstractAuthRepository>(
      () => _i271.AuthRepository(
        gh<_i361.Dio>(),
        gh<_i207.Talker>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i622.AbstractAuthUserUseCase>(
      () => _i622.AuthUseCase(
        gh<_i361.Dio>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i271.AbstractAuthRepository>(),
        gh<_i833.DeviceInfoPlugin>(),
        gh<_i207.Talker>(),
        gh<_i771.AuthSessionRepository>(),
      ),
    );
    gh.factory<_i115.AbstractUserInfoUseCase>(
      () => _i475.UserInfoUseCase(gh<_i361.Dio>(), gh<_i207.Talker>()),
    );
    gh.factory<_i117.AbstractServersRepository>(
      () => _i826.ServersRepository(
        httpClient: gh<_i361.Dio>(),
        preferences: gh<_i927.Preferences>(),
        logger: gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i262.AbstractVpnConfigRepository>(
      () => _i962.VpnConfigRepository(
        gh<_i117.AbstractServersRepository>(),
        gh<_i927.Preferences>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.lazySingleton<_i603.AbstractVpnManager>(
      () => _i222.VpnManager(
        singboxService: gh<_i801.SingboxService>(),
        timerFactory: gh<_i884.AbstractTimerFactory>(),
        configRepository: gh<_i262.AbstractVpnConfigRepository>(),
        preferences: gh<_i927.Preferences>(),
        launchOnStartupManager: gh<_i23.AbstractLaunchOnStartupManager>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
        logger: gh<_i207.Talker>(),
        eventBus: gh<_i1017.EventBus>(),
        serversRepository: gh<_i117.AbstractServersRepository>(),
        platformSettingsService: gh<_i11.AbstractPlatformSettingsService>(),
      ),
    );
    return this;
  }
}

class _$PackageInfoModule extends _i721.PackageInfoModule {}

class _$SharedPreferencesModule extends _i721.SharedPreferencesModule {}

class _$EventBusModule extends _i721.EventBusModule {}

class _$DeviceInfoModule extends _i721.DeviceInfoModule {}

class _$ConnectivityModule extends _i721.ConnectivityModule {}

class _$LoggerModule extends _i721.LoggerModule {}

class _$SecureStorageModule extends _i721.SecureStorageModule {}

class _$RouterModule extends _i721.RouterModule {}

class _$SingboxModule extends _i721.SingboxModule {}

class _$DioModule extends _i721.DioModule {}
