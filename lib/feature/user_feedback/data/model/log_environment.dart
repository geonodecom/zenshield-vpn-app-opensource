import 'package:json_annotation/json_annotation.dart';

part 'log_environment.g.dart';

@JsonSerializable()
class LogEnvironment {
  const LogEnvironment({
    required this.sessionId,
    required this.timeZoneOffsetInMinutes,
    required this.name,
    required this.email,
    required this.message,
    required this.deviceModel,
    required this.osVersion,
    required this.osType,
    required this.appVersion,
    required this.buildNumber,
  });

  // ignore: unused_element
  factory LogEnvironment.fromJson(Map<String, dynamic> json) =>
      _$LogEnvironmentFromJson(json);

  final String sessionId;
  final double timeZoneOffsetInMinutes;
  final String name;
  final String email;
  final String message;
  final String deviceModel;
  final String osVersion;
  final String osType;
  final String appVersion;
  final String buildNumber;

  Map<String, dynamic> toJson() => _$LogEnvironmentToJson(this);
}
