import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_status.freezed.dart';

@freezed
sealed class ConnectionStatus with _$ConnectionStatus {
  const ConnectionStatus._();

  const factory ConnectionStatus.disconnected() = Disconnected;

  const factory ConnectionStatus.connecting() = Connecting;

  const factory ConnectionStatus.connected() = Connected;

  const factory ConnectionStatus.disconnecting() = Disconnecting;
}
