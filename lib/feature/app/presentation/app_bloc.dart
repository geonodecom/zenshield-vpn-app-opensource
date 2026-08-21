import 'dart:async';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:zenshield/core/event_bus_events/active_server_resolved.dart';
import 'package:zenshield/core/event_bus_events/auto_select_requested.dart';
import 'package:zenshield/core/event_bus_events/on_current_server_updated.dart';
import 'package:zenshield/core/event_bus_events/tunnel_health_changed.dart';
import 'package:zenshield/core/event_bus_events/vpn_state_changed.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/services/platform_settings_service.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/core/models/protocols.dart';
import 'package:zenshield/core/utils/singbox_monitor.dart';
import 'package:zenshield/feature/app/presentation/app_side_effect.dart';
import 'package:zenshield/feature/app/presentation/state/app_state.dart';
import 'package:zenshield/core/utils/aggressive_oem_detector.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'app_event.dart';

class AppBloc extends SideEffectBloc<AppEvent, AppState, AppSideEffect> {
  AppBloc({
    required AbstractVpnManager vpnManager,
    required EventBus eventBus,
    required Preferences preferences,
    required Talker logger,
    required AbstractPlatformSettingsService platformSettingsService,
  })  : _vpnManager = vpnManager,
        _eventBus = eventBus,
        _preferences = preferences,
        _logger = logger,
        _platformSettingsService = platformSettingsService,
        super(AppState.initial()) {
    on<InitialEvent>(_onInitialEvent);
    on<SelectProtocolEvent>(_onSelectProtocol);
    on<CurrentServerUpdatedEvent>(_onCurrentServerUpdated);
    on<UpdateVpnStateEvent>(_onVpnStateChanged);
    on<TurnOnVpnTappedEvent>(_onTurnOnVpn);
    on<TurnOffVpnTappedEvent>(_onTurnOffVpn);
    on<ActiveServerResolvedEvent>(_onActiveServerResolved);
    on<TunnelHealthChangedEvent>(_onTunnelHealthChanged);
    on<AutoSelectRequestedAppEvent>(_onAutoSelectRequested);

    _autoSelectRequestedSubscription =
        _eventBus.on<AutoSelectRequested>().listen((event) {
      add(const AutoSelectRequestedAppEvent());
    });

    _onCurrentServerUpdatedSubscription =
        _eventBus.on<OnCurrentServerUpdated>().listen((event) {
      add(CurrentServerUpdatedEvent(event.server, manual: event.manual));
    });

    _activeServerResolvedSubscription =
        _eventBus.on<ActiveServerResolved>().listen((event) {
      add(ActiveServerResolvedEvent(event.serverIp));
    });

    _tunnelHealthSubscription =
        _eventBus.on<TunnelHealthChanged>().listen((event) {
      add(TunnelHealthChangedEvent(event.healthy));
    });

    _connectionStatusSubscription =
        _eventBus.on<VpnStateChanged>().listen((event) {
      add(UpdateVpnStateEvent(connectionStatus: event.connectionStatus));
    });

    add(InitialEvent());
  }

  // Dependencies
  final AbstractVpnManager _vpnManager;
  final EventBus _eventBus;
  final Preferences _preferences;
  final Talker _logger;
  final AbstractPlatformSettingsService _platformSettingsService;

  // Subscriptions
  StreamSubscription<OnCurrentServerUpdated>?
      _onCurrentServerUpdatedSubscription;
  StreamSubscription<VpnStateChanged>? _connectionStatusSubscription;
  StreamSubscription<ActiveServerResolved>? _activeServerResolvedSubscription;
  StreamSubscription<TunnelHealthChanged>? _tunnelHealthSubscription;
  StreamSubscription<AutoSelectRequested>? _autoSelectRequestedSubscription;

  bool _pendingServerChange = false;
  bool _isServerSwitching = false;
  int _switchGeneration = 0;

