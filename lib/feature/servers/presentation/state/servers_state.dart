import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/servers/data/model/pinged_vpn_configuration/pinged_vpn_configuration.dart';

part 'servers_state.freezed.dart';

@freezed
class ServersState with _$ServersState {
  const factory ServersState.initial({
    @Default([]) List<PingedVpnConfiguration> servers,
    @Default([]) List<PingedVpnConfiguration> filteredServers,
    @Default(false) bool isLoading,
    @Default(false) bool isSearchActive,
    @Default('') String searchQuery,
  }) = _ServersStateInitial;

  const factory ServersState.loaded({
    required List<PingedVpnConfiguration> servers,
    required List<PingedVpnConfiguration> filteredServers,
    required bool isLoading,
    required bool isSearchActive,
    @Default('') String searchQuery,
    @Default(true) bool pinned,
  }) = _ServersStateLoaded;
}
