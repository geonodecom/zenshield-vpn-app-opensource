import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/event_bus_events/auto_select_requested.dart';
import 'package:zenshield/core/event_bus_events/on_current_server_updated.dart';
import 'package:zenshield/core/event_bus_events/on_servers_updated.dart';
import 'package:zenshield/core/event_bus_events/vpn_state_changed.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';

import 'package:zenshield/feature/servers/data/model/pinged_vpn_configuration/pinged_vpn_configuration.dart';
import 'package:zenshield/feature/servers/presentation/servers_side_effect.dart';
import 'package:zenshield/feature/servers/presentation/state/servers_state.dart';
import 'package:zenshield/core/utils/mixins.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'servers_event.dart';

class ServersBloc
    extends SideEffectBloc<ServersEvent, ServersState, ServersSideEffect>
    with AnalyticsEventSender {
  ServersBloc({
    required this.connectionStatus,
    required AbstractServersRepository serversRepository,
    required EventBus eventBus,
    required Talker logger,
    required AbstractAnalyticsManager analyticsManager,
    required Preferences preferences,
  })  : _serversRepository = serversRepository,
        _eventBus = eventBus,
        _logger = logger,
        _analyticsManager = analyticsManager,
        _preferences = preferences,
        super(const ServersState.initial()) {
    on<InitialEvent>(_onInitial);
    on<SearchTextChangedEvent>(_onSearchTextChanged);
    on<ServerSelectedEvent>(_onServerSelected);
    on<AutoSelectRequestedEvent>(_onAutoSelectRequested);

    _serverSubscription = _eventBus.on<OnServersUpdated>().listen((event) {
      add(const InitialEvent());
    });

    _connectionStatusSubscription =
        _eventBus.on<VpnStateChanged>().listen((event) {
      connectionStatus = event.connectionStatus;
    });

    add(const InitialEvent());
  }

  // Dependencies
  final AbstractServersRepository _serversRepository;
  final EventBus _eventBus;
  final Talker _logger;
  final AbstractAnalyticsManager _analyticsManager;
  final Preferences _preferences;

  // Subscriptions
  StreamSubscription<OnServersUpdated>? _serverSubscription;
  StreamSubscription<VpnStateChanged>? _connectionStatusSubscription;

  // Properties
  ConnectionStatus connectionStatus;

  @override
  Future<void> close() async {
    await _serverSubscription?.cancel();
    _serverSubscription = null;
    await _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;
    return super.close();
  }

  @override
  AbstractAnalyticsManager get analyticsManager => _analyticsManager;

  Future<void> _onInitial(
    InitialEvent event,
    Emitter<ServersState> emit,
  ) async {
    emit(const ServersState.initial().copyWith(isLoading: true));

    try {
      final servers = await _serversRepository.getServers(force: false);
      final initialServers = servers.map((server) {
        return PingedVpnConfiguration(
          configuration: server,
          ping: null,
        );
      }).toList();

      final isDisconnected = connectionStatus == const Disconnected();
      final pinned = await _preferences.serverSelectionPinned;

      emit(
        ServersState.loaded(
          servers: initialServers,
          filteredServers: initialServers,
          isLoading: isDisconnected,
          isSearchActive: false,
          searchQuery: '',
          pinned: pinned,
        ),
      );
    } on Exception catch (e, st) {
      addError(e, st);
    }
  }

  Future<void> _onServerSelected(
    ServerSelectedEvent event,
    Emitter<ServersState> emit,
  ) async {
    try {
      _logger.info('Server selected: ${event.server.ip}');
      final isSameServer = event.currentServerId != null &&
          event.server.ip == event.currentServerId;

      if (isSameServer) {
        produceSideEffect(NavigateToHome());
        return;
      }

      sendAnalyticsEvent(
        AnalyticsEventNames.server_selected,
        {'server_region': event.server.region.countryCode},
      );
      _eventBus.fire(OnCurrentServerUpdated(server: event.server, manual: true));
      produceSideEffect(NavigateToHome());
    } catch (e, st) {
      addError(e, st);
    }
  }

  /// Unpins the server selection so the tunnel is free to route through the
  /// best server in any country again, instead of being confined to whatever
  /// country the user last manually picked (which may be the dead one).
  Future<void> _onAutoSelectRequested(
    AutoSelectRequestedEvent event,
    Emitter<ServersState> emit,
  ) async {
    try {
      _logger.info('Auto select requested — unpinning server selection');
      await _preferences.setServerSelectionPinned(false);
      sendAnalyticsEvent(AnalyticsEventNames.server_selected, {
        'server_region': 'auto',
      });
      // Lets AppBloc react (force a reconnect if currently connected, show a
      // confirmation toast) — this bloc only owns the picker list, not the
      // tunnel or the home screen.
      _eventBus.fire(const AutoSelectRequested());
      await _onInitial(const InitialEvent(), emit);
      produceSideEffect(NavigateToHome());
    } catch (e, st) {
      addError(e, st);
    }
  }

  void _onSearchTextChanged(
    SearchTextChangedEvent event,
    Emitter<ServersState> emit,
  ) {
    final query = event.searchText.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          filteredServers: state.servers,
          isSearchActive: false,
          searchQuery: '',
        ),
      );
      return;
    }

    final filteredServers = state.servers.where((server) {
      final searchCriterion = switch (server.configuration) {
        final SystemVpnConfiguration config => config.city,
        final UserVpnConfiguration config => config.title,
      };
      return searchCriterion.toLowerCase().contains(query);
    }).toList();

    emit(
      state.copyWith(
        filteredServers: filteredServers,
        isSearchActive: true,
        searchQuery: query,
      ),
    );
  }
}
