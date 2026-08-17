import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'dart:io';

import 'package:zenshield/core/event_bus_events/on_current_server_updated.dart';
import 'package:zenshield/core/event_bus_events/on_timer_tick.dart';
import 'package:zenshield/core/event_bus_events/vpn_state_changed.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/config/constants/feature_flags.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/desktop_updater/domain/useCase/desktop_updater_use_case.dart';
import 'package:zenshield/feature/rating/domain/useCase/rating_use_case.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';
import 'package:zenshield/core/managers/geonode_sdk_manager.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/feature/home/presentation/home_side_effect.dart';
// ignore: implementation_imports
import 'package:zenshield/feature/home/presentation/state/home_state.dart';
import 'package:zenshield/core/utils/mixins.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'home_event.dart';

class HomeBloc extends SideEffectBloc<HomeEvent, HomeState, HomeSideEffect>
    with AnalyticsEventSender {
  HomeBloc({
    required AbstractVpnManager vpnManager,
    required EventBus eventBus,
    required AbstractAnalyticsManager analyticsManager,
    required Talker logger,
    required AbstractServersRepository serverRepository,
    required AbstractDesktopUpdaterUseCase desktopUpdaterUseCase,
    required Preferences preferences,
    required AbstractRatingUseCase ratingUseCase,
    required AbstractGeonodeSdkManager geonodeSdkManager,
    required AbstractAuthUserUseCase authUserUseCase,
  }) : _vpnManager = vpnManager,
       _eventBus = eventBus,
       _analyticsManager = analyticsManager,
       _logger = logger,
       _serverRepository = serverRepository,
       _desktopUpdaterUseCase = desktopUpdaterUseCase,
       _preferences = preferences,
       _ratingUseCase = ratingUseCase,
       _geonodeSdkManager = geonodeSdkManager,
       _authUserUseCase = authUserUseCase,
       super(HomeState.initial()) {
    on<InitialEvent>(_onInitial);
    on<ServersTappedEvent>(_onServersTapped);
    on<SettingsTappedEvent>(_onSettingsTapped);
    on<AboutTappedEvent>(_onAboutTapped);
    on<UpdateVpnStateEvent>(_onVpnStateChanged);
    on<UpdateTimer>(_onUpdateTimer);
    on<CloseUpdateBannerEvent>(_onCloseUpdateBanner);
    on<ShowUpdatedBannerEvent>(_onShowUpdateBanner);
    on<StartUpdateEvent>(_onStartUpdate);
    on<CloseUpdatePopupEvent>(_onCloseUpdatePopup);
    on<SetUpdatePopupShowingEvent>(_onSetUpdatePopupShowing);

    _timerSubscription = _eventBus.on<OnTimerTick>().listen((event) {
      add(UpdateTimer(time: event.time));
    });

    _connectionStatusSubscription = _eventBus.on<VpnStateChanged>().listen((
      event,
    ) {
      add(UpdateVpnStateEvent(connectionStatus: event.connectionStatus, isServerSwitch: event.isServerSwitch));
    });
  }

  // Dependencies
  final AbstractVpnManager _vpnManager;
  final EventBus _eventBus;
  final AbstractAnalyticsManager _analyticsManager;
  final Talker _logger;
  final AbstractServersRepository _serverRepository;
  final AbstractDesktopUpdaterUseCase _desktopUpdaterUseCase;
  final Preferences _preferences;
  final AbstractRatingUseCase _ratingUseCase;
  final AbstractGeonodeSdkManager _geonodeSdkManager;
  final AbstractAuthUserUseCase _authUserUseCase;

  // Subscriptions
  StreamSubscription<OnTimerTick>? _timerSubscription;
  StreamSubscription<VpnStateChanged>? _connectionStatusSubscription;
  Timer? _versionCheckTimer;

  final Duration _durationCheckForUpdate = const Duration(minutes: 30);

  @override
  Future<void> close() async {
    _timerSubscription?.cancel();
    _timerSubscription = null;

    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;

    _versionCheckTimer?.cancel();
    _versionCheckTimer = null;

    _desktopUpdaterUseCase.removeListener(_onDesktopUpdaterChanged);
    _desktopUpdaterUseCase.disposeUpdater();

    return super.close();
  }

  @override
  AbstractAnalyticsManager get analyticsManager => _analyticsManager;

  Future<void> _onInitial(InitialEvent event, Emitter<HomeState> emit) async {
    if (!FeatureFlags.disableInAppUpdates && PlatformUtils.isDesktop) {
      await _desktopUpdaterUseCase.initializeUpdater();
      _desktopUpdaterUseCase.addListener(_onDesktopUpdaterChanged);
      _startVersionCheckTimer();
    }

    final selectedConfiguration = await _serverRepository.prepare();

    _eventBus.fire(OnCurrentServerUpdated(server: selectedConfiguration));

    final zenSdkEnabled = await _preferences.zenSdkEnabled;
    if (zenSdkEnabled) {
      try {
        final userId = await _authUserUseCase.getUserId();
        if (userId != null && userId.isNotEmpty) {
          await _geonodeSdkManager.connectForUser(userId);
          _logger.info(
            '[GeonodeSdk] Connected on home screen init | isRunning=${_geonodeSdkManager.isSdkRunning}',
          );
        }
      } catch (e) {
        _logger.error(
          '[GeonodeSdk] Failed to connect on home screen init',
          e,
        );
      }
    }

    await _tryShowUpdatedAppBanner();

    switch (event.connectionStatus) {
      case Connected():
        await _vpnManager.resumeTimer(isPaid: true);
      case Disconnected():
        emit(state.copyWith(timerValue: '00:00:00'));
      default:
        break;
    }
  }

  Future<void> _tryShowUpdatedAppBanner() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final previousVersion = await _preferences.previousAppVersion;

      if (previousVersion != null && previousVersion != currentVersion) {
        _logger.info(
          'App was updated from $previousVersion to $currentVersion',
        );
        add(ShowUpdatedBannerEvent(version: currentVersion));
      }

      await _preferences.setPreviousAppVersion(currentVersion);
    } catch (e) {
      _logger.error('Failed to check app version', e);
    }
  }

  void _startVersionCheckTimer() {
    _versionCheckTimer?.cancel();
    _versionCheckTimer = Timer.periodic(
      _durationCheckForUpdate,
      (_) => _checkForUpdate(),
    );
  }

  Future<void> _checkForUpdate() async {
    if (isClosed) return;

    try {
      await _desktopUpdaterUseCase.checkVersion();
      _logger.info('Version check completed');
    } catch (e) {
      _logger.error('Failed to check for update', e);
    }
  }

  void _onDesktopUpdaterChanged() async {
    if (isClosed) return;

    try {
      if (_desktopUpdaterUseCase.needUpdate &&
          !_desktopUpdaterUseCase.isDownloading &&
          !_desktopUpdaterUseCase.isDownloaded &&
          !state.isUpdatePopupShowing) {
        add(const SetUpdatePopupShowingEvent(isShowing: true));
        produceSideEffect(
          ShowUpdatePopup(
            isDismissible: !_desktopUpdaterUseCase.isMandatory,
            version: _desktopUpdaterUseCase.appVersion,
          ),
        );
      }
    // ignore: empty_catches
    } catch (e) {}
  }

  void _onCloseUpdateBanner(
    CloseUpdateBannerEvent event,
    Emitter<HomeState> emit,
  ) {
    _logger.info('Close update banner');
    emit(state.copyWith(showUpdateBanner: false, updateVersion: null));
  }

  void _onShowUpdateBanner(
    ShowUpdatedBannerEvent event,
    Emitter<HomeState> emit,
  ) {
    _logger.info('Show update banner');
    emit(state.copyWith(showUpdateBanner: true, updateVersion: event.version));
  }

  Future<void> _onVpnStateChanged(
    UpdateVpnStateEvent event,
    Emitter<HomeState> emit,
  ) async {
    switch (event.connectionStatus) {
      case Connecting():
      case Disconnecting():
      case Disconnected():
        if (!event.isServerSwitch) {
          emit(state.copyWith(timerValue: '00:00:00'));
        }
      case Connected():
        if (Platform.isIOS && !event.isServerSwitch) {
          await _tryShowRatingPopup();
        }
    }
  }

  Future<void> _tryShowRatingPopup() async {
    try {
      final count = await _preferences.vpnConnectCount;
      final newCount = count + 1;
      await _preferences.setVpnConnectCount(newCount);

      const milestones = {3, 6, 10};
      if (!milestones.contains(newCount)) return;

      final shouldShow = await _ratingUseCase.checkShowRatePopUpIfNeeded();
      if (!shouldShow || isClosed) return;

      produceSideEffect(
        RequestLocalReview(
          onSuccess: () async {
            await _ratingUseCase.showReview();
          },
        ),
      );
    } catch (e) {
      _logger.error('Failed to check rating popup', e);
    }
  }

  void _onServersTapped(ServersTappedEvent event, Emitter<HomeState> emit) {
    _logger.info('Servers tapped');
    produceSideEffect(NavigateToServers());
  }

  void _onSettingsTapped(SettingsTappedEvent event, Emitter<HomeState> emit) {
    _logger.info('Settings tapped');
    produceSideEffect(NavigateToSettings());
  }

  void _onAboutTapped(AboutTappedEvent event, Emitter<HomeState> emit) {
    _logger.info('About tapped');
    produceSideEffect(NavigateToAbout());
  }

  void _onUpdateTimer(UpdateTimer event, Emitter<HomeState> emit) {
    emit(state.copyWith(timerValue: event.time));
  }

  void _onStartUpdate(StartUpdateEvent event, Emitter<HomeState> emit) {
    _logger.info('Start update from banner');
    final params = state.updateVersion != null
        ? <String, String>{'target_version': state.updateVersion!}
        : null;
    sendAnalyticsEvent(
      AnalyticsEventNames.app_update_started,
      params,
    );
    produceSideEffect(NavigateToAppUpdate());
  }

  void _onCloseUpdatePopup(
    CloseUpdatePopupEvent event,
    Emitter<HomeState> emit,
  ) {
    _logger.info('Close update popup');
    emit(state.copyWith(isUpdatePopupShowing: false));
  }

  void _onSetUpdatePopupShowing(
    SetUpdatePopupShowingEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(isUpdatePopupShowing: event.isShowing));
  }
}
