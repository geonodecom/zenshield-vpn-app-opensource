// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_configuration_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VpnConfigurationDetailsImpl _$$VpnConfigurationDetailsImplFromJson(
  Map<String, dynamic> json,
) => _$VpnConfigurationDetailsImpl(
  url: json['url'] as String,
  protocol: _protocolTypeFromJson(json['protocol'] as String),
);

Map<String, dynamic> _$$VpnConfigurationDetailsImplToJson(
  _$VpnConfigurationDetailsImpl instance,
) => <String, dynamic>{
  'url': instance.url,
  'protocol': _protocolTypeToJson(instance.protocol),
};
