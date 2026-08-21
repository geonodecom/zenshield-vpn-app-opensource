import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenshield/config/constants/secure_storage_keys.dart';
import 'package:zenshield/core/services/platform_settings_service.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/launch/domain/repositories/launch_on_startup_manager.dart';
import 'package:zenshield/feature/user_info/domain/useCase/user_info_use_case.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/feature/settings/presentation/setting_side_effect.dart';
import 'package:zenshield/feature/settings/presentation/state/settings_state.dart';
import 'package:zenshield/core/utils/mixins.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'settings_event.dart';

class SettingsBloc
    extends SideEffectBloc<SettingsEvent, SettingsState, SettingsSideEffect>
    with LaunchUrl<SettingsEvent, SettingsState, SettingsSideEffect> {
  SettingsBloc({
    required FlutterSecureStorage secureStorage,
    required Talker logger,
    required AbstractLaunchOnStartupManager launchOnStartupManager,
    required AbstractUserInfoUseCase userInfoUseCase,
    required AbstractVpnManager vpnManager,
    required AbstractAuthUserUseCase authUseCase,
    required AbstractPlatformSettingsService platformSettingsService,
  }) : _secureStorage = secureStorage,
       _logger = logger,
       _launchOnStartupManager = launchOnStartupManager,
       _userInfoUseCase = userInfoUseCase,
       _vpnManager = vpnManager,
       _authUseCase = authUseCase,
       _platformSettingsService = platformSettingsService,
       super(SettingsState.initial()) {
    on<InitialLoadEvent>(_onInitialLoad);
    on<ProtocolTappedEvent>(_onProtocolTapped);
    on<LogOutTappedEvent>(_onLogOutTapped);
    on<TelegramTappedEvent>(_onTelegramTapped);
    on<XTappedEvent>(_onXTapped);
    on<NavigateToHomeEvent>(_onNavigateToHome);
    on<LaunchOnStartupChangedEvent>(_onLaunchOnStartupChanged);
    on<RequestIgnoreBatteryOptimizationEvent>(_onRequestIgnoreBatteryOptimization);
    on<BatteryOptimizationStatusChangedEvent>(_onBatteryOptimizationStatusChanged);
    on<OpenBatteryOptimizationSettingsEvent>(_onOpenBatteryOptimizationSettings);
    on<RefreshBatteryOptimizationStatusEvent>(_onRefreshBatteryOptimizationStatus);
    add(const InitialLoadEvent());
  }

  // Dependencies
  final FlutterSecureStorage _secureStorage;
  final Talker _logger;
  final AbstractLaunchOnStartupManager _launchOnStartupManager;
  final AbstractUserInfoUseCase _userInfoUseCase;
  final AbstractVpnManager _vpnManager;
  final AbstractAuthUserUseCase _authUseCase;
  final AbstractPlatformSettingsService _platformSettingsService;

  Future<void> _onInitialLoad(
    InitialLoadEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final id = await _secureStorage.read(key: SecureStorageKeys.userId) ?? '';

    bool launchOnStartup = false;
    bool launchOnStartupFailed = false;
    try {
      launchOnStartup = await _launchOnStartupManager.isEnabled();
    } catch (e) {
      _logger.error('Failed to load launch on startup status', e);
      launchOnStartupFailed = true;
    }

    bool isIgnoringBatteryOptimization = true;
    try {
      isIgnoringBatteryOptimization = await _platformSettingsService.isIgnoringBatteryOptimizations();
    } catch (e) {
      _logger.error('Failed to load battery optimizations status', e);
    }

    DateTime? securedSince;
    try {
      final userInfo = await _userInfoUseCase.getUserInfo();
      securedSince = userInfo.securedSince;
      _logger.info('Loaded user info, securedSince: $securedSince');
    } catch (e, st) {
      _logger.error('Failed to load user info', e, st);
    }

    emit(
      state.copyWith(
        userId: id,
        launchOnStartup: launchOnStartup,
        launchOnStartupFailed: launchOnStartupFailed,
        isIgnoringBatteryOptimizations: isIgnoringBatteryOptimization,
        securedSince: securedSince,
      ),
    );
  }

  void _onProtocolTapped(
    ProtocolTappedEvent event,
    Emitter<SettingsState> emit,
  ) {
    _logger.info('Protocol tapped');
    produceSideEffect(NavigateToProtocols());
  }

  Future<void> _onLogOutTapped(
    LogOutTappedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info('Log out tapped');

    try {
      if (_vpnManager.status == ConnectionStatus.connected()) {
        await _vpnManager.disableVpn();
      }
      await _authUseCase.resetAuthorization();

      _logger.info('User logged out successfully');
      produceSideEffect(NavigateToAuth());
    } catch (e, stackTrace) {
      _logger.error('Failed to log out', e, stackTrace);
      produceSideEffect(NavigateToAuth());
    }
  }

  Future<void> _onTelegramTapped(
    TelegramTappedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info('Telegram tapped');
    await launchExternalUrl(Uri.parse(Urls.telegramUrl));
  }

  Future<void> _onXTapped(
    XTappedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info('X tapped');
    await launchExternalUrl(Uri.parse(Urls.xUrl));
  }

  FutureOr<void> _onNavigateToHome(
    NavigateToHomeEvent event,
    Emitter<SettingsState> emit,
  ) {
    produceSideEffect(NavigateToHome());
  }

  Future<void> _onLaunchOnStartupChanged(
    LaunchOnStartupChangedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info('Launch on startup changed to ${event.value}');

    try {
      if (event.value) {
        await _launchOnStartupManager.enable();
      } else {
        await _launchOnStartupManager.disable();
      }

      emit(
        state.copyWith(
          launchOnStartup: event.value,
          launchOnStartupFailed: false,
        ),
      );
    } catch (e, st) {
      _logger.error('Failed to change launch on startup', e, st);
      emit(state.copyWith(launchOnStartupFailed: true));
    }
  }

  Future<void> _onRequestIgnoreBatteryOptimization(
    RequestIgnoreBatteryOptimizationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info('Requesting ignore battery optimization');
    try {
      final success = await _platformSettingsService.requestIgnoreBatteryOptimizations();
      if (success) {
        emit(state.copyWith(isIgnoringBatteryOptimizations: true));
      } else {
        final isIgnoring = await _platformSettingsService.isIgnoringBatteryOptimizations();
        emit(state.copyWith(isIgnoringBatteryOptimizations: isIgnoring));
      }
    } catch (e, st) {
      _logger.error('Failed to request ignore battery optimization', e, st);
    }
  }

  void _onBatteryOptimizationStatusChanged(
    BatteryOptimizationStatusChangedEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isIgnoringBatteryOptimizations: event.value));
  }

  Future<void> _onOpenBatteryOptimizationSettings(
    OpenBatteryOptimizationSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Android provides no API for an app to revoke its own battery
    // optimization exemption — only the system settings screen can do
    // that, so send the user there instead of silently doing nothing.
    _logger.info('Opening battery optimization settings');
    try {
      await _platformSettingsService.openBatteryOptimizationSettings();
    } catch (e, st) {
      _logger.error('Failed to open battery optimization settings', e, st);
    }
  }

  Future<void> _onRefreshBatteryOptimizationStatus(
    RefreshBatteryOptimizationStatusEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final isIgnoring = await _platformSettingsService
          .isIgnoringBatteryOptimizations();
      emit(state.copyWith(isIgnoringBatteryOptimizations: isIgnoring));
    } catch (e, st) {
      _logger.error('Failed to refresh battery optimization status', e, st);
    }
  }
}
