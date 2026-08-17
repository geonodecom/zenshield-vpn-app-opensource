// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Agreement _$AgreementFromJson(Map<String, dynamic> json) => Agreement(
  id: (json['id'] as num).toInt(),
  text: json['text'] as String,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$AgreementToJson(Agreement instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'createdAt': instance.createdAt,
};
