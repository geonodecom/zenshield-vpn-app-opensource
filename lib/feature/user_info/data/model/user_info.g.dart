// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoImpl _$$UserInfoImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoImpl(
      id: json['id'] as String,
      ip: json['ip'] as String,
      status: $enumDecode(_$AccountStatusEnumMap, json['status']),
      region: RegionResponse.fromJson(json['region'] as Map<String, dynamic>),
      availableTraffic: (json['availableTraffic'] as num).toDouble(),
      email: json['email'] as String?,
      securedSince: json['secured_since'] == null
          ? null
          : DateTime.parse(json['secured_since'] as String),
    );

Map<String, dynamic> _$$UserInfoImplToJson(_$UserInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ip': instance.ip,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'region': instance.region,
      'availableTraffic': instance.availableTraffic,
      'email': instance.email,
      'secured_since': instance.securedSince?.toIso8601String(),
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.inactive: 'inactive',
  AccountStatus.suspended: 'suspended',
};
