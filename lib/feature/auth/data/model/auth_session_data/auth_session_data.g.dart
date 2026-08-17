// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSessionDataImpl _$$AuthSessionDataImplFromJson(
  Map<String, dynamic> json,
) => _$AuthSessionDataImpl(
  email: json['email'] as String?,
  authType: $enumDecodeNullable(_$AuthTypeEnumMap, json['authType']),
  resetToken: json['resetToken'] as String?,
);

Map<String, dynamic> _$$AuthSessionDataImplToJson(
  _$AuthSessionDataImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'authType': _$AuthTypeEnumMap[instance.authType],
  'resetToken': instance.resetToken,
};

const _$AuthTypeEnumMap = {
  AuthType.login: 'login',
  AuthType.register: 'register',
  AuthType.changePass: 'changePass',
  AuthType.delete: 'delete',
};