  /// Newest server picked while a disconnect→reconnect cycle was already in
  /// flight. Starting a second stop/start on top of a running one races the
  /// native Go engine (SIGABRT), so rapid selections are serialized: only the
  /// last one is applied, once the in-flight cycle reaches Connected.
  VpnConfiguration? _queuedServerSwitch;

  /// The server id preferences held when the current connect began — used to
  /// tell whether a queued switch was already covered by that connect.
  String? _connectServerIp;

  /// When the user tapped Connect for the currently in-flight attempt — used
  /// to log total tap-to-Connected / tap-to-failed latency, so a stuck
  /// connect can be told apart from a fast one purely from the logs.
  DateTime? _connectTapAt;

  bool get _useDisconnectReconnectForServerSwitch => Platform.isAndroid;

  @override
  Future<void> close() async {
    _onCurrentServerUpdatedSubscription?.cancel();
    _connectionStatusSubscription?.cancel();
    _activeServerResolvedSubscription?.cancel();
    _tunnelHealthSubscription?.cancel();
    _autoSelectRequestedSubscription?.cancel();

    _onCurrentServerUpdatedSubscription = null;
    _connectionStatusSubscription = null;
    _activeServerResolvedSubscription = null;
    _tunnelHealthSubscription = null;
    _autoSelectRequestedSubscription = null;

    return super.close();
  }

  Future<void> _onInitialEvent(
    InitialEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _vpnManager.init();
      await _vpnManager.subscribeToVpnState(isPaid: true);
    } catch (e, st) {
      _logger.error('[App] Failed to initialize VPN manager or subscribe to state changes', e, st);
    }

    // A fresh app open always starts in auto mode: pinning only lasts for
    // the session in which the user explicitly picked a server.
    await _preferences.setServerSelectionPinned(false);

    final savedProtocol = await _preferences.currentProtocol;

    final initialProtocol = savedProtocol ?? Protocols.auto;

    emit(
      state.copyWith(
        protocol: initialProtocol,
        serverSelectionPinned: false,
      ),
    );

