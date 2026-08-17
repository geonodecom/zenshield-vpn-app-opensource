import 'package:json_annotation/json_annotation.dart';
import 'package:zenshield/feature/agreements/data/model/consent_metadata.dart';

part 'consent_request.g.dart';

@JsonSerializable()
class ConsentRequest {
  const ConsentRequest({
    required this.externalId,
    required this.userId,
    required this.deviceId,
    required this.agreementId,
    required this.metadata,
  });

  factory ConsentRequest.fromJson(Map<String, dynamic> json) =>
      _$ConsentRequestFromJson(json);

  final String externalId;
  final String userId;
  final String deviceId;
  final int agreementId;
  final ConsentMetadata metadata;

  Map<String, dynamic> toJson() => _$ConsentRequestToJson(this);
}
