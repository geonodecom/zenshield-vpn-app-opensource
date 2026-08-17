// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StatusMessage _$StatusMessageFromJson(Map<String, dynamic> json) {
  return _StatusMessage.fromJson(json);
}

/// @nodoc
mixin _$StatusMessage {
  int get memory => throw _privateConstructorUsedError;
  int get goroutines => throw _privateConstructorUsedError;
  @JsonKey(name: 'connections_in')
  int get connectionsIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'connections_out')
  int get connectionsOut => throw _privateConstructorUsedError;
  @JsonKey(name: 'traffic_available')
  bool get trafficAvailable => throw _privateConstructorUsedError;
  int get uplink => throw _privateConstructorUsedError;
  int get downlink => throw _privateConstructorUsedError;
  @JsonKey(name: 'uplink_total')
  int get uplinkTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'downlink_total')
  int get downlinkTotal => throw _privateConstructorUsedError;

  /// Serializes this StatusMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusMessageCopyWith<StatusMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusMessageCopyWith<$Res> {
  factory $StatusMessageCopyWith(
    StatusMessage value,
    $Res Function(StatusMessage) then,
  ) = _$StatusMessageCopyWithImpl<$Res, StatusMessage>;
  @useResult
  $Res call({
    int memory,
    int goroutines,
    @JsonKey(name: 'connections_in') int connectionsIn,
    @JsonKey(name: 'connections_out') int connectionsOut,
    @JsonKey(name: 'traffic_available') bool trafficAvailable,
    int uplink,
    int downlink,
    @JsonKey(name: 'uplink_total') int uplinkTotal,
    @JsonKey(name: 'downlink_total') int downlinkTotal,
  });
}

