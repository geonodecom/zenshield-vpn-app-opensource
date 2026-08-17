import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/config/constants/secure_storage_keys.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/core/managers/analytics_schema.dart';
import 'package:zenshield/core/event_bus_events/active_server_resolved.dart';
import 'package:zenshield/core/event_bus_events/tunnel_health_changed.dart';
import 'package:zenshield/core/event_bus_events/vpn_state_changed.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/services/platform_settings_service.dart';
import 'package:zenshield/core/utils/connection_status_mapper.dart';
import 'package:zenshield/core/utils/vpn_auto_failover.dart';
import 'package:zenshield/core/utils/vpn_connectivity_diagnostics.dart';
import 'package:zenshield/core/utils/utils.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/launch/domain/repositories/launch_on_startup_manager.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_status/status_message.dart';
import 'package:zenshield/feature/singbox/data/singbox_service.dart';
import 'package:zenshield/feature/timer/domain/repositories/abstract_timer_control.dart';
import 'package:zenshield/feature/timer/domain/repositories/timer_factory.dart';
import 'package:zenshield/feature/vpn_config/domain/repositories/vpn_config_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';

// ignore: unused-code
@LazySingleton(as: AbstractVpnManager)
class VpnManager implements AbstractVpnManager {
  VpnManager({
    required SingboxService singboxService,
    required AbstractTimerFactory timerFactory,
    required AbstractVpnConfigRepository configRepository,
    required Preferences preferences,
    required AbstractLaunchOnStartupManager launchOnStartupManager,
    required FlutterSecureStorage secureStorage,
    required Talker logger,
    required EventBus eventBus,
    required AbstractServersRepository serversRepository,
    required AbstractAnalyticsManager analyticsManager,
    required AbstractPlatformSettingsService platformSettingsService,
  })  : _singboxService = singboxService,
        _timerFactory = timerFactory,
        _configRepository = configRepository,
        _preferences = preferences,
        _launchOnStartupManager = launchOnStartupManager,
        _secureStorage = secureStorage,
        _logger = logger,
        _eventBus = eventBus,
        _serversRepository = serversRepository,
        _analyticsManager = analyticsManager,
        _platformSettingsService = platformSettingsService;

  AbstractTimerControl? _timerControl;
  bool? isPaid;
  bool _preserveTimer = false;
  bool _isServerSwitching = false;
  bool _autoFailoverRunning = false;

  final SingboxService _singboxService;
  final AbstractTimerFactory _timerFactory;
  final AbstractVpnConfigRepository _configRepository;
  final Preferences _preferences;
  final AbstractLaunchOnStartupManager _launchOnStartupManager;
  final FlutterSecureStorage _secureStorage;
  final Talker _logger;
  final EventBus _eventBus;
  final AbstractServersRepository _serversRepository;
  final AbstractAnalyticsManager _analyticsManager;
  final AbstractPlatformSettingsService _platformSettingsService;

  StreamSubscription<dynamic>? statusSubscription;
  @override
  ConnectionStatus status = const Disconnected();

