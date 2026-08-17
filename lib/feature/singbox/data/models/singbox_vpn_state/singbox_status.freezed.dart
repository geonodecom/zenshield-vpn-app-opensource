// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'singbox_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SingboxStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() starting,
    required TResult Function() started,
    required TResult Function() stopping,
    required TResult Function() stopped,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? starting,
    TResult? Function()? started,
    TResult? Function()? stopping,
    TResult? Function()? stopped,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? starting,
    TResult Function()? started,
    TResult Function()? stopping,
    TResult Function()? stopped,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SingboxStarting value) starting,
    required TResult Function(SingboxStarted value) started,
    required TResult Function(SingboxStopping value) stopping,
    required TResult Function(SingboxStopped value) stopped,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SingboxStarting value)? starting,
    TResult? Function(SingboxStarted value)? started,
    TResult? Function(SingboxStopping value)? stopping,
    TResult? Function(SingboxStopped value)? stopped,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SingboxStarting value)? starting,
    TResult Function(SingboxStarted value)? started,
    TResult Function(SingboxStopping value)? stopping,
    TResult Function(SingboxStopped value)? stopped,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SingboxStatusCopyWith<$Res> {
  factory $SingboxStatusCopyWith(
    SingboxStatus value,
    $Res Function(SingboxStatus) then,
  ) = _$SingboxStatusCopyWithImpl<$Res, SingboxStatus>;
}

/// @nodoc
class _$SingboxStatusCopyWithImpl<$Res, $Val extends SingboxStatus>
    implements $SingboxStatusCopyWith<$Res> {
  _$SingboxStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SingboxStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SingboxStartingImplCopyWith<$Res> {
  factory _$$SingboxStartingImplCopyWith(
    _$SingboxStartingImpl value,
    $Res Function(_$SingboxStartingImpl) then,
  ) = __$$SingboxStartingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SingboxStartingImplCopyWithImpl<$Res>
    extends _$SingboxStatusCopyWithImpl<$Res, _$SingboxStartingImpl>
    implements _$$SingboxStartingImplCopyWith<$Res> {
  __$$SingboxStartingImplCopyWithImpl(
    _$SingboxStartingImpl _value,
    $Res Function(_$SingboxStartingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SingboxStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SingboxStartingImpl extends SingboxStarting {
  const _$SingboxStartingImpl() : super._();

  @override
  String toString() {
    return 'SingboxStatus.starting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SingboxStartingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() starting,
    required TResult Function() started,
    required TResult Function() stopping,
    required TResult Function() stopped,
  }) {
    return starting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? starting,
    TResult? Function()? started,
    TResult? Function()? stopping,
    TResult? Function()? stopped,
  }) {
    return starting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? starting,
    TResult Function()? started,
    TResult Function()? stopping,
    TResult Function()? stopped,
    required TResult orElse(),
  }) {
    if (starting != null) {
      return starting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SingboxStarting value) starting,
    required TResult Function(SingboxStarted value) started,
    required TResult Function(SingboxStopping value) stopping,
    required TResult Function(SingboxStopped value) stopped,
  }) {
    return starting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SingboxStarting value)? starting,
    TResult? Function(SingboxStarted value)? started,
    TResult? Function(SingboxStopping value)? stopping,
    TResult? Function(SingboxStopped value)? stopped,
  }) {
    return starting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SingboxStarting value)? starting,
    TResult Function(SingboxStarted value)? started,
    TResult Function(SingboxStopping value)? stopping,
    TResult Function(SingboxStopped value)? stopped,
    required TResult orElse(),
  }) {
    if (starting != null) {
      return starting(this);
    }
    return orElse();
  }
}

abstract class SingboxStarting extends SingboxStatus {
  const factory SingboxStarting() = _$SingboxStartingImpl;
  const SingboxStarting._() : super._();
}