/// @nodoc
class _$StatusMessageCopyWithImpl<$Res, $Val extends StatusMessage>
    implements $StatusMessageCopyWith<$Res> {
  _$StatusMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memory = null,
    Object? goroutines = null,
    Object? connectionsIn = null,
    Object? connectionsOut = null,
    Object? trafficAvailable = null,
    Object? uplink = null,
    Object? downlink = null,
    Object? uplinkTotal = null,
    Object? downlinkTotal = null,
  }) {
    return _then(
      _value.copyWith(
            memory: null == memory
                ? _value.memory
                : memory // ignore: cast_nullable_to_non_nullable
                      as int,
            goroutines: null == goroutines
                ? _value.goroutines
                : goroutines // ignore: cast_nullable_to_non_nullable
                      as int,
            connectionsIn: null == connectionsIn
                ? _value.connectionsIn
                : connectionsIn // ignore: cast_nullable_to_non_nullable
                      as int,
            connectionsOut: null == connectionsOut
                ? _value.connectionsOut
                : connectionsOut // ignore: cast_nullable_to_non_nullable
                      as int,
            trafficAvailable: null == trafficAvailable
                ? _value.trafficAvailable
                : trafficAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            uplink: null == uplink
                ? _value.uplink
                : uplink // ignore: cast_nullable_to_non_nullable
                      as int,
            downlink: null == downlink
                ? _value.downlink
                : downlink // ignore: cast_nullable_to_non_nullable
                      as int,
            uplinkTotal: null == uplinkTotal
                ? _value.uplinkTotal
                : uplinkTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            downlinkTotal: null == downlinkTotal
                ? _value.downlinkTotal
                : downlinkTotal // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatusMessageImplCopyWith<$Res>
    implements $StatusMessageCopyWith<$Res> {
  factory _$$StatusMessageImplCopyWith(
    _$StatusMessageImpl value,
    $Res Function(_$StatusMessageImpl) then,
  ) = __$$StatusMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int memory,
    int goroutines,
    @JsonKey(name: 'connections_in') int connectionsIn,
    @JsonKey(name: 'connections_out') int connectionsOut,
    @JsonKey(name: 'traffic_available') bool trafficAvailable,
    int uplink,
    int downlink,
    @JsonKey(name: 'uplink_total') int uplinkTotal,
    @JsonKey(name: 'downlink_total') int downlinkTotal,
  });
}

/// @nodoc
class __$$StatusMessageImplCopyWithImpl<$Res>
    extends _$StatusMessageCopyWithImpl<$Res, _$StatusMessageImpl>
    implements _$$StatusMessageImplCopyWith<$Res> {
  __$$StatusMessageImplCopyWithImpl(
    _$StatusMessageImpl _value,
    $Res Function(_$StatusMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatusMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memory = null,
    Object? goroutines = null,
    Object? connectionsIn = null,
    Object? connectionsOut = null,
    Object? trafficAvailable = null,
    Object? uplink = null,
    Object? downlink = null,
    Object? uplinkTotal = null,
    Object? downlinkTotal = null,
  }) {
    return _then(
      _$StatusMessageImpl(
        memory: null == memory
            ? _value.memory
            : memory // ignore: cast_nullable_to_non_nullable
                  as int,
        goroutines: null == goroutines
            ? _value.goroutines
            : goroutines // ignore: cast_nullable_to_non_nullable
                  as int,
        connectionsIn: null == connectionsIn
            ? _value.connectionsIn
            : connectionsIn // ignore: cast_nullable_to_non_nullable
                  as int,
        connectionsOut: null == connectionsOut
            ? _value.connectionsOut
            : connectionsOut // ignore: cast_nullable_to_non_nullable
                  as int,
        trafficAvailable: null == trafficAvailable
            ? _value.trafficAvailable
            : trafficAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        uplink: null == uplink
            ? _value.uplink
            : uplink // ignore: cast_nullable_to_non_nullable
                  as int,
        downlink: null == downlink
            ? _value.downlink
            : downlink // ignore: cast_nullable_to_non_nullable
                  as int,
        uplinkTotal: null == uplinkTotal
            ? _value.uplinkTotal
            : uplinkTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        downlinkTotal: null == downlinkTotal
            ? _value.downlinkTotal
            : downlinkTotal // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusMessageImpl implements _StatusMessage {
  const _$StatusMessageImpl({
    required this.memory,
    required this.goroutines,
    @JsonKey(name: 'connections_in') required this.connectionsIn,
    @JsonKey(name: 'connections_out') required this.connectionsOut,
    @JsonKey(name: 'traffic_available') required this.trafficAvailable,
    required this.uplink,
    required this.downlink,
    @JsonKey(name: 'uplink_total') required this.uplinkTotal,
    @JsonKey(name: 'downlink_total') required this.downlinkTotal,
  });

  factory _$StatusMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusMessageImplFromJson(json);

  @override
  final int memory;
  @override
  final int goroutines;
  @override
  @JsonKey(name: 'connections_in')
  final int connectionsIn;
  @override
  @JsonKey(name: 'connections_out')
  final int connectionsOut;
  @override
  @JsonKey(name: 'traffic_available')
  final bool trafficAvailable;
  @override
  final int uplink;
  @override
  final int downlink;
  @override
  @JsonKey(name: 'uplink_total')
  final int uplinkTotal;
  @override
  @JsonKey(name: 'downlink_total')
  final int downlinkTotal;

  @override
  String toString() {
    return 'StatusMessage(memory: $memory, goroutines: $goroutines, connectionsIn: $connectionsIn, connectionsOut: $connectionsOut, trafficAvailable: $trafficAvailable, uplink: $uplink, downlink: $downlink, uplinkTotal: $uplinkTotal, downlinkTotal: $downlinkTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusMessageImpl &&
            (identical(other.memory, memory) || other.memory == memory) &&
            (identical(other.goroutines, goroutines) ||
                other.goroutines == goroutines) &&
            (identical(other.connectionsIn, connectionsIn) ||
                other.connectionsIn == connectionsIn) &&
            (identical(other.connectionsOut, connectionsOut) ||
                other.connectionsOut == connectionsOut) &&
            (identical(other.trafficAvailable, trafficAvailable) ||
                other.trafficAvailable == trafficAvailable) &&
            (identical(other.uplink, uplink) || other.uplink == uplink) &&
            (identical(other.downlink, downlink) ||
                other.downlink == downlink) &&
            (identical(other.uplinkTotal, uplinkTotal) ||
                other.uplinkTotal == uplinkTotal) &&
            (identical(other.downlinkTotal, downlinkTotal) ||
                other.downlinkTotal == downlinkTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    memory,
    goroutines,
    connectionsIn,
    connectionsOut,
    trafficAvailable,
    uplink,
    downlink,
    uplinkTotal,
    downlinkTotal,
  );

  /// Create a copy of StatusMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusMessageImplCopyWith<_$StatusMessageImpl> get copyWith =>
      __$$StatusMessageImplCopyWithImpl<_$StatusMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusMessageImplToJson(this);
  }
}

abstract class _StatusMessage implements StatusMessage {
  const factory _StatusMessage({
    required final int memory,
    required final int goroutines,
    @JsonKey(name: 'connections_in') required final int connectionsIn,
    @JsonKey(name: 'connections_out') required final int connectionsOut,
    @JsonKey(name: 'traffic_available') required final bool trafficAvailable,
    required final int uplink,
    required final int downlink,
    @JsonKey(name: 'uplink_total') required final int uplinkTotal,
    @JsonKey(name: 'downlink_total') required final int downlinkTotal,
  }) = _$StatusMessageImpl;

  factory _StatusMessage.fromJson(Map<String, dynamic> json) =
      _$StatusMessageImpl.fromJson;

  @override
  int get memory;
  @override
  int get goroutines;
  @override
  @JsonKey(name: 'connections_in')
  int get connectionsIn;
  @override
  @JsonKey(name: 'connections_out')
  int get connectionsOut;
  @override
  @JsonKey(name: 'traffic_available')
  bool get trafficAvailable;
  @override
  int get uplink;
  @override
  int get downlink;
  @override
  @JsonKey(name: 'uplink_total')
  int get uplinkTotal;
  @override
  @JsonKey(name: 'downlink_total')
  int get downlinkTotal;

  /// Create a copy of StatusMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusMessageImplCopyWith<_$StatusMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
