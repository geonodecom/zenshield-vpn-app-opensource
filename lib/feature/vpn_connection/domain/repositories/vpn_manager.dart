import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_status/status_message.dart';

abstract class AbstractVpnManager {
  ConnectionStatus get status;

  Future<void> init();

  Future<void> enableVpn({required bool isPaid});

  Future<void> disableVpn({bool preserveTimer = false});

  Future<void> cancelServerSwitch();

  Future<void> resumeTimer({required bool isPaid});

  Stream<StatusMessage> subscribeToStats();

  Future<void> subscribeToVpnState({required bool isPaid});

  Future<Map<String, String>> getServersPing(
    List<VpnConfiguration> servers,
  );

  Future<void> changeServer(VpnConfiguration server);

  Future<void> testLink(String link);

  Future<String> getLinkHost(String link);

  void dispose();
}
