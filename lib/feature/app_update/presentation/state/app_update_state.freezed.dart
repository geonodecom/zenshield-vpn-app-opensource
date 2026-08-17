// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_update_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppUpdateState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function(bool isMandatory, String? version) confirm,
    required TResult Function(double progress) downloading,
    required TResult Function(double progress) installing,
    required TResult Function() restarting,
    required TResult Function(bool isMandatory, bool isInstallFailure) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function(bool isMandatory, String? version)? confirm,
    TResult? Function(double progress)? downloading,
    TResult? Function(double progress)? installing,
    TResult? Function()? restarting,
    TResult? Function(bool isMandatory, bool isInstallFailure)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function(bool isMandatory, String? version)? confirm,
    TResult Function(double progress)? downloading,
    TResult Function(double progress)? installing,
    TResult Function()? restarting,
    TResult Function(bool isMandatory, bool isInstallFailure)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Checking value) checking,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Installing value) installing,
    required TResult Function(_Restarting value) restarting,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Checking value)? checking,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Installing value)? installing,
    TResult? Function(_Restarting value)? restarting,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Checking value)? checking,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Installing value)? installing,
    TResult Function(_Restarting value)? restarting,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUpdateStateCopyWith<$Res> {
  factory $AppUpdateStateCopyWith(
    AppUpdateState value,
    $Res Function(AppUpdateState) then,
  ) = _$AppUpdateStateCopyWithImpl<$Res, AppUpdateState>;
}

/// @nodoc
class _$AppUpdateStateCopyWithImpl<$Res, $Val extends AppUpdateState>
    implements $AppUpdateStateCopyWith<$Res> {
  _$AppUpdateStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CheckingImplCopyWith<$Res> {
  factory _$$CheckingImplCopyWith(
    _$CheckingImpl value,
    $Res Function(_$CheckingImpl) then,
  ) = __$$CheckingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckingImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$CheckingImpl>
    implements _$$CheckingImplCopyWith<$Res> {
  __$$CheckingImplCopyWithImpl(
    _$CheckingImpl _value,
    $Res Function(_$CheckingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CheckingImpl implements _Checking {
  const _$CheckingImpl();

  @override
  String toString() {
    return 'AppUpdateState.checking()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function(bool isMandatory, String? version) confirm,
    required TResult Function(double progress) downloading,
    required TResult Function(double progress) installing,
    required TResult Function() restarting,
    required TResult Function(bool isMandatory, bool isInstallFailure) error,
  }) {
    return checking();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function(bool isMandatory, String? version)? confirm,
    TResult? Function(double progress)? downloading,
    TResult? Function(double progress)? installing,
    TResult? Function()? restarting,
    TResult? Function(bool isMandatory, bool isInstallFailure)? error,
  }) {
    return checking?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function(bool isMandatory, String? version)? confirm,
    TResult Function(double progress)? downloading,
    TResult Function(double progress)? installing,
    TResult Function()? restarting,
    TResult Function(bool isMandatory, bool isInstallFailure)? error,
    required TResult orElse(),
  }) {
    if (checking != null) {
      return checking();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Checking value) checking,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Installing value) installing,
    required TResult Function(_Restarting value) restarting,
    required TResult Function(_Error value) error,
  }) {
    return checking(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Checking value)? checking,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Installing value)? installing,
    TResult? Function(_Restarting value)? restarting,
    TResult? Function(_Error value)? error,
  }) {
    return checking?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Checking value)? checking,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Installing value)? installing,
    TResult Function(_Restarting value)? restarting,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (checking != null) {
      return checking(this);
    }
    return orElse();
  }
}

abstract class _Checking implements AppUpdateState {
  const factory _Checking() = _$CheckingImpl;
}

/// @nodoc
abstract class _$$ConfirmImplCopyWith<$Res> {
  factory _$$ConfirmImplCopyWith(
    _$ConfirmImpl value,
    $Res Function(_$ConfirmImpl) then,
  ) = __$$ConfirmImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isMandatory, String? version});
}

