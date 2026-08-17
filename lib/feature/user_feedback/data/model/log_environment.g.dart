// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_environment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogEnvironment _$LogEnvironmentFromJson(Map<String, dynamic> json) =>
    LogEnvironment(
      sessionId: json['sessionId'] as String,
      timeZoneOffsetInMinutes: (json['timeZoneOffsetInMinutes'] as num)
          .toDouble(),
      name: json['name'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
      deviceModel: json['deviceModel'] as String,
      osVersion: json['osVersion'] as String,
      osType: json['osType'] as String,
      appVersion: json['appVersion'] as String,
      buildNumber: json['buildNumber'] as String,
    );

Map<String, dynamic> _$LogEnvironmentToJson(LogEnvironment instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'timeZoneOffsetInMinutes': instance.timeZoneOffsetInMinutes,
      'name': instance.name,
      'email': instance.email,
      'message': instance.message,
      'deviceModel': instance.deviceModel,
      'osVersion': instance.osVersion,
      'osType': instance.osType,
      'appVersion': instance.appVersion,
      'buildNumber': instance.buildNumber,
    };
