import 'package:zenshield/feature/singbox/data/command_client/command_client_factory.dart';
import 'package:zenshield/feature/singbox/data/command_client/socket_type.dart';
import 'package:zenshield/feature/singbox/data/command_client/stream_command_client.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_status/status_message.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_vpn_state/singbox_status.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class SingboxService {
  SingboxService({
    required this.commandClientFactory,
    required this.logger,
  });

  SocketType? socketType;
  StreamCommandClient<StatusMessage>? statsCommandClient;
  StreamCommandClient<String>? vpnStateCommandClient;

  final AbstractCommandClientFactory commandClientFactory;
  final Talker logger;

  Future<void> init();
  Future<void> start({required String config, bool? isPaid});
  Future<void> stop();
  Future<String> getActualLogs();
  Future<Map<String, String>> getPing(String linksJson);
  Future<void> changeServer(String link, String bearer, int port);
  Future<void> testLink(String link);
  Future<Map<String, dynamic>> getLinksOutboundsMap(String linksJson);

  Stream<StatusMessage> subscribeToStats() {
    try {
      final statsStream = statsCommandClient?.stream;
      if (statsStream == null) throw Exception('Stats stream is null');
      statsCommandClient?.launch();
      return statsStream;
    } catch (e) {
      logger.error('Failed to watch stats: $e');
      rethrow;
    }
  }

  Stream<SingboxStatus> subscribeToVpnState() {
    try {
      final vpnStateStream = vpnStateCommandClient?.stream;
      if (vpnStateStream == null) throw Exception('Vpn state stream is null');
      vpnStateCommandClient?.launch();
      return vpnStateStream.map(
        SingboxStatus.fromEvent,
      );
    } catch (e) {
      logger.error('Failed to watch status: $e');
      return Stream.value(const SingboxStatus.stopped());
    }
  }

  void initClients() {
    try {
      vpnStateCommandClient?.init();
      statsCommandClient?.init();
    } catch (e) {
      logger.error('Failed to init clients: $e');
    }
  }
}