/// @nodoc
class __$$ConfirmImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$ConfirmImpl>
    implements _$$ConfirmImplCopyWith<$Res> {
  __$$ConfirmImplCopyWithImpl(
    _$ConfirmImpl _value,
    $Res Function(_$ConfirmImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isMandatory = null, Object? version = freezed}) {
    return _then(
      _$ConfirmImpl(
        isMandatory: null == isMandatory
            ? _value.isMandatory
            : isMandatory // ignore: cast_nullable_to_non_nullable
                  as bool,
        version: freezed == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ConfirmImpl implements _Confirm {
  const _$ConfirmImpl({required this.isMandatory, this.version});

  @override
  final bool isMandatory;
  @override
  final String? version;

  @override
  String toString() {
    return 'AppUpdateState.confirm(isMandatory: $isMandatory, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmImpl &&
            (identical(other.isMandatory, isMandatory) ||
                other.isMandatory == isMandatory) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isMandatory, version);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmImplCopyWith<_$ConfirmImpl> get copyWith =>
      __$$ConfirmImplCopyWithImpl<_$ConfirmImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function(bool isMandatory, String? version) confirm,
    required TResult Function(double progress) downloading,
    required TResult Function(double progress) installing,
    required TResult Function() restarting,
    required TResult Function(bool isMandatory, bool isInstallFailure) error,
  }) {
    return confirm(isMandatory, version);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function(bool isMandatory, String? version)? confirm,
    TResult? Function(double progress)? downloading,
    TResult? Function(double progress)? installing,
    TResult? Function()? restarting,
    TResult? Function(bool isMandatory, bool isInstallFailure)? error,
  }) {
    return confirm?.call(isMandatory, version);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function(bool isMandatory, String? version)? confirm,
    TResult Function(double progress)? downloading,
    TResult Function(double progress)? installing,
    TResult Function()? restarting,
    TResult Function(bool isMandatory, bool isInstallFailure)? error,
    required TResult orElse(),
  }) {
    if (confirm != null) {
      return confirm(isMandatory, version);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Checking value) checking,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Installing value) installing,
    required TResult Function(_Restarting value) restarting,
    required TResult Function(_Error value) error,
  }) {
    return confirm(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Checking value)? checking,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Installing value)? installing,
    TResult? Function(_Restarting value)? restarting,
    TResult? Function(_Error value)? error,
  }) {
    return confirm?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Checking value)? checking,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Installing value)? installing,
    TResult Function(_Restarting value)? restarting,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (confirm != null) {
      return confirm(this);
    }
    return orElse();
  }
}

abstract class _Confirm implements AppUpdateState {
  const factory _Confirm({
    required final bool isMandatory,
    final String? version,
  }) = _$ConfirmImpl;

  bool get isMandatory;
  String? get version;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmImplCopyWith<_$ConfirmImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DownloadingImplCopyWith<$Res> {
  factory _$$DownloadingImplCopyWith(
    _$DownloadingImpl value,
    $Res Function(_$DownloadingImpl) then,
  ) = __$$DownloadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double progress});
}

/// @nodoc
class __$$DownloadingImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$DownloadingImpl>
    implements _$$DownloadingImplCopyWith<$Res> {
  __$$DownloadingImplCopyWithImpl(
    _$DownloadingImpl _value,
    $Res Function(_$DownloadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? progress = null}) {
    return _then(
      _$DownloadingImpl(
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$DownloadingImpl implements _Downloading {
  const _$DownloadingImpl({required this.progress});

  @override
  final double progress;

  @override
  String toString() {
    return 'AppUpdateState.downloading(progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadingImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadingImplCopyWith<_$DownloadingImpl> get copyWith =>
      __$$DownloadingImplCopyWithImpl<_$DownloadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function(bool isMandatory, String? version) confirm,
    required TResult Function(double progress) downloading,
    required TResult Function(double progress) installing,
    required TResult Function() restarting,
    required TResult Function(bool isMandatory, bool isInstallFailure) error,
  }) {
    return downloading(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function(bool isMandatory, String? version)? confirm,
    TResult? Function(double progress)? downloading,
    TResult? Function(double progress)? installing,
    TResult? Function()? restarting,
    TResult? Function(bool isMandatory, bool isInstallFailure)? error,
  }) {
    return downloading?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function(bool isMandatory, String? version)? confirm,
    TResult Function(double progress)? downloading,
    TResult Function(double progress)? installing,
    TResult Function()? restarting,
    TResult Function(bool isMandatory, bool isInstallFailure)? error,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Checking value) checking,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Installing value) installing,
    required TResult Function(_Restarting value) restarting,
    required TResult Function(_Error value) error,
  }) {
    return downloading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Checking value)? checking,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Installing value)? installing,
    TResult? Function(_Restarting value)? restarting,
    TResult? Function(_Error value)? error,
  }) {
    return downloading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Checking value)? checking,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Installing value)? installing,
    TResult Function(_Restarting value)? restarting,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (downloading != null) {
      return downloading(this);
    }
    return orElse();
  }
}