/// @nodoc
abstract class _$$SingboxStartedImplCopyWith<$Res> {
  factory _$$SingboxStartedImplCopyWith(
    _$SingboxStartedImpl value,
    $Res Function(_$SingboxStartedImpl) then,
  ) = __$$SingboxStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SingboxStartedImplCopyWithImpl<$Res>
    extends _$SingboxStatusCopyWithImpl<$Res, _$SingboxStartedImpl>
    implements _$$SingboxStartedImplCopyWith<$Res> {
  __$$SingboxStartedImplCopyWithImpl(
    _$SingboxStartedImpl _value,
    $Res Function(_$SingboxStartedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SingboxStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SingboxStartedImpl extends SingboxStarted {
  const _$SingboxStartedImpl() : super._();

  @override
  String toString() {
    return 'SingboxStatus.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SingboxStartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() starting,
    required TResult Function() started,
    required TResult Function() stopping,
    required TResult Function() stopped,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? starting,
    TResult? Function()? started,
    TResult? Function()? stopping,
    TResult? Function()? stopped,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? starting,
    TResult Function()? started,
    TResult Function()? stopping,
    TResult Function()? stopped,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SingboxStarting value) starting,
    required TResult Function(SingboxStarted value) started,
    required TResult Function(SingboxStopping value) stopping,
    required TResult Function(SingboxStopped value) stopped,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SingboxStarting value)? starting,
    TResult? Function(SingboxStarted value)? started,
    TResult? Function(SingboxStopping value)? stopping,
    TResult? Function(SingboxStopped value)? stopped,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SingboxStarting value)? starting,
    TResult Function(SingboxStarted value)? started,
    TResult Function(SingboxStopping value)? stopping,
    TResult Function(SingboxStopped value)? stopped,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class SingboxStarted extends SingboxStatus {
  const factory SingboxStarted() = _$SingboxStartedImpl;
  const SingboxStarted._() : super._();
}

/// @nodoc
abstract class _$$SingboxStoppingImplCopyWith<$Res> {
  factory _$$SingboxStoppingImplCopyWith(
    _$SingboxStoppingImpl value,
    $Res Function(_$SingboxStoppingImpl) then,
  ) = __$$SingboxStoppingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SingboxStoppingImplCopyWithImpl<$Res>
    extends _$SingboxStatusCopyWithImpl<$Res, _$SingboxStoppingImpl>
    implements _$$SingboxStoppingImplCopyWith<$Res> {
  __$$SingboxStoppingImplCopyWithImpl(
    _$SingboxStoppingImpl _value,
    $Res Function(_$SingboxStoppingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SingboxStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SingboxStoppingImpl extends SingboxStopping {
  const _$SingboxStoppingImpl() : super._();

  @override
  String toString() {
    return 'SingboxStatus.stopping()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SingboxStoppingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() starting,
    required TResult Function() started,
    required TResult Function() stopping,
    required TResult Function() stopped,
  }) {
    return stopping();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? starting,
    TResult? Function()? started,
    TResult? Function()? stopping,
    TResult? Function()? stopped,
  }) {
    return stopping?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? starting,
    TResult Function()? started,
    TResult Function()? stopping,
    TResult Function()? stopped,
    required TResult orElse(),
  }) {
    if (stopping != null) {
      return stopping();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SingboxStarting value) starting,
    required TResult Function(SingboxStarted value) started,
    required TResult Function(SingboxStopping value) stopping,
    required TResult Function(SingboxStopped value) stopped,
  }) {
    return stopping(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SingboxStarting value)? starting,
    TResult? Function(SingboxStarted value)? started,
    TResult? Function(SingboxStopping value)? stopping,
    TResult? Function(SingboxStopped value)? stopped,
  }) {
    return stopping?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SingboxStarting value)? starting,
    TResult Function(SingboxStarted value)? started,
    TResult Function(SingboxStopping value)? stopping,
    TResult Function(SingboxStopped value)? stopped,
    required TResult orElse(),
  }) {
    if (stopping != null) {
      return stopping(this);
    }
    return orElse();
  }
}

abstract class SingboxStopping extends SingboxStatus {
  const factory SingboxStopping() = _$SingboxStoppingImpl;
  const SingboxStopping._() : super._();
}

/// @nodoc
abstract class _$$SingboxStoppedImplCopyWith<$Res> {
  factory _$$SingboxStoppedImplCopyWith(
    _$SingboxStoppedImpl value,
    $Res Function(_$SingboxStoppedImpl) then,
  ) = __$$SingboxStoppedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SingboxStoppedImplCopyWithImpl<$Res>
    extends _$SingboxStatusCopyWithImpl<$Res, _$SingboxStoppedImpl>
    implements _$$SingboxStoppedImplCopyWith<$Res> {
  __$$SingboxStoppedImplCopyWithImpl(
    _$SingboxStoppedImpl _value,
    $Res Function(_$SingboxStoppedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SingboxStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SingboxStoppedImpl extends SingboxStopped {
  const _$SingboxStoppedImpl() : super._();

  @override
  String toString() {
    return 'SingboxStatus.stopped()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SingboxStoppedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() starting,
    required TResult Function() started,
    required TResult Function() stopping,
    required TResult Function() stopped,
  }) {
    return stopped();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? starting,
    TResult? Function()? started,
    TResult? Function()? stopping,
    TResult? Function()? stopped,
  }) {
    return stopped?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? starting,
    TResult Function()? started,
    TResult Function()? stopping,
    TResult Function()? stopped,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SingboxStarting value) starting,
    required TResult Function(SingboxStarted value) started,
    required TResult Function(SingboxStopping value) stopping,
    required TResult Function(SingboxStopped value) stopped,
  }) {
    return stopped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SingboxStarting value)? starting,
    TResult? Function(SingboxStarted value)? started,
    TResult? Function(SingboxStopping value)? stopping,
    TResult? Function(SingboxStopped value)? stopped,
  }) {
    return stopped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SingboxStarting value)? starting,
    TResult Function(SingboxStarted value)? started,
    TResult Function(SingboxStopping value)? stopping,
    TResult Function(SingboxStopped value)? stopped,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped(this);
    }
    return orElse();
  }
}

abstract class SingboxStopped extends SingboxStatus {
  const factory SingboxStopped() = _$SingboxStoppedImpl;
  const SingboxStopped._() : super._();
}
