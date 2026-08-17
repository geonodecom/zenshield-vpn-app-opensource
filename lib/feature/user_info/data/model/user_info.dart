// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/region_checker/data/model/region_response.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

enum AccountStatus { active, inactive, suspended }

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String id,
    required String ip,
    required AccountStatus status,
    required RegionResponse region,
    required double availableTraffic,
    String? email,
    @JsonKey(name: 'secured_since') DateTime? securedSince,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
