// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paywall_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PaywallArgs {
  bool get redirectToHomeOnClose => throw _privateConstructorUsedError;

  /// Create a copy of PaywallArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaywallArgsCopyWith<PaywallArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaywallArgsCopyWith<$Res> {
  factory $PaywallArgsCopyWith(
    PaywallArgs value,
    $Res Function(PaywallArgs) then,
  ) = _$PaywallArgsCopyWithImpl<$Res, PaywallArgs>;
  @useResult
  $Res call({bool redirectToHomeOnClose});
}

/// @nodoc
class _$PaywallArgsCopyWithImpl<$Res, $Val extends PaywallArgs>
    implements $PaywallArgsCopyWith<$Res> {
  _$PaywallArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaywallArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? redirectToHomeOnClose = null}) {
    return _then(
      _value.copyWith(
            redirectToHomeOnClose: null == redirectToHomeOnClose
                ? _value.redirectToHomeOnClose
                : redirectToHomeOnClose // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaywallArgsImplCopyWith<$Res>
    implements $PaywallArgsCopyWith<$Res> {
  factory _$$PaywallArgsImplCopyWith(
    _$PaywallArgsImpl value,
    $Res Function(_$PaywallArgsImpl) then,
  ) = __$$PaywallArgsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool redirectToHomeOnClose});
}

/// @nodoc
class __$$PaywallArgsImplCopyWithImpl<$Res>
    extends _$PaywallArgsCopyWithImpl<$Res, _$PaywallArgsImpl>
    implements _$$PaywallArgsImplCopyWith<$Res> {
  __$$PaywallArgsImplCopyWithImpl(
    _$PaywallArgsImpl _value,
    $Res Function(_$PaywallArgsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaywallArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? redirectToHomeOnClose = null}) {
    return _then(
      _$PaywallArgsImpl(
        redirectToHomeOnClose: null == redirectToHomeOnClose
            ? _value.redirectToHomeOnClose
            : redirectToHomeOnClose // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PaywallArgsImpl implements _PaywallArgs {
  const _$PaywallArgsImpl({required this.redirectToHomeOnClose});

  @override
  final bool redirectToHomeOnClose;

  @override
  String toString() {
    return 'PaywallArgs(redirectToHomeOnClose: $redirectToHomeOnClose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaywallArgsImpl &&
            (identical(other.redirectToHomeOnClose, redirectToHomeOnClose) ||
                other.redirectToHomeOnClose == redirectToHomeOnClose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, redirectToHomeOnClose);

  /// Create a copy of PaywallArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaywallArgsImplCopyWith<_$PaywallArgsImpl> get copyWith =>
      __$$PaywallArgsImplCopyWithImpl<_$PaywallArgsImpl>(this, _$identity);
}

abstract class _PaywallArgs implements PaywallArgs {
  const factory _PaywallArgs({required final bool redirectToHomeOnClose}) =
      _$PaywallArgsImpl;

  @override
  bool get redirectToHomeOnClose;

  /// Create a copy of PaywallArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaywallArgsImplCopyWith<_$PaywallArgsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
