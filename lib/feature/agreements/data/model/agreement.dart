import 'package:json_annotation/json_annotation.dart';

part 'agreement.g.dart';

@JsonSerializable()
class Agreement {
  const Agreement({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  factory Agreement.fromJson(Map<String, dynamic> json) =>
      _$AgreementFromJson(json);

  final int id;
  final String text;
  final String createdAt;

  Map<String, dynamic> toJson() => _$AgreementToJson(this);
}
