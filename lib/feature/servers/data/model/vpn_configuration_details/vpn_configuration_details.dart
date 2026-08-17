// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/servers/data/model/protocol/protocol_type.dart';

part 'vpn_configuration_details.freezed.dart';

part 'vpn_configuration_details.g.dart';

@freezed
class VpnConfigurationDetails with _$VpnConfigurationDetails {
  const factory VpnConfigurationDetails({
    required String url,
    @JsonKey(fromJson: _protocolTypeFromJson, toJson: _protocolTypeToJson)
    required ProtocolType protocol,
  }) = _VpnConfigurationDetails;

  factory VpnConfigurationDetails.fromJson(Map<String, dynamic> json) =>
      _$VpnConfigurationDetailsFromJson(json);
}

ProtocolType _protocolTypeFromJson(String value) {
  return ProtocolType.values.firstWhere(
    (protocol) => protocol.name == value,
    orElse: () => throw ArgumentError('Unknown ProtocolType: $value'),
  );
}

String _protocolTypeToJson(ProtocolType protocol) {
  return protocol.name;
}