abstract class _Downloading implements AppUpdateState {
  const factory _Downloading({required final double progress}) =
      _$DownloadingImpl;

  double get progress;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadingImplCopyWith<_$DownloadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InstallingImplCopyWith<$Res> {
  factory _$$InstallingImplCopyWith(
    _$InstallingImpl value,
    $Res Function(_$InstallingImpl) then,
  ) = __$$InstallingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double progress});
}

/// @nodoc
class __$$InstallingImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$InstallingImpl>
    implements _$$InstallingImplCopyWith<$Res> {
  __$$InstallingImplCopyWithImpl(
    _$InstallingImpl _value,
    $Res Function(_$InstallingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? progress = null}) {
    return _then(
      _$InstallingImpl(
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$InstallingImpl implements _Installing {
  const _$InstallingImpl({required this.progress});

  @override
  final double progress;

  @override
  String toString() {
    return 'AppUpdateState.installing(progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallingImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallingImplCopyWith<_$InstallingImpl> get copyWith =>
      __$$InstallingImplCopyWithImpl<_$InstallingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function(bool isMandatory, String? version) confirm,
    required TResult Function(double progress) downloading,
    required TResult Function(double progress) installing,
    required TResult Function() restarting,
    required TResult Function(bool isMandatory, bool isInstallFailure) error,
  }) {
    return installing(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function(bool isMandatory, String? version)? confirm,
    TResult? Function(double progress)? downloading,
    TResult? Function(double progress)? installing,
    TResult? Function()? restarting,
    TResult? Function(bool isMandatory, bool isInstallFailure)? error,
  }) {
    return installing?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function(bool isMandatory, String? version)? confirm,
    TResult Function(double progress)? downloading,
    TResult Function(double progress)? installing,
    TResult Function()? restarting,
    TResult Function(bool isMandatory, bool isInstallFailure)? error,
    required TResult orElse(),
  }) {
    if (installing != null) {
      return installing(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Checking value) checking,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Installing value) installing,
    required TResult Function(_Restarting value) restarting,
    required TResult Function(_Error value) error,
  }) {
    return installing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Checking value)? checking,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Installing value)? installing,
    TResult? Function(_Restarting value)? restarting,
    TResult? Function(_Error value)? error,
  }) {
    return installing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Checking value)? checking,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Installing value)? installing,
    TResult Function(_Restarting value)? restarting,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (installing != null) {
      return installing(this);
    }
    return orElse();
  }
}

abstract class _Installing implements AppUpdateState {
  const factory _Installing({required final double progress}) =
      _$InstallingImpl;

