import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';

abstract class AbstractServersRepository {
  Future<VpnConfiguration?> prepare();

  Future<List<VpnConfiguration>> getServers({required bool force});

  Future<VpnConfiguration?> getServerById(String id);

  Future<VpnConfiguration?> getSelectedServer();
}
