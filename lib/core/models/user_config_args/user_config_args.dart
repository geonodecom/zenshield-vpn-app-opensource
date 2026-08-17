import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';

part 'user_config_args.freezed.dart';

@freezed
class UserConfigArgs with _$UserConfigArgs {
  const factory UserConfigArgs({
    required UserVpnConfiguration? config,
    required bool isSelectedConfig,
  }) = _UserConfigArgs;
}
