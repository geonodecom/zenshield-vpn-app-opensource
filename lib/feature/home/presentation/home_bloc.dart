import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:zenshield/core/event_bus_events/on_current_server_updated.dart';
import 'package:zenshield/core/event_bus_events/on_timer_tick.dart';
import 'package:zenshield/core/event_bus_events/vpn_state_changed.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/feature/home/presentation/home_side_effect.dart';
// ignore: implementation_imports
import 'package:zenshield/feature/home/presentation/state/home_state.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'home_event.dart';

class HomeBloc extends SideEffectBloc<HomeEvent, HomeState, HomeSideEffect> {
  HomeBloc({
    required AbstractVpnManager vpnManager,
    required EventBus eventBus,
    required Talker logger,
    required AbstractServersRepository serverRepository,
  }) : _vpnManager = vpnManager,
       _eventBus = eventBus,
       _logger = logger,
       _serverRepository = serverRepository,
       super(HomeState.initial()) {
    on<InitialEvent>(_onInitial);
    on<ServersTappedEvent>(_onServersTapped);
    on<SettingsTappedEvent>(_onSettingsTapped);
    on<AboutTappedEvent>(_onAboutTapped);
    on<UpdateVpnStateEvent>(_onVpnStateChanged);
    on<UpdateTimer>(_onUpdateTimer);

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
  final Talker _logger;
  final AbstractServersRepository _serverRepository;

  // Subscriptions
  StreamSubscription<OnTimerTick>? _timerSubscription;
  StreamSubscription<VpnStateChanged>? _connectionStatusSubscription;

  @override
  Future<void> close() async {
    _timerSubscription?.cancel();
    _timerSubscription = null;

    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;

    return super.close();
  }

  Future<void> _onInitial(InitialEvent event, Emitter<HomeState> emit) async {
    final selectedConfiguration = await _serverRepository.prepare();

    _eventBus.fire(OnCurrentServerUpdated(server: selectedConfiguration));

    switch (event.connectionStatus) {
      case Connected():
        await _vpnManager.resumeTimer(isPaid: true);
      case Disconnected():
        emit(state.copyWith(timerValue: '00:00:00'));
      default:
        break;
    }
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
        break;
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
}
