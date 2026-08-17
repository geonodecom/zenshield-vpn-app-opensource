// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemVpnConfigurationImpl _$$SystemVpnConfigurationImplFromJson(
  Map<String, dynamic> json,
) => _$SystemVpnConfigurationImpl(
  ip: json['ip'] as String,
  region: RegionResponse.fromJson(json['region'] as Map<String, dynamic>),
  configurations: (json['configurations'] as List<dynamic>)
      .map((e) => VpnConfigurationDetails.fromJson(e as Map<String, dynamic>))
      .toList(),
  city: json['city'] as String,
  isFree: json['isFree'] as bool,
  isFavorite: json['isFavorite'] as bool? ?? false,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$$SystemVpnConfigurationImplToJson(
  _$SystemVpnConfigurationImpl instance,
) => <String, dynamic>{
  'ip': instance.ip,
  'region': instance.region,
  'configurations': instance.configurations,
  'city': instance.city,
  'isFree': instance.isFree,
  'isFavorite': instance.isFavorite,
  'type': instance.$type,
};

_$UserVpnConfigurationImpl _$$UserVpnConfigurationImplFromJson(
  Map<String, dynamic> json,
) => _$UserVpnConfigurationImpl(
  ip: json['ip'] as String,
  region: RegionResponse.fromJson(json['region'] as Map<String, dynamic>),
  configurations: (json['configurations'] as List<dynamic>)
      .map((e) => VpnConfigurationDetails.fromJson(e as Map<String, dynamic>))
      .toList(),
  title: json['title'] as String,
  isFavorite: json['isFavorite'] as bool? ?? false,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$$UserVpnConfigurationImplToJson(
  _$UserVpnConfigurationImpl instance,
) => <String, dynamic>{
  'ip': instance.ip,
  'region': instance.region,
  'configurations': instance.configurations,
  'title': instance.title,
  'isFavorite': instance.isFavorite,
  'type': instance.$type,
};
