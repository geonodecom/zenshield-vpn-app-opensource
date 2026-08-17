// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'protocols_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProtocolsState {
  List<Protocol> get protocols => throw _privateConstructorUsedError;
  List<Protocol> get filteredProtocols => throw _privateConstructorUsedError;

  /// Create a copy of ProtocolsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProtocolsStateCopyWith<ProtocolsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProtocolsStateCopyWith<$Res> {
  factory $ProtocolsStateCopyWith(
    ProtocolsState value,
    $Res Function(ProtocolsState) then,
  ) = _$ProtocolsStateCopyWithImpl<$Res, ProtocolsState>;
  @useResult
  $Res call({List<Protocol> protocols, List<Protocol> filteredProtocols});
}

/// @nodoc
class _$ProtocolsStateCopyWithImpl<$Res, $Val extends ProtocolsState>
    implements $ProtocolsStateCopyWith<$Res> {
  _$ProtocolsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProtocolsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? protocols = null, Object? filteredProtocols = null}) {
    return _then(
      _value.copyWith(
            protocols: null == protocols
                ? _value.protocols
                : protocols // ignore: cast_nullable_to_non_nullable
                      as List<Protocol>,
            filteredProtocols: null == filteredProtocols
                ? _value.filteredProtocols
                : filteredProtocols // ignore: cast_nullable_to_non_nullable
                      as List<Protocol>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProtocolsStateImplCopyWith<$Res>
    implements $ProtocolsStateCopyWith<$Res> {
  factory _$$ProtocolsStateImplCopyWith(
    _$ProtocolsStateImpl value,
    $Res Function(_$ProtocolsStateImpl) then,
  ) = __$$ProtocolsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Protocol> protocols, List<Protocol> filteredProtocols});
}

/// @nodoc
class __$$ProtocolsStateImplCopyWithImpl<$Res>
    extends _$ProtocolsStateCopyWithImpl<$Res, _$ProtocolsStateImpl>
    implements _$$ProtocolsStateImplCopyWith<$Res> {
  __$$ProtocolsStateImplCopyWithImpl(
    _$ProtocolsStateImpl _value,
    $Res Function(_$ProtocolsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProtocolsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? protocols = null, Object? filteredProtocols = null}) {
    return _then(
      _$ProtocolsStateImpl(
        protocols: null == protocols
            ? _value._protocols
            : protocols // ignore: cast_nullable_to_non_nullable
                  as List<Protocol>,
        filteredProtocols: null == filteredProtocols
            ? _value._filteredProtocols
            : filteredProtocols // ignore: cast_nullable_to_non_nullable
                  as List<Protocol>,
      ),
    );
  }
}

/// @nodoc

class _$ProtocolsStateImpl implements _ProtocolsState {
  const _$ProtocolsStateImpl({
    required final List<Protocol> protocols,
    required final List<Protocol> filteredProtocols,
  }) : _protocols = protocols,
       _filteredProtocols = filteredProtocols;

  final List<Protocol> _protocols;
  @override
  List<Protocol> get protocols {
    if (_protocols is EqualUnmodifiableListView) return _protocols;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_protocols);
  }

  final List<Protocol> _filteredProtocols;
  @override
  List<Protocol> get filteredProtocols {
    if (_filteredProtocols is EqualUnmodifiableListView)
      return _filteredProtocols;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredProtocols);
  }

  @override
  String toString() {
    return 'ProtocolsState(protocols: $protocols, filteredProtocols: $filteredProtocols)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProtocolsStateImpl &&
            const DeepCollectionEquality().equals(
              other._protocols,
              _protocols,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredProtocols,
              _filteredProtocols,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_protocols),
    const DeepCollectionEquality().hash(_filteredProtocols),
  );

  /// Create a copy of ProtocolsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProtocolsStateImplCopyWith<_$ProtocolsStateImpl> get copyWith =>
      __$$ProtocolsStateImplCopyWithImpl<_$ProtocolsStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ProtocolsState implements ProtocolsState {
  const factory _ProtocolsState({
    required final List<Protocol> protocols,
    required final List<Protocol> filteredProtocols,
  }) = _$ProtocolsStateImpl;

  @override
  List<Protocol> get protocols;
  @override
  List<Protocol> get filteredProtocols;

  /// Create a copy of ProtocolsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProtocolsStateImplCopyWith<_$ProtocolsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
