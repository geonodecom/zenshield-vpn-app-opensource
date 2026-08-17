import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';

class VpnStateChanged {
  VpnStateChanged({required this.connectionStatus, this.isServerSwitch = false});

  final ConnectionStatus connectionStatus;
  final bool isServerSwitch;
}
