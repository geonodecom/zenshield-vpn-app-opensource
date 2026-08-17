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
import 'package:zenshield/core/managers/analytics_manager.dart' as _i228;
import 'package:zenshield/core/managers/appsflyer_manager.dart' as _i1058;
import 'package:zenshield/core/managers/geonode_curl_log_manager.dart' as _i89;
import 'package:zenshield/core/managers/geonode_sdk_manager.dart' as _i264;
import 'package:zenshield/core/preferences.dart' as _i927;
import 'package:zenshield/core/route/app_router.dart' as _i782;
import 'package:zenshield/core/services/device_info_provider.dart' as _i915;
import 'package:zenshield/core/services/platform_settings_service.dart' as _i11;
import 'package:zenshield/core/storage/appsflyer_event_flags_store.dart'
    as _i714;
import 'package:zenshield/core/storage/cf_click_id_store.dart' as _i495;
import 'package:zenshield/core/utils/talker_observer.dart' as _i161;
import 'package:zenshield/di/injection_container.dart' as _i721;
import 'package:zenshield/feature/agreements/data/repoImplementation/agreement_repository_impl.dart'
    as _i691;
import 'package:zenshield/feature/agreements/data/repoImplementation/agreement_use_case_impl.dart'
    as _i205;
import 'package:zenshield/feature/agreements/domain/repositories/agreement_repository.dart'
    as _i951;
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart'
    as _i499;
import 'package:zenshield/feature/android_updater/data/repoImplementation/android_updater_use_case.dart'
    as _i667;
import 'package:zenshield/feature/app_version/data/repoImplementation/app_version_use_case_impl.dart'
    as _i831;
import 'package:zenshield/feature/app_version/domain/useCase/app_version_use_case.dart'
    as _i668;
import 'package:zenshield/feature/auth/data/auth_repository.dart' as _i271;
import 'package:zenshield/feature/auth/data/auth_session_repository.dart'
    as _i771;
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart' as _i622;
import 'package:zenshield/feature/auth/data/login_error_message_use_case.dart'
    as _i103;
import 'package:zenshield/feature/deep_links/data/dataSources/deep_link_service.dart'
    as _i550;
import 'package:zenshield/feature/deep_links/data/repoImplementation/deep_link_handler.dart'
    as _i237;
import 'package:zenshield/feature/desktop_updater/data/repoImplementation/desktop_updater_use_case_impl.dart'
    as _i13;
import 'package:zenshield/feature/desktop_updater/domain/useCase/desktop_updater_use_case.dart'
    as _i739;
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
import 'package:zenshield/feature/rating/data/dataSources/platform_review_requester.dart'
    as _i1071;
import 'package:zenshield/feature/rating/data/repoImplementation/rating_use_case_impl.dart'
    as _i1059;
import 'package:zenshield/feature/rating/domain/useCase/rating_use_case.dart'
    as _i839;
import 'package:zenshield/feature/region_checker/data/dataSources/region_remote_data_source.dart'
    as _i819;
import 'package:zenshield/feature/region_checker/data/repoImplementation/region_service.dart'
    as _i463;
import 'package:zenshield/feature/region_checker/domain/repositories/region_repository.dart'
    as _i154;
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
import 'package:zenshield/feature/user_feedback/data/repoImplementation/user_feedback_use_case_impl.dart'
    as _i91;
