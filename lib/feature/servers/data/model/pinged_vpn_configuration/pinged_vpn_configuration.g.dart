// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinged_vpn_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PingedVpnConfigurationImpl _$$PingedVpnConfigurationImplFromJson(
  Map<String, dynamic> json,
) => _$PingedVpnConfigurationImpl(
  configuration: VpnConfiguration.fromJson(
    json['configuration'] as Map<String, dynamic>,
  ),
  ping: json['ping'] as String?,
);

Map<String, dynamic> _$$PingedVpnConfigurationImplToJson(
  _$PingedVpnConfigurationImpl instance,
) => <String, dynamic>{
  'configuration': instance.configuration,
  'ping': instance.ping,
};
