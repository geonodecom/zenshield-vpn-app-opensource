import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/singbox/data/models/singbox_vpn_state/singbox_status.dart';

ConnectionStatus mapSingboxStatus(SingboxStatus status) {
  return switch (status) {
    SingboxStopped() => const ConnectionStatus.disconnected(),
    SingboxStarting() => const ConnectionStatus.connecting(),
    SingboxStarted() => const ConnectionStatus.connected(),
    SingboxStopping() => const ConnectionStatus.disconnecting(),
  };
}
