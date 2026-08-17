import 'package:json_annotation/json_annotation.dart';

part 'app_version_request.g.dart';

@JsonSerializable()
class AppVersionRequest {
  const AppVersionRequest({
    required this.hwid,
    required this.deviceOs,
    required this.versionOs,
    required this.deviceModel,
    required this.appVersion,
  });

  factory AppVersionRequest.fromJson(Map<String, dynamic> json) =>
      _$AppVersionRequestFromJson(json);

  final String hwid;
  @JsonKey(name: 'device_os')
  final String deviceOs;
  @JsonKey(name: 'version_os')
  final String versionOs;
  @JsonKey(name: 'device_model')
  final String deviceModel;
  @JsonKey(name: 'app_version')
  final String appVersion;

  Map<String, dynamic> toJson() => _$AppVersionRequestToJson(this);
}
