import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';

part 'pinged_vpn_configuration.freezed.dart';
part 'pinged_vpn_configuration.g.dart';

@freezed
class PingedVpnConfiguration with _$PingedVpnConfiguration {
  const factory PingedVpnConfiguration({
    required VpnConfiguration configuration,
    String? ping,
  }) = _PingedVpnConfiguration;

  factory PingedVpnConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PingedVpnConfigurationFromJson(json);
}
