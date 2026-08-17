// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_message.freezed.dart';
part 'status_message.g.dart';

@freezed
class StatusMessage with _$StatusMessage {
  const factory StatusMessage({
    required int memory,
    required int goroutines,
    @JsonKey(name: 'connections_in') required int connectionsIn,
    @JsonKey(name: 'connections_out') required int connectionsOut,
    @JsonKey(name: 'traffic_available') required bool trafficAvailable,
    required int uplink,
    required int downlink,
    @JsonKey(name: 'uplink_total') required int uplinkTotal,
    @JsonKey(name: 'downlink_total') required int downlinkTotal,
  }) = _StatusMessage;

  factory StatusMessage.fromJson(Map<String, dynamic> json) =>
      _$StatusMessageFromJson(json);
}
