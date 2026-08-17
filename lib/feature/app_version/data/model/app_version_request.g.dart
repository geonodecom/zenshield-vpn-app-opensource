// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionRequest _$AppVersionRequestFromJson(Map<String, dynamic> json) =>
    AppVersionRequest(
      hwid: json['hwid'] as String,
      deviceOs: json['device_os'] as String,
      versionOs: json['version_os'] as String,
      deviceModel: json['device_model'] as String,
      appVersion: json['app_version'] as String,
    );

Map<String, dynamic> _$AppVersionRequestToJson(AppVersionRequest instance) =>
    <String, dynamic>{
      'hwid': instance.hwid,
      'device_os': instance.deviceOs,
      'version_os': instance.versionOs,
      'device_model': instance.deviceModel,
      'app_version': instance.appVersion,
    };
