// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'protocol.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Protocol {
  Protocols get type => throw _privateConstructorUsedError;
  bool get isBest => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;

  /// Create a copy of Protocol
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProtocolCopyWith<Protocol> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProtocolCopyWith<$Res> {
  factory $ProtocolCopyWith(Protocol value, $Res Function(Protocol) then) =
      _$ProtocolCopyWithImpl<$Res, Protocol>;
  @useResult
  $Res call({Protocols type, bool isBest, bool isSelected, bool isAvailable});
}

/// @nodoc
class _$ProtocolCopyWithImpl<$Res, $Val extends Protocol>
    implements $ProtocolCopyWith<$Res> {
  _$ProtocolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Protocol
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isBest = null,
    Object? isSelected = null,
    Object? isAvailable = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as Protocols,
            isBest: null == isBest
                ? _value.isBest
                : isBest // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSelected: null == isSelected
                ? _value.isSelected
                : isSelected // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProtocolImplCopyWith<$Res>
    implements $ProtocolCopyWith<$Res> {
  factory _$$ProtocolImplCopyWith(
    _$ProtocolImpl value,
    $Res Function(_$ProtocolImpl) then,
  ) = __$$ProtocolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Protocols type, bool isBest, bool isSelected, bool isAvailable});
}

/// @nodoc
class __$$ProtocolImplCopyWithImpl<$Res>
    extends _$ProtocolCopyWithImpl<$Res, _$ProtocolImpl>
    implements _$$ProtocolImplCopyWith<$Res> {
  __$$ProtocolImplCopyWithImpl(
    _$ProtocolImpl _value,
    $Res Function(_$ProtocolImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Protocol
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isBest = null,
    Object? isSelected = null,
    Object? isAvailable = null,
  }) {
    return _then(
      _$ProtocolImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as Protocols,
        isBest: null == isBest
            ? _value.isBest
            : isBest // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSelected: null == isSelected
            ? _value.isSelected
            : isSelected // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ProtocolImpl implements _Protocol {
  const _$ProtocolImpl({
    required this.type,
    required this.isBest,
    required this.isSelected,
    required this.isAvailable,
  });

  @override
  final Protocols type;
  @override
  final bool isBest;
  @override
  final bool isSelected;
  @override
  final bool isAvailable;

  @override
  String toString() {
    return 'Protocol(type: $type, isBest: $isBest, isSelected: $isSelected, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProtocolImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isBest, isBest) || other.isBest == isBest) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, type, isBest, isSelected, isAvailable);

  /// Create a copy of Protocol
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProtocolImplCopyWith<_$ProtocolImpl> get copyWith =>
      __$$ProtocolImplCopyWithImpl<_$ProtocolImpl>(this, _$identity);
}

abstract class _Protocol implements Protocol {
  const factory _Protocol({
    required final Protocols type,
    required final bool isBest,
    required final bool isSelected,
    required final bool isAvailable,
  }) = _$ProtocolImpl;

  @override
  Protocols get type;
  @override
  bool get isBest;
  @override
  bool get isSelected;
  @override
  bool get isAvailable;

  /// Create a copy of Protocol
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProtocolImplCopyWith<_$ProtocolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
