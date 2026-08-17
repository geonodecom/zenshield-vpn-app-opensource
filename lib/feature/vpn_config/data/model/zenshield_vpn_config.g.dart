// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zenshield_vpn_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigImpl _$$ConfigImplFromJson(Map<String, dynamic> json) => _$ConfigImpl(
  remoteDns: json['remoteDns'] as String,
  routes: Routes.fromJson(json['routes'] as Map<String, dynamic>),
  outboundsLinks: (json['outboundsLinks'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  logLevel: json['logLevel'] as String,
  logsPath: json['logsPath'] as String,
  directDns: json['directDns'] as String,
  tunImplementation: json['tunImplementation'] as String,
  urlTestInterval: (json['urlTestInterval'] as num).toInt(),
  clashApiToken: json['clashApiToken'] as String,
  clashApiPort: (json['clashApiPort'] as num).toInt(),
  isMobile: json['isMobile'] as bool,
  socksInbound: json['socksInbound'] == null
      ? null
      : SocksInbound.fromJson(json['socksInbound'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ConfigImplToJson(_$ConfigImpl instance) =>
    <String, dynamic>{
      'remoteDns': instance.remoteDns,
      'routes': instance.routes,
      'outboundsLinks': instance.outboundsLinks,
      'logLevel': instance.logLevel,
      'logsPath': instance.logsPath,
      'directDns': instance.directDns,
      'tunImplementation': instance.tunImplementation,
      'urlTestInterval': instance.urlTestInterval,
      'clashApiToken': instance.clashApiToken,
      'clashApiPort': instance.clashApiPort,
      'isMobile': instance.isMobile,
      'socksInbound': instance.socksInbound,
    };

_$RoutesImpl _$$RoutesImplFromJson(Map<String, dynamic> json) => _$RoutesImpl(
  direct: (json['direct'] as List<dynamic>).map((e) => e as String).toList(),
  block: (json['block'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$RoutesImplToJson(_$RoutesImpl instance) =>
    <String, dynamic>{'direct': instance.direct, 'block': instance.block};

_$SocksInboundImpl _$$SocksInboundImplFromJson(Map<String, dynamic> json) =>
    _$SocksInboundImpl(
      enabled: json['enabled'] as bool,
      listen: json['listen'] as String,
      port: (json['port'] as num).toInt(),
      tag: json['tag'] as String,
      direct: json['direct'] as bool,
    );

Map<String, dynamic> _$$SocksInboundImplToJson(_$SocksInboundImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'listen': instance.listen,
      'port': instance.port,
      'tag': instance.tag,
      'direct': instance.direct,
    };