    if ((Platform.isAndroid || Platform.isWindows) &&
        await _preferences.vpnRestoreOnBoot) {
      _logger.info('[App] Restoring VPN after device boot');
      if (Platform.isAndroid) {
        try {
          final hasPermission = await _platformSettingsService.checkVpnPermission();
          if (!hasPermission) {
            _logger.warning('[App] VPN permission not available during boot restore. Aborting boot restore.');
            await _preferences.setVpnRestoreOnBoot(false);
            return;
          }
        } catch (e, st) {
          _logger.error('[App] Failed to check VPN permission during boot restore', e, st);
          await _preferences.setVpnRestoreOnBoot(false);
          return;
        }
      }
      await Future<void>.delayed(const Duration(seconds: 2));
      if (_vpnManager.status is! Connected) {
        add(const TurnOnVpnTappedEvent());
      } else {
        _logger.info('[App] VPN already active after boot; skipping reconnect');
      }
    }
  }

  Future<void> _onVpnStateChanged(
    UpdateVpnStateEvent event,
    Emitter<AppState> emit,
  ) async {
    final previous = state.connectionStatus;
    final next = event.connectionStatus;

    switch (next) {
      case Connected():
        // Avoid duplicate / stale "connected" signals while already connected (e.g. after disconnect).
        if (previous is! Connected) {
          final tapAt = _connectTapAt;
          if (tapAt != null) {
            _logger.info(
              '[App] Connected — tap-to-connected latency: ${DateTime.now().difference(tapAt).inMilliseconds}ms',
            );
            _connectTapAt = null;
          }
        }
        _isServerSwitching = false;
        SingboxMonitor().disableForceCheckMode();
        emit(
          // tunnelHealthy resets to unknown on every fresh connection; the
          // post-connect health check will report the real value shortly.
          state.copyWith(connectionStatus: const Connected(), tunnelHealthy: null),
        );
        final queued = _queuedServerSwitch;
        _queuedServerSwitch = null;
        if (queued != null && queued.ip != _connectServerIp) {
          _logger.info(
            '[App] Applying queued server switch to ${queued.ip}',
          );
          await _switchServer(queued);
        }
      case Disconnected():
        SingboxMonitor().disableForceCheckMode();
        if (_useDisconnectReconnectForServerSwitch && _pendingServerChange) {
          _pendingServerChange = false;
          await Future.delayed(const Duration(seconds: 1));
          add(const TurnOnVpnTappedEvent());
          return;
        }
        _isServerSwitching = false;
        emit(
          state.copyWith(
            connectionStatus: const Disconnected(),
            tunnelHealthy: null,
          ),
        );
      case Connecting():
        if (_useDisconnectReconnectForServerSwitch && _isServerSwitching) return;
        emit(
          state.copyWith(
            connectionStatus: const Connecting(),
            tunnelHealthy: null,
          ),
        );
      case Disconnecting():
        if (_useDisconnectReconnectForServerSwitch && _isServerSwitching) return;
        emit(
          state.copyWith(connectionStatus: const Disconnecting()),
        );
    }
  }

  Future<void> _onTurnOnVpn(
    TurnOnVpnTappedEvent event,
    Emitter<AppState> emit,
  ) async {
    _logger.info(
      '[App] Connect button tapped (skipBatteryOptimizationCheck: ${event.skipBatteryOptimizationCheck}, server: ${state.selectedServer?.ip ?? "none"})',
    );
    if (!event.skipBatteryOptimizationCheck) {
      // Only the first tap of an attempt starts the clock — the battery-opt
      // re-fire (skipBatteryOptimizationCheck: true) is a continuation, not a
      // fresh user action.
      _connectTapAt = DateTime.now();
    }

    if (Platform.isAndroid && !event.skipBatteryOptimizationCheck) {
      try {
        // Only interrupt users on OEMs (Xiaomi, Oppo, Vivo, ...) whose
        // battery managers actually kill the VPN; stock Android keeps an
        // active VpnService alive without the exemption.
        final isAggressiveOem =
            await AggressiveOemDetector.isAggressiveBatteryOem();
        final isIgnoring = await _platformSettingsService.isIgnoringBatteryOptimizations();
        _logger.info(
          '[App] Battery optimization check: aggressiveOem=$isAggressiveOem ignoringOptimizations=$isIgnoring',
        );
        if (isAggressiveOem && !isIgnoring) {
          _logger.info('[App] Prompting user to disable battery optimization before connecting');
          produceSideEffect(PromptBatteryOptimizations(
            onAgreed: () async {
              await _platformSettingsService.requestIgnoreBatteryOptimizations();
              add(const TurnOnVpnTappedEvent(skipBatteryOptimizationCheck: true));
            },
            onSkipped: () {
              add(const TurnOnVpnTappedEvent(skipBatteryOptimizationCheck: true));
            },
          ));
          return;
        }
      } catch (e, st) {
        _logger.error('Failed to check battery optimization in _onTurnOnVpn', e, st);
      }
    }

    SingboxMonitor().enableForceCheckMode();
    final myGeneration = _switchGeneration;
    final connectStartedAt = DateTime.now();
    try {
      if (Platform.isAndroid) {
        final hasPermission = await _platformSettingsService.checkVpnPermission();
        _logger.info(
          '[App] VPN permission check: hasPermission=$hasPermission appLifecycle=${WidgetsBinding.instance.lifecycleState}',
        );
        if (!hasPermission &&
            WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
          // MainActivity must be in the foreground for VpnService.prepare() to
          // show the OS consent dialog. If we call enableVpn while backgrounded,
          // the native side silently drops the request and invokeMethod('start')
          // hangs forever with no error. Fail fast with a message instead.
          throw Exception(
            'Please open Zenshield VPN and try connecting again to grant VPN permission.',
          );
        }
      }

      _connectServerIp = await _preferences.currentServerId;
      await _vpnManager.enableVpn(isPaid: true);
      _logger.info(
        '[App] enableVpn call returned without error (${DateTime.now().difference(connectStartedAt).inMilliseconds}ms) '
        '— waiting for native Connected/Disconnected status',
      );
    } on PlatformException catch (e, st) {
      if (_useDisconnectReconnectForServerSwitch && _isServerSwitching && _switchGeneration == myGeneration) {
        _isServerSwitching = false;
        await _vpnManager.cancelServerSwitch();
      }
      emit(state.copyWith(connectionStatus: const Disconnected()));
      await _preferences.setVpnRestoreOnBoot(false); // Stop future auto-connect loops if it failed
      _logger.error(
        '[App] Connect FAILED (platform) — code=${e.code} message=${e.message} '
        'tap-to-failure: ${DateTime.now().difference(connectStartedAt).inMilliseconds}ms',
        e,
        st,
      );
      _connectTapAt = null;
      if (e.code == 'VPN_ERROR') {
        final details = e.details;
        final errorType = details != null && details['errorType'] is String
            ? details['errorType'] as String
            : null;
        produceSideEffect(ShowSystemExtensionErrorDialog(
          message: e.message ?? 'System extension could not be activated.',
          errorType: errorType,
        ));
      } else if (e.code == 'SETUP_CONNECTION') {
        produceSideEffect(ShowSystemExtensionErrorDialog(
          message: e.message ?? 'Connection could not be set up.',
          errorType: null,
        ));
      } else if (e.code == 'PERMISSION_DENIED') {
        produceSideEffect(const ShowVpnErrorDialog(
          title: 'Permission Denied',
          message: 'VPN permission was denied. Zenshield requires VPN permission to secure your connection.',
        ));
      } else {
        produceSideEffect(ShowVpnErrorDialog(
          title: 'Connection Error',
          message: e.message ?? 'An error occurred while securing the connection.',
        ));
      }
    } on Exception catch (e, st) {
      if (_useDisconnectReconnectForServerSwitch && _isServerSwitching && _switchGeneration == myGeneration) {
        _isServerSwitching = false;
        await _vpnManager.cancelServerSwitch();
      }
      emit(state.copyWith(connectionStatus: const Disconnected()));
      await _preferences.setVpnRestoreOnBoot(false); // Stop future auto-connect loops if it failed
      _logger.error(
        '[App] Connect FAILED (exception) — $e '
        'tap-to-failure: ${DateTime.now().difference(connectStartedAt).inMilliseconds}ms',
        e,
        st,
      );
      _connectTapAt = null;
      produceSideEffect(ShowVpnErrorDialog(
        title: 'Connection Error',
        message: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onTurnOffVpn(
    TurnOffVpnTappedEvent event,
    Emitter<AppState> emit,
  ) async {
    _logger.info(
      '[App] Disconnect button tapped (current status: ${state.connectionStatus})',
    );
    _connectTapAt = null;
    _pendingServerChange = false;
    _isServerSwitching = false;
    _queuedServerSwitch = null;
    SingboxMonitor().enableForceCheckMode();
    await _vpnManager.disableVpn();
  }

  Future<void> _onSelectProtocol(
    SelectProtocolEvent event,
    Emitter<AppState> emit,
  ) async {
    await _preferences.setCurrentProtocol(event.protocol);

    _logger.info('Protocol changed to ${event.protocol}');
    emit(state.copyWith(protocol: event.protocol));
  }

  Future<void> _switchServer(VpnConfiguration server) async {
    if (_useDisconnectReconnectForServerSwitch && _isServerSwitching) {
      _queuedServerSwitch = server;
      _logger.info(
        '[App] Server switch already in flight — queued switch to ${server.ip}',
      );
      return;
    }
    if (_useDisconnectReconnectForServerSwitch) {
      _switchGeneration++;
      _pendingServerChange = true;
      _isServerSwitching = true;
      SingboxMonitor().enableForceCheckMode();
      try {
        await _vpnManager.disableVpn(preserveTimer: true);
      } catch (e, st) {
        _pendingServerChange = false;
        _isServerSwitching = false;
        _logger.error('Failed to disconnect for server switch', e, st);
      }
    } else {
      await _vpnManager.changeServer(server);
    }
  }

  Future<void> _onCurrentServerUpdated(
    CurrentServerUpdatedEvent event,
    Emitter<AppState> emit,
  ) async {
    _logger.info('Server changed to ${event.server}');

    await _preferences.setCurrentServerId(event.server?.ip ?? '');
    if (event.manual) {
      await _preferences.setServerSelectionPinned(true);
    }

    // event.manual distinguishes an actual user server pick from the
    // automatic restore-selected-server-on-init sync (HomeBloc fires the
    // latter with manual: false on every cold start just to populate the UI).
    // Without this gate, restoring the UI while an already-connected tunnel
    // was just resumed (e.g. reopening the app after it was force-closed)
    // looks identical to "user switched server while connected" and tears
    // down the still-healthy tunnel for no reason.
    if (event.manual &&
        state.connectionStatus == const Connected() &&
        event.server != null &&
        event.server!.ip != state.selectedServer?.ip) {
      await _switchServer(event.server!);
    }

    emit(
      state.copyWith(
        selectedServer: event.server,
        serverSelectionPinned: event.manual ? true : state.serverSelectionPinned,
      ),
    );
  }

  /// User picked "Auto select": give up any manually pinned country. If a
  /// tunnel is currently connected, force a reconnect so it picks up the
  /// widened (all-countries) outbound pool immediately instead of only on the
  /// next connect — otherwise nothing would visibly change right away.
  Future<void> _onAutoSelectRequested(
    AutoSelectRequestedAppEvent event,
    Emitter<AppState> emit,
  ) async {
    _logger.info('[App] Auto select requested — unpinning server selection');
    emit(state.copyWith(serverSelectionPinned: false));

    if (state.connectionStatus == const Connected() &&
        state.selectedServer != null) {
      await _switchServer(state.selectedServer!);
    }

    produceSideEffect(const ShowAutoSelectEnabledToast());
  }

  /// Syncs the displayed server to the one actually routing traffic (resolved
  /// after connect/failover). Display-only: unlike a user selection, it must
  /// NOT switch servers / reconnect — the tunnel is already on this server.
  Future<void> _onActiveServerResolved(
    ActiveServerResolvedEvent event,
    Emitter<AppState> emit,
  ) async {
    if (event.serverIp.isEmpty) return;
    if (state.selectedServer?.ip == event.serverIp) return; // already in sync

    try {
      final servers =
          await getIt<AbstractServersRepository>().getServers(force: false);
      VpnConfiguration? match;
      for (final s in servers) {
        if (s.ip == event.serverIp) {
          match = s;
          break;
        }
      }
      if (match == null) {
        _logger.warning(
          '[App] Active server ${event.serverIp} not found in server list; display not synced',
        );
        return;
      }

      await _preferences.setCurrentServerId(match.ip);
      emit(state.copyWith(selectedServer: match));
      _logger.info(
        '[App] Display synced to actual routing server: ${match.ip} (${match.region.countryCode})',
      );
    } catch (e, st) {
      _logger.error('[App] Failed to sync display to active server', e, st);
    }
  }

  /// Records the post-connect health verdict. Only meaningful while
  /// connected — a stale result arriving after a disconnect is dropped.
  Future<void> _onTunnelHealthChanged(
    TunnelHealthChangedEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state.connectionStatus != const Connected()) return;
    if (!event.healthy) {
      _logger.warning(
        '[App] Tunnel is up but carries no traffic — showing warning state',
      );
    }
    emit(state.copyWith(tunnelHealthy: event.healthy));
  }
}
