// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsentRequest _$ConsentRequestFromJson(Map<String, dynamic> json) =>
    ConsentRequest(
      externalId: json['externalId'] as String,
      userId: json['userId'] as String,
      deviceId: json['deviceId'] as String,
      agreementId: (json['agreementId'] as num).toInt(),
      metadata: ConsentMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ConsentRequestToJson(ConsentRequest instance) =>
    <String, dynamic>{
      'externalId': instance.externalId,
      'userId': instance.userId,
      'deviceId': instance.deviceId,
      'agreementId': instance.agreementId,
      'metadata': instance.metadata,
    };
