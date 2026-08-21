import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/core/models/protocols.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    required ConnectionStatus connectionStatus,
    required Protocols protocol,
    VpnConfiguration? selectedServer,
    required bool launchOnStartup,
    required bool launchOnStartupFailed,

    /// Whether the user has manually pinned a country. False means the
    /// tunnel picks the best server across all countries ("Auto select") —
    /// the home screen should show a generic "Auto" placeholder instead of a
    /// specific country until a real exit is resolved after connecting.
    @Default(false) bool serverSelectionPinned,

    /// Whether the connected tunnel is verified to carry real traffic.
    /// null = not checked yet / not connected; false = tunnel up but every
    /// probe failed (exit server down) — UI shows a warning instead of a
    /// plain green Connected.
    bool? tunnelHealthy,
  }) = _AppState;

  factory AppState.initial() => const AppState(
        connectionStatus: ConnectionStatus.disconnected(),
        protocol: Protocols.auto,
        launchOnStartup: false,
        launchOnStartupFailed: false,
      );
}
