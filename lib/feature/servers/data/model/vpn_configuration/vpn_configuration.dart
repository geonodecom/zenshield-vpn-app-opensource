import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/region_checker/data/model/region_response.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration_details/vpn_configuration_details.dart';

part 'vpn_configuration.freezed.dart';
part 'vpn_configuration.g.dart';

@Freezed(unionKey: 'type')
sealed class VpnConfiguration with _$VpnConfiguration {
  const factory VpnConfiguration.system({
    required String ip,
    required RegionResponse region,
    required List<VpnConfigurationDetails> configurations,
    required String city,
    required bool isFree,
    @Default(false) bool isFavorite,
  }) = SystemVpnConfiguration;

  const factory VpnConfiguration.user({
    required String ip,
    required RegionResponse region,
    required List<VpnConfigurationDetails> configurations,
    required String title,
    @Default(false) bool isFavorite,
  }) = UserVpnConfiguration;

  factory VpnConfiguration.fromJson(Map<String, dynamic> json) =>
      _$VpnConfigurationFromJson(json);
}
