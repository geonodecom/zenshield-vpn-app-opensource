import 'package:json_annotation/json_annotation.dart';
import 'package:zenshield/feature/agreements/data/model/agreement.dart';

part 'agreements_response.g.dart';

@JsonSerializable()
class AgreementsResponse {
  const AgreementsResponse({
    required this.isFirstTime,
    this.agreement,
  });

  factory AgreementsResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreementsResponseFromJson(json);

  final bool isFirstTime;
  final Agreement? agreement;

  Map<String, dynamic> toJson() => _$AgreementsResponseToJson(this);
}