import 'package:zenshield/feature/user_feedback/domain/useCase/user_feedback_use_case.dart'
    as _i611;
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
import 'package:zenshield/feature/windows_updater/data/repoImplementation/windows_updater_use_case.dart'
    as _i501;

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
    final platformReviewRequesterModule = _$PlatformReviewRequesterModule();
    final singboxModule = _$SingboxModule();
    final dioModule = _$DioModule();
    final updaterModule = _$UpdaterModule();
    await gh.factoryAsync<_i655.PackageInfo>(
      () => packageInfoModule.packageInfo,
      preResolve: true,
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i1071.AndroidReviewRequester>(
      () => _i1071.AndroidReviewRequester(),
    );
    gh.factory<_i1071.DefaultReviewRequester>(
      () => _i1071.DefaultReviewRequester(),
    );
    gh.factory<_i323.MessageBuffer>(() => _i323.MessageBuffer());
    gh.singleton<_i927.Preferences>(() => _i927.Preferences());
    gh.lazySingleton<_i89.GeonodeCurlLogManager>(
      () => _i89.GeonodeCurlLogManager(),
    );
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
    gh.lazySingleton<_i714.AbstractAppsflyerEventFlagsStore>(
      () => _i714.AppsflyerEventFlagsStore(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i13.DesktopUpdaterUseCase>(
      () => _i13.DesktopUpdaterUseCase(gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i495.AbstractCfClickIdStore>(
      () => _i495.CfClickIdStore(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i839.AbstractRatingUseCase>(
      () => _i1059.RatingUseCase(gh<_i927.Preferences>()),
    );
    gh.lazySingleton<_i1071.AbstractPlatformReviewRequester>(
      () => platformReviewRequesterModule.platformReviewRequester(
        gh<_i1071.AndroidReviewRequester>(),
        gh<_i1071.DefaultReviewRequester>(),
      ),
    );
    gh.lazySingleton<_i103.AbstractLoginErrorMessageUseCase>(
      () => _i103.LoginErrorMessageUseCase(),
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
    gh.factory<_i915.AbstractDeviceInfoProvider>(
      () => _i915.DeviceInfoProvider(
        deviceInfo: gh<_i833.DeviceInfoPlugin>(),
        preferences: gh<_i927.Preferences>(),
      ),
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
    gh.lazySingleton<_i228.AbstractAnalyticsManager>(
      () => _i228.AnalyticsManager(
        gh<_i655.PackageInfo>(),
        gh<_i495.AbstractCfClickIdStore>(),
        gh<_i558.FlutterSecureStorage>(),
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
    gh.lazySingleton<_i1058.AbstractAppsFlyerManager>(
      () => _i1058.AppsFlyerManager(
        gh<_i207.Talker>(),
        gh<_i495.AbstractCfClickIdStore>(),
        gh<_i714.AbstractAppsflyerEventFlagsStore>(),
      ),
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
    gh.factory<_i819.AbstractRegionRemoteDataSource>(
      () => _i819.RegionRemoteDataSource(
        logger: gh<_i207.Talker>(),
        httpClient: gh<_i361.Dio>(),
      ),
    );
    gh.factory<_i951.AbstractAgreementRepository>(
      () => _i691.AgreementRepository(gh<_i361.Dio>(), gh<_i207.Talker>()),
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
    gh.factory<_i611.AbstractUserFeedbackUseCase>(
      () => _i91.UserFeedbackUseCase(
        logger: gh<_i207.Talker>(),
        httpClient: gh<_i361.Dio>(),
        singboxService: gh<_i801.SingboxService>(),
        deviceInfo: gh<_i833.DeviceInfoPlugin>(),
        packageInfo: gh<_i655.PackageInfo>(),
      ),
    );
    gh.factory<_i499.AbstractAgreementUseCase>(
      () => _i205.AgreementUseCase(
        agreementRepository: gh<_i951.AbstractAgreementRepository>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
        deviceInfo: gh<_i833.DeviceInfoPlugin>(),
        packageInfo: gh<_i655.PackageInfo>(),
        logger: gh<_i207.Talker>(),
        userInfoUseCase: gh<_i115.AbstractUserInfoUseCase>(),
        deviceInfoProvider: gh<_i915.AbstractDeviceInfoProvider>(),
        preferences: gh<_i927.Preferences>(),
      ),
    );
    gh.factory<_i667.AndroidUpdaterUseCase>(
      () => _i667.AndroidUpdaterUseCase(gh<_i361.Dio>(), gh<_i207.Talker>()),
    );
    gh.factory<_i501.WindowsUpdaterUseCase>(
      () => _i501.WindowsUpdaterUseCase(gh<_i361.Dio>(), gh<_i207.Talker>()),
    );
    gh.lazySingleton<_i739.AbstractDesktopUpdaterUseCase>(
      () => updaterModule.updaterUseCase(
        gh<_i13.DesktopUpdaterUseCase>(),
        gh<_i667.AndroidUpdaterUseCase>(),
        gh<_i501.WindowsUpdaterUseCase>(),
      ),
    );
    gh.factory<_i668.AbstractAppVersionUseCase>(
      () => _i831.AppVersionUseCase(
        httpClient: gh<_i361.Dio>(),
        packageInfo: gh<_i655.PackageInfo>(),
        logger: gh<_i207.Talker>(),
        deviceInfoProvider: gh<_i915.AbstractDeviceInfoProvider>(),
        authUserUseCase: gh<_i622.AbstractAuthUserUseCase>(),
      ),
    );
    gh.lazySingleton<_i264.AbstractGeonodeSdkManager>(
      () => _i264.GeonodeSdkManager(
        gh<_i655.PackageInfo>(),
        gh<_i207.Talker>(),
        gh<_i927.Preferences>(),
        gh<_i622.AbstractAuthUserUseCase>(),
      ),
    );
    gh.factory<_i154.AbstractRegionService>(
      () => _i463.RegionService(
        logger: gh<_i207.Talker>(),
        remoteDataSource: gh<_i819.AbstractRegionRemoteDataSource>(),
      ),
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
        analyticsManager: gh<_i228.AbstractAnalyticsManager>(),
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

class _$PlatformReviewRequesterModule
    extends _i721.PlatformReviewRequesterModule {}

class _$SingboxModule extends _i721.SingboxModule {}

class _$DioModule extends _i721.DioModule {}

class _$UpdaterModule extends _i721.UpdaterModule {}
