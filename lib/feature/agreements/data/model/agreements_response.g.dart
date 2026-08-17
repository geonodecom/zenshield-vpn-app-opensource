// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsResponse _$AgreementsResponseFromJson(Map<String, dynamic> json) =>
    AgreementsResponse(
      isFirstTime: json['isFirstTime'] as bool,
      agreement: json['agreement'] == null
          ? null
          : Agreement.fromJson(json['agreement'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgreementsResponseToJson(AgreementsResponse instance) =>
    <String, dynamic>{
      'isFirstTime': instance.isFirstTime,
      'agreement': instance.agreement,
    };
