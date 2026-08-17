import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/protocols/data/model/protocol/protocol.dart';
import 'package:zenshield/core/models/protocols.dart';

part 'protocols_state.freezed.dart';

@freezed
class ProtocolsState with _$ProtocolsState {
  const factory ProtocolsState({
    required List<Protocol> protocols,
    required List<Protocol> filteredProtocols,
  }) = _ProtocolsState;

  factory ProtocolsState.initial() {
    final protocols = [
      Protocol(
        type: Protocols.auto,
        isBest: true,
        isSelected: false,
        isAvailable: true,
      ),
      Protocol(
        type: Protocols.vless,
        isBest: false,
        isSelected: false,
        isAvailable: true,
      ),
      Protocol(
        type: Protocols.vmess,
        isBest: false,
        isSelected: false,
        isAvailable: true,
      ),
      Protocol(
        type: Protocols.trojan,
        isBest: false,
        isSelected: false,
        isAvailable: true,
      ),
      Protocol(
        type: Protocols.shadowsocks,
        isBest: false,
        isSelected: false,
        isAvailable: true,
      ),
      Protocol(
        type: Protocols.wireguard,
        isBest: false,
        isSelected: false,
        isAvailable: false,
      ),
    ];
    return ProtocolsState(
      protocols: protocols,
      filteredProtocols: protocols,
    );
  }
}