  @override
  Future<void> init() async {
    try {
      _logger.info('[VPN] Initializing VPN service');
      await _singboxService.init();
      _logger.info('[VPN] VPN service initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('[VPN] Failed to initialize VPN service', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> enableVpn({required bool isPaid}) async {
    try {
      this.isPaid = isPaid;
      _logger.info('[VPN] Attempting to enable VPN (isPaid: $isPaid)');

      final currentProtocol = await _preferences.currentProtocol;
      _logger.info(
          '[VPN] Current protocol: ${currentProtocol?.name ?? 'not set'}');

      final configs = await _configRepository.loadConfig();
      final configsString = jsonEncode(configs);

      final outbounds = configs['outbounds'] as List?;
      if (outbounds != null) {
        _logger.info(
            '[VPN] Loaded VPN configuration with ${outbounds.length} outbound servers');
      } else {
        _logger.info('[VPN] Loaded VPN configuration');
      }

      final startTime = DateTime.now();
      await _singboxService.start(config: configsString, isPaid: isPaid);
      final duration = DateTime.now().difference(startTime);

      _logger.info(
          '[VPN] VPN start command sent successfully (took ${duration.inMilliseconds}ms)');
    } catch (e, stackTrace) {
      _logger.error('[VPN] Failed to enable VPN', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> disableVpn({bool preserveTimer = false}) async {
    try {
      _preserveTimer = preserveTimer;
      if (preserveTimer) _isServerSwitching = true;
      if (!preserveTimer) {
        await _preferences.setVpnRestoreOnBoot(false);
        if (Platform.isWindows) {
          await _launchOnStartupManager.disableForBootRestoreIfNeeded();
        }
      }
      _logger.info('[VPN] Attempting to disable VPN (preserveTimer: $preserveTimer)');
      final startTime = DateTime.now();

      await _singboxService.stop();
      final duration = DateTime.now().difference(startTime);

      _logger.info(
          '[VPN] VPN stop command sent successfully (took ${duration.inMilliseconds}ms)');
    } catch (e, stackTrace) {
      _logger.error('[VPN] Failed to disable VPN', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> cancelServerSwitch() async {
    _logger.info('[VPN] Cancelling server switch');
    _isServerSwitching = false;
    _preserveTimer = false;
    await _timerControl?.stop();
    _timerControl = null;
    _eventBus.fire(VpnStateChanged(connectionStatus: const Disconnected()));
  }

  @override
  Future<void> resumeTimer({required bool isPaid}) async {
    try {
      _logger.info('[VPN] Attempting to resume timer (isPaid: $isPaid)');
      _timerControl = _timerFactory.getTimer(isPaid: isPaid);
      await _timerControl?.start();
      _logger.info('[VPN] Timer resumed successfully');
    } catch (e, stackTrace) {
      _logger.error('[VPN] Failed to resume timer', e, stackTrace);
      rethrow;
    }
  }

  /// Runs the read-only connectivity diagnostics, then the auto-failover which
  /// verifies real traffic through the tunnel and switches to a working server
  /// if the selected one is dead. Guarded so only one pass runs at a time.
  Future<void> _runDiagnosticsThenFailover() async {
    if (_autoFailoverRunning) {
      _logger.info('[VPN] Post-connect health check already running — skipping duplicate trigger');
      return;
    }
    _autoFailoverRunning = true;
    _logger.info('[VPN] Post-connect health check starting (diagnostics + [VPN-FAILOVER] probe)');
    try {
      await VpnConnectivityDiagnostics(
        logger: _logger,
        singboxService: _singboxService,
        configRepository: _configRepository,
        preferences: _preferences,
      ).run();

      // The server the user was on when the probe started — if failover ends
      // up switching away or declaring the tunnel unhealthy, this is the node
      // that died.
      final probedServerIp = await _preferences.currentServerId;
      final pinned = await _preferences.serverSelectionPinned;

      final result = await VpnAutoFailover(
        logger: _logger,
        configRepository: _configRepository,
        preferences: _preferences,
        secureStorage: _secureStorage,
        serversRepository: _serversRepository,
      ).run(
        // Stop failing over the moment the tunnel drops or the user takes over
        // server selection, so we never fight a manual switch or a disconnect.
        shouldContinue: () => status is Connected && !_isServerSwitching,
        // Only confine failover to the current country when the user actually
        // chose it; an auto-selected country is free to be searched fully.
        pinned: pinned,
      );

      if (result.healthy == false) {
        unawaited(_reportNodeDeath(
          deadServerIp: probedServerIp,
          switchedToIp: null,
          failoverResult: 'no_healthy_candidate',
          serversTried: result.serversTried,
        ));
      } else if (result.healthy == true &&
          result.currentServerFailed &&
          probedServerIp != null &&
          result.activeHost != null &&
          result.activeHost != probedServerIp) {
        // The selected node was dead but traffic was rescued through another
        // exit — either by our failover switch or by sing-box's urltest
        // re-routing (auto mode). Both are a death of the probed node.
        unawaited(_reportNodeDeath(
          deadServerIp: probedServerIp,
          switchedToIp: result.activeHost,
          failoverResult: 'switched',
          serversTried: result.serversTried,
        ));
      }

      // Sync the UI to the server actually routing traffic (auto-select or a
      // failover switch can differ from what the user picked). Display-only —
      // must not trigger a reconnect.
      final activeServerIp = result.activeHost;
      if (activeServerIp != null &&
          activeServerIp.isNotEmpty &&
          status is Connected) {
        _eventBus.fire(ActiveServerResolved(serverIp: activeServerIp));
      }

      // Tell the UI whether the tunnel actually carries traffic, so a dead
      // exit server shows as a warning instead of a plain green "Connected".
      final healthy = result.healthy;
      if (healthy != null && status is Connected) {
        _eventBus.fire(TunnelHealthChanged(healthy: healthy));
      }

      _logger.info(
        '[VPN] Post-connect health check finished — healthy=$healthy activeHost=${result.activeHost ?? "unknown"} serversTried=${result.serversTried}',
      );
    } catch (e, stackTrace) {
      _logger.error('[VPN] Post-connect verification failed', e, stackTrace);
    } finally {
      _autoFailoverRunning = false;
    }
  }

  /// Reports a `vpn_node_death` to analytics: the tunnel handshake succeeded
  /// but [deadServerIp] carries no real traffic (dashboard shows it green, the
  /// VPN data port is dead). Never throws — analytics must not affect the VPN.
  Future<void> _reportNodeDeath({
    required String? deadServerIp,
    required String? switchedToIp,
    required String failoverResult,
    required int serversTried,
  }) async {
    try {
      var serverCountry = '';
      var serverCity = '';
      var serverPort = '';
      try {
        final servers = await _serversRepository.getServers(force: false);
        for (final s in servers) {
          if (s.ip == deadServerIp) {
            serverCountry = s.region.countryCode;
            if (s is SystemVpnConfiguration) serverCity = s.city;
            if (s.configurations.isNotEmpty) {
              final port = Uri.parse(s.configurations.first.url).port;
              if (port != 0) serverPort = port.toString();
            }
            break;
          }
        }
      } catch (_) {
        // Server list unavailable — send the event with what we have.
      }

      var networkType = 'unknown';
      try {
        final results = await Connectivity().checkConnectivity();
        if (results.isNotEmpty) {
          networkType = results.map((r) => r.name).join(',');
        }
      } catch (_) {}

      final protocol = await _preferences.currentProtocol;

      await _analyticsManager.sendEvent(
        AnalyticsEventNames.vpn_node_death,
        {
          AnalyticsProps.serverIp: deadServerIp ?? '',
          AnalyticsProps.serverCountry: serverCountry,
          AnalyticsProps.serverCity: serverCity,
          AnalyticsProps.serverPort: serverPort,
          // Never-set preference means the app default (auto).
          AnalyticsProps.protocol: protocol?.name ?? 'auto',
          AnalyticsProps.failureType: 'traffic_blackhole',
          AnalyticsProps.failureStage: 'post_connect_probe',
          AnalyticsProps.tunnelEstablished: 'true',
          AnalyticsProps.probePassed: 'false',
          AnalyticsProps.networkType: networkType,
          AnalyticsProps.failoverResult: failoverResult,
          AnalyticsProps.failoverToIp: switchedToIp ?? '',
          AnalyticsProps.serversTried: serversTried.toString(),
        },
      );
      _logger.info(
        '[VPN] node death reported — server=$deadServerIp result=$failoverResult',
      );
    } catch (e) {
      _logger.warning('[VPN] failed to report node death: $e');
    }
  }

  @override
  Stream<StatusMessage> subscribeToStats() {
    return _singboxService.subscribeToStats();
  }

  @override
  Future<void> subscribeToVpnState({required bool isPaid}) async {
    try {
      _logger.info('[VPN] Subscribing to VPN state changes (isPaid: $isPaid)');

      // The status stream only ever reports future transitions, not a
      // current-state snapshot on subscribe. Without this, reopening the app
      // while the tunnel is still active at the OS level (e.g. after being
      // force-closed) leaves `status` stuck at its Disconnected default until
      // the next real transition — which never comes — showing "Not
      // Connected" while the VPN is actually up.
      if (Platform.isAndroid) {
        try {
          final isActive = await _platformSettingsService.isVpnActive();
          if (isActive && status is! Connected) {
            _logger.info(
                '[VPN] Native VPN tunnel already active on startup - syncing status to Connected');
            this.isPaid = isPaid;
            status = const Connected();
            _isServerSwitching = false;
            _timerControl = _timerFactory.getTimer(isPaid: isPaid);
            await _timerControl?.start();
            _eventBus.fire(VpnStateChanged(connectionStatus: status));
          }
        } catch (e, stackTrace) {
          _logger.error(
              '[VPN] Failed to check native VPN active state', e, stackTrace);
        }
      }

      statusSubscription = _singboxService
          .subscribeToVpnState()
          .map(mapSingboxStatus)
          .skipWhile(
              (status) => status == const ConnectionStatus.disconnected())
          .distinct()
          .listen(
        (status) async {
          try {
            final previousStatus = this.status;
            final timestamp = DateTime.now();

            switch (status) {
              case Connected():
                _isServerSwitching = false;
                await _preferences.setVpnRestoreOnBoot(true);
                if (Platform.isWindows) {
                  await _launchOnStartupManager.enableForBootRestoreIfNeeded();
                }
                _logger.info(
                    '[VPN] Connection established - VPN is now connected at $timestamp');

                try {
                  final currentServerId = await _preferences.currentServerId;
                  final currentProtocol = await _preferences.currentProtocol;
                  if (currentServerId != null) {
                    _logger.info(
                        '[VPN] Connected to server: $currentServerId (protocol: ${currentProtocol?.name ?? 'unknown'})');
                  }
                } catch (e) {
                  _logger.debug('[VPN] Could not retrieve server info: $e');
                }

                _timerControl =
                    _timerFactory.getTimer(isPaid: this.isPaid ?? isPaid);
                await _timerControl?.start();
                _logger.info('[VPN] Timer started after connection');

                unawaited(_runDiagnosticsThenFailover());
              case Connecting():
                _logger.info(
                    '[VPN] Connection in progress - attempting to connect (previous status: $previousStatus)');
              case Disconnected():
                _logger.info(
                    '[VPN] Connection terminated - VPN is now disconnected at $timestamp');
                if (_preserveTimer) {
                  _preserveTimer = false;
                  _logger.info('[VPN] Timer kept running during server switch');
                } else {
                  _isServerSwitching = false;
                  await _preferences.setVpnRestoreOnBoot(false);
                  if (Platform.isWindows) {
                    await _launchOnStartupManager.disableForBootRestoreIfNeeded();
                  }
                  await _timerControl?.stop();
                  _timerControl = null;
                  _logger.info('[VPN] Timer stopped after disconnection');
                }
              case Disconnecting():
                _logger.info(
                    '[VPN] Disconnection in progress - shutting down VPN (previous status: $previousStatus)');
            }

            this.status = status;
            _logger.info(
                '[VPN] Connection status changed: $previousStatus -> $status');
            _eventBus.fire(VpnStateChanged(connectionStatus: status, isServerSwitch: _isServerSwitching));
          } catch (e, stackTrace) {
            _logger.error(
                '[VPN] Error handling VPN state change', e, stackTrace);
          }
        },
        onError: (error, stackTrace) {
          _logger.error('[VPN] Error in VPN state subscription stream', error,
              stackTrace);
        },
        onDone: () {
          _logger.warning('[VPN] VPN state subscription stream closed');
        },
      );

      _logger.info('[VPN] Successfully subscribed to VPN state changes');
    } catch (e, stackTrace) {
      _logger.error(
          '[VPN] Failed to subscribe to VPN state changes', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Map<String, String>> getServersPing(
    List<VpnConfiguration> servers,
  ) async {
    try {
      final links = servers
          .where((s) => s.configurations.isNotEmpty)
          .map((s) => s.configurations.first.url)
          .toList();

      final linksJson = jsonEncode(links);
      _logger.info('[VPN] Getting ping for ${links.length} servers');

      final startTime = DateTime.now();
      final pingMap = await _singboxService.getPing(linksJson);
      final duration = DateTime.now().difference(startTime);

      _logger.info(
          '[VPN] Ping completed for ${pingMap.length} servers (took ${duration.inMilliseconds}ms)');
      _logger.debug('[VPN] Ping results: $pingMap');

      return pingMap;
    } catch (e, stackTrace) {
      _logger.error('[VPN] Failed to get servers ping', e, stackTrace);
      rethrow;
    }
  }

  @override
  void dispose() {
    _logger.info('[VPN] Disposing VPN manager');
    unawaited(statusSubscription?.cancel());
    _logger.info('[VPN] VPN manager disposed');
  }

  @override
  Future<void> changeServer(VpnConfiguration server) async {
    try {
      final currentProtocol = await _preferences.currentProtocol;
      _logger.info(
          '[VPN] Attempting to change server to ${server.ip} (protocol: ${currentProtocol?.name ?? 'unknown'})');

      final protocolPrefix = Utils.getProtocolPrefix(currentProtocol);

      final currentLink = server is! UserVpnConfiguration
          ? server.configurations
              .where((e) => e.url.startsWith(protocolPrefix))
              .map((e) => e.url)
              .first
          : server.configurations.map((e) => e.url).first;

      _logger.debug(
          '[VPN] Selected link: ${currentLink.substring(0, currentLink.length > 50 ? 50 : currentLink.length)}...');

      final (token, port) = await (
        _secureStorage.read(
          key: SecureStorageKeys.clashApiToken,
        ),
        _secureStorage.read(
          key: SecureStorageKeys.clashApiPort,
        ),
      ).wait;

      final intPort = int.tryParse(port ?? '');

      if (token == null) {
        final error = Exception('Clash api bearer is null');
        _logger.error(
            '[VPN] Failed to change server: missing API token', error);
        throw error;
      }
      if (intPort == null) {
        final error = Exception('Clash api port is null');
        _logger.error('[VPN] Failed to change server: invalid API port', error);
        throw error;
      }

      final startTime = DateTime.now();
      await _singboxService.changeServer(currentLink, token, intPort);
      final duration = DateTime.now().difference(startTime);

      _logger.info(
          '[VPN] Server changed successfully to ${server.ip} (took ${duration.inMilliseconds}ms)');
    } catch (e, stackTrace) {
      _logger.error(
          '[VPN] Failed to change server to ${server.ip}', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> testLink(String link) async {
    await _singboxService.testLink(link);
  }

  @override
  Future<String> getLinkHost(String link) async {
    final links = [link];
    final jsonString = jsonEncode(links);
    final outboundsMap = await _singboxService.getLinksOutboundsMap(jsonString);
    final outbound = outboundsMap[link] as Map<String, dynamic>?;

    if (outbound == null || !outbound.containsKey('server')) {
      return 'Unknown';
    }

    return outbound['server'] as String;
  }
}
