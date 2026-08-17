import 'package:freezed_annotation/freezed_annotation.dart';

part 'zenshield_vpn_config.freezed.dart';
part 'zenshield_vpn_config.g.dart';

@freezed
class ZenshieldConfig with _$ZenshieldConfig {
  const factory ZenshieldConfig({
    required String remoteDns,
    required Routes routes,
    required List<String> outboundsLinks,
    required String logLevel,
    required String logsPath,
    required String directDns,
    required String tunImplementation,
    required int urlTestInterval,
    required String clashApiToken,
    required int clashApiPort,
    required bool isMobile,
    SocksInbound? socksInbound,
  }) = _Config;

  factory ZenshieldConfig.fromJson(Map<String, dynamic> json) =>
      _$ZenshieldConfigFromJson(json);
}

@freezed
class Routes with _$Routes {
  const factory Routes({
    required List<String> direct,
    required List<String> block,
  }) = _Routes;

  factory Routes.fromJson(Map<String, dynamic> json) => _$RoutesFromJson(json);
}

@freezed
class SocksInbound with _$SocksInbound {
  const factory SocksInbound({
    required bool enabled,
    required String listen,
    required int port,
    required String tag,
    required bool direct,
  }) = _SocksInbound;

  factory SocksInbound.fromJson(Map<String, dynamic> json) =>
      _$SocksInboundFromJson(json);
}
