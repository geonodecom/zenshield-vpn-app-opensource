import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:zenshield/core/channels/channels.dart';
import 'package:zenshield/config/constants/common_constants.dart';
import 'package:zenshield/feature/singbox/data/command_client/socket_type.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_vpn_state/singbox_status.dart';
import 'package:zenshield/feature/singbox/data/singbox_service.dart';

class PlatformSingboxService extends SingboxService {
  PlatformSingboxService({
    required super.commandClientFactory,
    required super.logger,
  });

  final channelPrefix = Channels.bundleName;
  MethodChannel? _methodChannel;
  MethodChannel get methodChannel {
    _methodChannel ??= MethodChannel('$channelPrefix/method');
    return _methodChannel!;
  }

  static String get _vpnStatusEventChannelName => '${Channels.bundleName}/vpn_status';

  @override
  Stream<SingboxStatus> subscribeToVpnState() {
    if (Platform.isMacOS) {
      try {
        final nativeStream = EventChannel(_vpnStatusEventChannelName)
            .receiveBroadcastStream()
            .map((e) => e as String);
        try {
          vpnStateCommandClient?.launch();
        } catch (_) {
          // Socket may not exist yet (tunnel not started); native stream will still deliver status
        }
        final socketStream = vpnStateCommandClient?.stream ?? const Stream<String>.empty();
        final controller = StreamController<String>.broadcast();
        nativeStream.listen(
          controller.add,
          onError: controller.addError,
          onDone: () {},
        );
        socketStream.listen(
          controller.add,
          onError: controller.addError,
          onDone: () {},
        );
        return controller.stream.map(SingboxStatus.fromEvent);
      } catch (e) {
        logger.error('Failed to watch VPN status on macOS: $e');
        return Stream.value(const SingboxStatus.stopped());
      }
    }
    return super.subscribeToVpnState();
  }

  @override
  Future<void> init() async {
    try {
      final result = await methodChannel.invokeMethod('init');
      final paths = Map<String, dynamic>.from(result as Map);
      final basePath = paths['basePath'] as String;
      final currentSocketType = UnixSocketType(path: '$basePath/command.sock');
      socketType = currentSocketType;

      statsCommandClient = commandClientFactory.createStatusStream(
        socketType: currentSocketType,
      );
      vpnStateCommandClient = commandClientFactory.createVpnStateStream(
        socketType: currentSocketType,
      );
      initClients();
    } catch (e) {
      logger.error('[VPN] Failed to init VPN: $e');
    }
  }

  @override
  Future<void> start({
    required String config,
    bool? isPaid,
  }) async {
    try {
      if (vpnStateCommandClient == null) {
        throw Exception(
          'Vpn State client is null',
        );
      }
      vpnStateCommandClient?.addCustomEvent(
        const SingboxStatus.starting().toEvent(),
      );
      await methodChannel.invokeMethod('start', {
        'config': config,
        'isPaid': isPaid ?? false,
        'timeoutSec': CommonConstants.vpnTurnOffTimeoutSec,
      });

      // For animation
      await Future<void>.delayed(const Duration(milliseconds: 800));
      await vpnStateCommandClient?.launch();
      await statsCommandClient?.launch();
    } catch (e) {
      vpnStateCommandClient?.addCustomEvent(
        const SingboxStatus.stopped().toEvent(),
      );
      logger.error('[VPN] Failed to start: $e');
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    try {
      if (vpnStateCommandClient == null) {
        throw Exception(
          'Vpn State client is null',
        );
      }
      vpnStateCommandClient?.addCustomEvent(
        const SingboxStatus.stopping().toEvent(),
      );
      await methodChannel.invokeMethod('stop');
      if (Platform.isIOS || Platform.isMacOS) {
        // Disabling VPN on iOS and MacOS is not instant
        await Future<void>.delayed(const Duration(milliseconds: 800));
      }
    } catch (e) {
      logger.error('[VPN] Failed to stop: $e');
      rethrow;
    } finally {
      vpnStateCommandClient?.stop();
      statsCommandClient?.stop();
      vpnStateCommandClient?.addCustomEvent(
        const SingboxStatus.stopped().toEvent(),
      );
    }
  }

  @override
  Future<String> getActualLogs() async {
    try {
      final currentSocketType = socketType;
      if (currentSocketType == null) throw Exception('Socket type is not set');

      if (currentSocketType is UnixSocketType) {
        final socketFile = File(currentSocketType.path);
        // ignore: avoid_slow_async_io
        final exists = await socketFile.exists();
        if (!exists) {
          logger.info('[VPN] Socket file does not exist, VPN is likely not running');
          return '';
        }
      }

      final logLines = await commandClientFactory.getLogs(
        socketType: currentSocketType,
      );
      return '${logLines.join('\n')}\n';
    } catch (e) {
      logger.error('[VPN] Failed to get actual logs: $e');
      return '';
    }
  }

  @override
  Future<Map<String, String>> getPing(String linksJson) async {
    try {
      final response =
          await methodChannel.invokeMethod('get_ping', linksJson) as String;
      final map = jsonDecode(response) as Map<String, dynamic>;

      return map.map(
        (configUrl, pingValue) => MapEntry(configUrl, pingValue as String),
      );
    } catch (e) {
      logger.error('[VPN] Failed to get ping: $e');
      return {};
    }
  }

  @override
  Future<void> changeServer(
    String link,
    String bearer,
    int port,
  ) async {
    try {
      final args = {'link': link, 'bearer': bearer, 'port': port};
      await methodChannel.invokeMethod('change_server', args);
    } catch (e) {
      logger.error('[VPN] Failed to change server: $e');
    }
  }

  @override
  Future<void> testLink(String link) async {
    try {
      await methodChannel.invokeMethod('test_link', link);
    } catch (e) {
      logger.error('[VPN] Failed to test link: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getLinksOutboundsMap(String linksJson) async {
    try {
      final response = await methodChannel.invokeMethod(
        'get_links_outbounds',
        linksJson,
      ) as String;
      final map = jsonDecode(response) as Map<String, dynamic>;
      return map;
    } catch (e) {
      logger.error('[VPN] Failed to get links outbounds map: $e');
      return {};
    }
  }
}
