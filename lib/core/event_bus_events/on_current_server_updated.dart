import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';

class OnCurrentServerUpdated {
  const OnCurrentServerUpdated({required this.server, this.manual = false});
  final VpnConfiguration? server;

  /// True when the user explicitly picked this server (pins routing to its
  /// country), false for programmatic updates like the startup default.
  final bool manual;
}
