import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/event_bus_events/auto_select_requested.dart';
import 'package:zenshield/core/event_bus_events/on_current_server_updated.dart';
import 'package:zenshield/core/event_bus_events/on_servers_updated.dart';
import 'package:zenshield/core/event_bus_events/vpn_state_changed.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';

import 'package:zenshield/feature/servers/data/model/pinged_vpn_configuration/pinged_vpn_configuration.dart';
import 'package:zenshield/feature/servers/presentation/servers_side_effect.dart';
import 'package:zenshield/feature/servers/presentation/state/servers_state.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'servers_event.dart';

class ServersBloc
    extends SideEffectBloc<ServersEvent, ServersState, ServersSideEffect> {
  ServersBloc({
    required this.connectionStatus,
    required AbstractServersRepository serversRepository,
    required EventBus eventBus,
    required Talker logger,
    required Preferences preferences,
  })  : _serversRepository = serversRepository,
        _eventBus = eventBus,
        _logger = logger,
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
  final Preferences _preferences;
  final CountryService _countryService = CountryService();

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

      // Only a no-op when the user was already pinned to this exact server —
      // if they're currently on auto (unpinned), tapping a country must still
      // pin the selection even when auto happened to land on the same node,
      // otherwise the tap silently does nothing.
      final isPinned = state.mapOrNull(loaded: (s) => s.pinned) ?? false;
      if (isSameServer && isPinned) {
        produceSideEffect(NavigateToHome());
        return;
      }

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
      final config = server.configuration;
      final locationName = switch (config) {
        final SystemVpnConfiguration c => c.city,
        final UserVpnConfiguration c => c.title,
      };
      final countryCode = config.region.countryCode;
      final countryName = _countryService.findByCode(countryCode)?.name ?? '';
      return locationName.toLowerCase().contains(query) ||
          countryName.toLowerCase().contains(query) ||
          countryCode.toLowerCase().contains(query);
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
