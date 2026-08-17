// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatusMessageImpl _$$StatusMessageImplFromJson(Map<String, dynamic> json) =>
    _$StatusMessageImpl(
      memory: (json['memory'] as num).toInt(),
      goroutines: (json['goroutines'] as num).toInt(),
      connectionsIn: (json['connections_in'] as num).toInt(),
      connectionsOut: (json['connections_out'] as num).toInt(),
      trafficAvailable: json['traffic_available'] as bool,
      uplink: (json['uplink'] as num).toInt(),
      downlink: (json['downlink'] as num).toInt(),
      uplinkTotal: (json['uplink_total'] as num).toInt(),
      downlinkTotal: (json['downlink_total'] as num).toInt(),
    );

Map<String, dynamic> _$$StatusMessageImplToJson(_$StatusMessageImpl instance) =>
    <String, dynamic>{
      'memory': instance.memory,
      'goroutines': instance.goroutines,
      'connections_in': instance.connectionsIn,
      'connections_out': instance.connectionsOut,
      'traffic_available': instance.trafficAvailable,
      'uplink': instance.uplink,
      'downlink': instance.downlink,
      'uplink_total': instance.uplinkTotal,
      'downlink_total': instance.downlinkTotal,
    };
