// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsentMetadata _$ConsentMetadataFromJson(Map<String, dynamic> json) =>
    ConsentMetadata(
      ip: json['ip'] as String?,
      os: json['os'] as String,
      arch: json['arch'] as String?,
      osVersion: json['osVersion'] as String,
      model: json['model'] as String,
      systemLocale: json['systemLocale'] as String?,
      connectivityType: json['connectivityType'] as String?,
      appVersion: json['appVersion'] as String,
      appBuild: json['appBuild'] as String?,
      sdkVersion: json['sdkVersion'] as String?,
    );

Map<String, dynamic> _$ConsentMetadataToJson(ConsentMetadata instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'os': instance.os,
      'arch': instance.arch,
      'osVersion': instance.osVersion,
      'model': instance.model,
      'systemLocale': instance.systemLocale,
      'connectivityType': instance.connectivityType,
      'appVersion': instance.appVersion,
      'appBuild': instance.appBuild,
      'sdkVersion': instance.sdkVersion,
    };
