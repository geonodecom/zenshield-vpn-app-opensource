// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppState {
  ConnectionStatus get connectionStatus => throw _privateConstructorUsedError;
  Protocols get protocol => throw _privateConstructorUsedError;
  VpnConfiguration? get selectedServer => throw _privateConstructorUsedError;
  bool get zenSdkEnabled => throw _privateConstructorUsedError;
  bool get launchOnStartup => throw _privateConstructorUsedError;
  bool get launchOnStartupFailed => throw _privateConstructorUsedError;
  bool? get needsUpdate => throw _privateConstructorUsedError;

  /// Whether the user has manually pinned a country. False means the
  /// tunnel picks the best server across all countries ("Auto select") —
  /// the home screen should show a generic "Auto" placeholder instead of a
  /// specific country until a real exit is resolved after connecting.
  bool get serverSelectionPinned => throw _privateConstructorUsedError;

  /// Whether the connected tunnel is verified to carry real traffic.
  /// null = not checked yet / not connected; false = tunnel up but every
  /// probe failed (exit server down) — UI shows a warning instead of a
  /// plain green Connected.
  bool? get tunnelHealthy => throw _privateConstructorUsedError;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppStateCopyWith<AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res, AppState>;
  @useResult
  $Res call({
    ConnectionStatus connectionStatus,
    Protocols protocol,
    VpnConfiguration? selectedServer,
    bool zenSdkEnabled,
    bool launchOnStartup,
    bool launchOnStartupFailed,
    bool? needsUpdate,
    bool serverSelectionPinned,
    bool? tunnelHealthy,
  });

  $ConnectionStatusCopyWith<$Res> get connectionStatus;
  $VpnConfigurationCopyWith<$Res>? get selectedServer;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res, $Val extends AppState>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionStatus = null,
    Object? protocol = null,
    Object? selectedServer = freezed,
    Object? zenSdkEnabled = null,
    Object? launchOnStartup = null,
    Object? launchOnStartupFailed = null,
    Object? needsUpdate = freezed,
    Object? serverSelectionPinned = null,
    Object? tunnelHealthy = freezed,
  }) {
    return _then(
      _value.copyWith(
            connectionStatus: null == connectionStatus
                ? _value.connectionStatus
                : connectionStatus // ignore: cast_nullable_to_non_nullable
                      as ConnectionStatus,
            protocol: null == protocol
                ? _value.protocol
                : protocol // ignore: cast_nullable_to_non_nullable
                      as Protocols,
            selectedServer: freezed == selectedServer
                ? _value.selectedServer
                : selectedServer // ignore: cast_nullable_to_non_nullable
                      as VpnConfiguration?,
            zenSdkEnabled: null == zenSdkEnabled
                ? _value.zenSdkEnabled
                : zenSdkEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            launchOnStartup: null == launchOnStartup
                ? _value.launchOnStartup
                : launchOnStartup // ignore: cast_nullable_to_non_nullable
                      as bool,
            launchOnStartupFailed: null == launchOnStartupFailed
                ? _value.launchOnStartupFailed
                : launchOnStartupFailed // ignore: cast_nullable_to_non_nullable
                      as bool,
            needsUpdate: freezed == needsUpdate
                ? _value.needsUpdate
                : needsUpdate // ignore: cast_nullable_to_non_nullable
                      as bool?,
            serverSelectionPinned: null == serverSelectionPinned
                ? _value.serverSelectionPinned
                : serverSelectionPinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            tunnelHealthy: freezed == tunnelHealthy
                ? _value.tunnelHealthy
                : tunnelHealthy // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConnectionStatusCopyWith<$Res> get connectionStatus {
    return $ConnectionStatusCopyWith<$Res>(_value.connectionStatus, (value) {
      return _then(_value.copyWith(connectionStatus: value) as $Val);
    });
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VpnConfigurationCopyWith<$Res>? get selectedServer {
    if (_value.selectedServer == null) {
      return null;
    }

    return $VpnConfigurationCopyWith<$Res>(_value.selectedServer!, (value) {
      return _then(_value.copyWith(selectedServer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppStateImplCopyWith<$Res>
    implements $AppStateCopyWith<$Res> {
  factory _$$AppStateImplCopyWith(
    _$AppStateImpl value,
    $Res Function(_$AppStateImpl) then,
  ) = __$$AppStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ConnectionStatus connectionStatus,
    Protocols protocol,
    VpnConfiguration? selectedServer,
    bool zenSdkEnabled,
    bool launchOnStartup,
    bool launchOnStartupFailed,
    bool? needsUpdate,
    bool serverSelectionPinned,
    bool? tunnelHealthy,
  });

  @override
  $ConnectionStatusCopyWith<$Res> get connectionStatus;
  @override
  $VpnConfigurationCopyWith<$Res>? get selectedServer;
}

/// @nodoc
class __$$AppStateImplCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateImpl>
    implements _$$AppStateImplCopyWith<$Res> {
  __$$AppStateImplCopyWithImpl(
    _$AppStateImpl _value,
    $Res Function(_$AppStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionStatus = null,
    Object? protocol = null,
    Object? selectedServer = freezed,
    Object? zenSdkEnabled = null,
    Object? launchOnStartup = null,
    Object? launchOnStartupFailed = null,
    Object? needsUpdate = freezed,
    Object? serverSelectionPinned = null,
    Object? tunnelHealthy = freezed,
  }) {
    return _then(
      _$AppStateImpl(
        connectionStatus: null == connectionStatus
            ? _value.connectionStatus
            : connectionStatus // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
        protocol: null == protocol
            ? _value.protocol
            : protocol // ignore: cast_nullable_to_non_nullable
                  as Protocols,
        selectedServer: freezed == selectedServer
            ? _value.selectedServer
            : selectedServer // ignore: cast_nullable_to_non_nullable
                  as VpnConfiguration?,
        zenSdkEnabled: null == zenSdkEnabled
            ? _value.zenSdkEnabled
            : zenSdkEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        launchOnStartup: null == launchOnStartup
            ? _value.launchOnStartup
            : launchOnStartup // ignore: cast_nullable_to_non_nullable
                  as bool,
        launchOnStartupFailed: null == launchOnStartupFailed
            ? _value.launchOnStartupFailed
            : launchOnStartupFailed // ignore: cast_nullable_to_non_nullable
                  as bool,
        needsUpdate: freezed == needsUpdate
            ? _value.needsUpdate
            : needsUpdate // ignore: cast_nullable_to_non_nullable
                  as bool?,
        serverSelectionPinned: null == serverSelectionPinned
            ? _value.serverSelectionPinned
            : serverSelectionPinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        tunnelHealthy: freezed == tunnelHealthy
            ? _value.tunnelHealthy
            : tunnelHealthy // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$AppStateImpl implements _AppState {
  const _$AppStateImpl({
    required this.connectionStatus,
    required this.protocol,
    this.selectedServer,
    required this.zenSdkEnabled,
    required this.launchOnStartup,
    required this.launchOnStartupFailed,
    this.needsUpdate,
    this.serverSelectionPinned = false,
    this.tunnelHealthy,
  });

  @override
  final ConnectionStatus connectionStatus;
  @override
  final Protocols protocol;
  @override
  final VpnConfiguration? selectedServer;
  @override
  final bool zenSdkEnabled;
  @override
  final bool launchOnStartup;
  @override
  final bool launchOnStartupFailed;
  @override
  final bool? needsUpdate;

  /// Whether the user has manually pinned a country. False means the
  /// tunnel picks the best server across all countries ("Auto select") —
  /// the home screen should show a generic "Auto" placeholder instead of a
  /// specific country until a real exit is resolved after connecting.
  @override
  @JsonKey()
  final bool serverSelectionPinned;

  /// Whether the connected tunnel is verified to carry real traffic.
  /// null = not checked yet / not connected; false = tunnel up but every
  /// probe failed (exit server down) — UI shows a warning instead of a
  /// plain green Connected.
  @override
  final bool? tunnelHealthy;

  @override
  String toString() {
    return 'AppState(connectionStatus: $connectionStatus, protocol: $protocol, selectedServer: $selectedServer, zenSdkEnabled: $zenSdkEnabled, launchOnStartup: $launchOnStartup, launchOnStartupFailed: $launchOnStartupFailed, needsUpdate: $needsUpdate, serverSelectionPinned: $serverSelectionPinned, tunnelHealthy: $tunnelHealthy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateImpl &&
            (identical(other.connectionStatus, connectionStatus) ||
                other.connectionStatus == connectionStatus) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.selectedServer, selectedServer) ||
                other.selectedServer == selectedServer) &&
            (identical(other.zenSdkEnabled, zenSdkEnabled) ||
                other.zenSdkEnabled == zenSdkEnabled) &&
            (identical(other.launchOnStartup, launchOnStartup) ||
                other.launchOnStartup == launchOnStartup) &&
            (identical(other.launchOnStartupFailed, launchOnStartupFailed) ||
                other.launchOnStartupFailed == launchOnStartupFailed) &&
            (identical(other.needsUpdate, needsUpdate) ||
                other.needsUpdate == needsUpdate) &&
            (identical(other.serverSelectionPinned, serverSelectionPinned) ||
                other.serverSelectionPinned == serverSelectionPinned) &&
            (identical(other.tunnelHealthy, tunnelHealthy) ||
                other.tunnelHealthy == tunnelHealthy));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    connectionStatus,
    protocol,
    selectedServer,
    zenSdkEnabled,
    launchOnStartup,
    launchOnStartupFailed,
    needsUpdate,
    serverSelectionPinned,
    tunnelHealthy,
  );

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      __$$AppStateImplCopyWithImpl<_$AppStateImpl>(this, _$identity);
}

abstract class _AppState implements AppState {
  const factory _AppState({
    required final ConnectionStatus connectionStatus,
    required final Protocols protocol,
    final VpnConfiguration? selectedServer,
    required final bool zenSdkEnabled,
    required final bool launchOnStartup,
    required final bool launchOnStartupFailed,
    final bool? needsUpdate,
    final bool serverSelectionPinned,
    final bool? tunnelHealthy,
  }) = _$AppStateImpl;

  @override
  ConnectionStatus get connectionStatus;
  @override
  Protocols get protocol;
  @override
  VpnConfiguration? get selectedServer;
  @override
  bool get zenSdkEnabled;
  @override
  bool get launchOnStartup;
  @override
  bool get launchOnStartupFailed;
  @override
  bool? get needsUpdate;

  /// Whether the user has manually pinned a country. False means the
  /// tunnel picks the best server across all countries ("Auto select") —
  /// the home screen should show a generic "Auto" placeholder instead of a
  /// specific country until a real exit is resolved after connecting.
  @override
  bool get serverSelectionPinned;

  /// Whether the connected tunnel is verified to carry real traffic.
  /// null = not checked yet / not connected; false = tunnel up but every
  /// probe failed (exit server down) — UI shows a warning instead of a
  /// plain green Connected.
  @override
  bool? get tunnelHealthy;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
