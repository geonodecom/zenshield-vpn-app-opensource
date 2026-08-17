import 'package:json_annotation/json_annotation.dart';

part 'consent_metadata.g.dart';

@JsonSerializable()
class ConsentMetadata {
  const ConsentMetadata({
    this.ip,
    required this.os,
    this.arch,
    required this.osVersion,
    required this.model,
    this.systemLocale,
    this.connectivityType,
    required this.appVersion,
    this.appBuild,
    this.sdkVersion,
  });

  factory ConsentMetadata.fromJson(Map<String, dynamic> json) =>
      _$ConsentMetadataFromJson(json);

  final String? ip;
  final String os;
  final String? arch;
  final String osVersion;
  final String model;
  final String? systemLocale;
  final String? connectivityType;
  final String appVersion;
  final String? appBuild;
  final String? sdkVersion;

  Map<String, dynamic> toJson() => _$ConsentMetadataToJson(this);
}
