// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UrlInfoImpl _$$UrlInfoImplFromJson(Map<String, dynamic> json) =>
    _$UrlInfoImpl(
      url: json['url'] as String,
      name: json['name'] as String,
      isUsersUrl: json['isUsersUrl'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$UrlInfoImplToJson(_$UrlInfoImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'isUsersUrl': instance.isUsersUrl,
      'isActive': instance.isActive,
    };