  double get progress;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstallingImplCopyWith<_$InstallingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RestartingImplCopyWith<$Res> {
  factory _$$RestartingImplCopyWith(
    _$RestartingImpl value,
    $Res Function(_$RestartingImpl) then,
  ) = __$$RestartingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RestartingImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$RestartingImpl>
    implements _$$RestartingImplCopyWith<$Res> {
  __$$RestartingImplCopyWithImpl(
    _$RestartingImpl _value,
    $Res Function(_$RestartingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RestartingImpl implements _Restarting {
  const _$RestartingImpl();

  @override
  String toString() {
    return 'AppUpdateState.restarting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RestartingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function(bool isMandatory, String? version) confirm,
    required TResult Function(double progress) downloading,
    required TResult Function(double progress) installing,
    required TResult Function() restarting,
    required TResult Function(bool isMandatory, bool isInstallFailure) error,
  }) {
    return restarting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function(bool isMandatory, String? version)? confirm,
    TResult? Function(double progress)? downloading,
    TResult? Function(double progress)? installing,
    TResult? Function()? restarting,
    TResult? Function(bool isMandatory, bool isInstallFailure)? error,
  }) {
    return restarting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function(bool isMandatory, String? version)? confirm,
    TResult Function(double progress)? downloading,
    TResult Function(double progress)? installing,
    TResult Function()? restarting,
    TResult Function(bool isMandatory, bool isInstallFailure)? error,
    required TResult orElse(),
  }) {
    if (restarting != null) {
      return restarting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Checking value) checking,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Installing value) installing,
    required TResult Function(_Restarting value) restarting,
    required TResult Function(_Error value) error,
  }) {
    return restarting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Checking value)? checking,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Installing value)? installing,
    TResult? Function(_Restarting value)? restarting,
    TResult? Function(_Error value)? error,
  }) {
    return restarting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Checking value)? checking,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Installing value)? installing,
    TResult Function(_Restarting value)? restarting,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (restarting != null) {
      return restarting(this);
    }
    return orElse();
  }
}

abstract class _Restarting implements AppUpdateState {
  const factory _Restarting() = _$RestartingImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isMandatory, bool isInstallFailure});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isMandatory = null, Object? isInstallFailure = null}) {
    return _then(
      _$ErrorImpl(
        isMandatory: null == isMandatory
            ? _value.isMandatory
            : isMandatory // ignore: cast_nullable_to_non_nullable
                  as bool,
        isInstallFailure: null == isInstallFailure
            ? _value.isInstallFailure
            : isInstallFailure // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({this.isMandatory = false, this.isInstallFailure = false});

  @override
  @JsonKey()
  final bool isMandatory;
  @override
  @JsonKey()
  final bool isInstallFailure;

  @override
  String toString() {
    return 'AppUpdateState.error(isMandatory: $isMandatory, isInstallFailure: $isInstallFailure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.isMandatory, isMandatory) ||
                other.isMandatory == isMandatory) &&
            (identical(other.isInstallFailure, isInstallFailure) ||
                other.isInstallFailure == isInstallFailure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isMandatory, isInstallFailure);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checking,
    required TResult Function(bool isMandatory, String? version) confirm,
    required TResult Function(double progress) downloading,
    required TResult Function(double progress) installing,
    required TResult Function() restarting,
    required TResult Function(bool isMandatory, bool isInstallFailure) error,
  }) {
    return error(isMandatory, isInstallFailure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checking,
    TResult? Function(bool isMandatory, String? version)? confirm,
    TResult? Function(double progress)? downloading,
    TResult? Function(double progress)? installing,
    TResult? Function()? restarting,
    TResult? Function(bool isMandatory, bool isInstallFailure)? error,
  }) {
    return error?.call(isMandatory, isInstallFailure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checking,
    TResult Function(bool isMandatory, String? version)? confirm,
    TResult Function(double progress)? downloading,
    TResult Function(double progress)? installing,
    TResult Function()? restarting,
    TResult Function(bool isMandatory, bool isInstallFailure)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(isMandatory, isInstallFailure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Checking value) checking,
    required TResult Function(_Confirm value) confirm,
    required TResult Function(_Downloading value) downloading,
    required TResult Function(_Installing value) installing,
    required TResult Function(_Restarting value) restarting,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Checking value)? checking,
    TResult? Function(_Confirm value)? confirm,
    TResult? Function(_Downloading value)? downloading,
    TResult? Function(_Installing value)? installing,
    TResult? Function(_Restarting value)? restarting,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Checking value)? checking,
    TResult Function(_Confirm value)? confirm,
    TResult Function(_Downloading value)? downloading,
    TResult Function(_Installing value)? installing,
    TResult Function(_Restarting value)? restarting,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements AppUpdateState {
  const factory _Error({final bool isMandatory, final bool isInstallFailure}) =
      _$ErrorImpl;

  bool get isMandatory;
  bool get isInstallFailure;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
