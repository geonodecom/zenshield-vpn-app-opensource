// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zenshield_vpn_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ZenshieldConfig _$ZenshieldConfigFromJson(Map<String, dynamic> json) {
  return _Config.fromJson(json);
}

/// @nodoc
mixin _$ZenshieldConfig {
  String get remoteDns => throw _privateConstructorUsedError;
  Routes get routes => throw _privateConstructorUsedError;
  List<String> get outboundsLinks => throw _privateConstructorUsedError;
  String get logLevel => throw _privateConstructorUsedError;
  String get logsPath => throw _privateConstructorUsedError;
  String get directDns => throw _privateConstructorUsedError;
  String get tunImplementation => throw _privateConstructorUsedError;
  int get urlTestInterval => throw _privateConstructorUsedError;
  String get clashApiToken => throw _privateConstructorUsedError;
  int get clashApiPort => throw _privateConstructorUsedError;
  bool get isMobile => throw _privateConstructorUsedError;
  SocksInbound? get socksInbound => throw _privateConstructorUsedError;

  /// Serializes this ZenshieldConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ZenshieldConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZenshieldConfigCopyWith<ZenshieldConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZenshieldConfigCopyWith<$Res> {
  factory $ZenshieldConfigCopyWith(
    ZenshieldConfig value,
    $Res Function(ZenshieldConfig) then,
  ) = _$ZenshieldConfigCopyWithImpl<$Res, ZenshieldConfig>;
  @useResult
  $Res call({
    String remoteDns,
    Routes routes,
    List<String> outboundsLinks,
    String logLevel,
    String logsPath,
    String directDns,
    String tunImplementation,
    int urlTestInterval,
    String clashApiToken,
    int clashApiPort,
    bool isMobile,
    SocksInbound? socksInbound,
  });

  $RoutesCopyWith<$Res> get routes;
  $SocksInboundCopyWith<$Res>? get socksInbound;
}

/// @nodoc
class _$ZenshieldConfigCopyWithImpl<$Res, $Val extends ZenshieldConfig>
    implements $ZenshieldConfigCopyWith<$Res> {
  _$ZenshieldConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZenshieldConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remoteDns = null,
    Object? routes = null,
    Object? outboundsLinks = null,
    Object? logLevel = null,
    Object? logsPath = null,
    Object? directDns = null,
    Object? tunImplementation = null,
    Object? urlTestInterval = null,
    Object? clashApiToken = null,
    Object? clashApiPort = null,
    Object? isMobile = null,
    Object? socksInbound = freezed,
  }) {
    return _then(
      _value.copyWith(
            remoteDns: null == remoteDns
                ? _value.remoteDns
                : remoteDns // ignore: cast_nullable_to_non_nullable
                      as String,
            routes: null == routes
                ? _value.routes
                : routes // ignore: cast_nullable_to_non_nullable
                      as Routes,
            outboundsLinks: null == outboundsLinks
                ? _value.outboundsLinks
                : outboundsLinks // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            logLevel: null == logLevel
                ? _value.logLevel
                : logLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            logsPath: null == logsPath
                ? _value.logsPath
                : logsPath // ignore: cast_nullable_to_non_nullable
                      as String,
            directDns: null == directDns
                ? _value.directDns
                : directDns // ignore: cast_nullable_to_non_nullable
                      as String,
            tunImplementation: null == tunImplementation
                ? _value.tunImplementation
                : tunImplementation // ignore: cast_nullable_to_non_nullable
                      as String,
            urlTestInterval: null == urlTestInterval
                ? _value.urlTestInterval
                : urlTestInterval // ignore: cast_nullable_to_non_nullable
                      as int,
            clashApiToken: null == clashApiToken
                ? _value.clashApiToken
                : clashApiToken // ignore: cast_nullable_to_non_nullable
                      as String,
            clashApiPort: null == clashApiPort
                ? _value.clashApiPort
                : clashApiPort // ignore: cast_nullable_to_non_nullable
                      as int,
            isMobile: null == isMobile
                ? _value.isMobile
                : isMobile // ignore: cast_nullable_to_non_nullable
                      as bool,
            socksInbound: freezed == socksInbound
                ? _value.socksInbound
                : socksInbound // ignore: cast_nullable_to_non_nullable
                      as SocksInbound?,
          )
          as $Val,
    );
  }

  /// Create a copy of ZenshieldConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoutesCopyWith<$Res> get routes {
    return $RoutesCopyWith<$Res>(_value.routes, (value) {
      return _then(_value.copyWith(routes: value) as $Val);
    });
  }

  /// Create a copy of ZenshieldConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SocksInboundCopyWith<$Res>? get socksInbound {
    if (_value.socksInbound == null) {
      return null;
    }

    return $SocksInboundCopyWith<$Res>(_value.socksInbound!, (value) {
      return _then(_value.copyWith(socksInbound: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConfigImplCopyWith<$Res>
    implements $ZenshieldConfigCopyWith<$Res> {
  factory _$$ConfigImplCopyWith(
    _$ConfigImpl value,
    $Res Function(_$ConfigImpl) then,
  ) = __$$ConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String remoteDns,
    Routes routes,
    List<String> outboundsLinks,
    String logLevel,
    String logsPath,
    String directDns,
    String tunImplementation,
    int urlTestInterval,
    String clashApiToken,
    int clashApiPort,
    bool isMobile,
    SocksInbound? socksInbound,
  });

  @override
  $RoutesCopyWith<$Res> get routes;
  @override
  $SocksInboundCopyWith<$Res>? get socksInbound;
}

/// @nodoc
class __$$ConfigImplCopyWithImpl<$Res>
    extends _$ZenshieldConfigCopyWithImpl<$Res, _$ConfigImpl>
    implements _$$ConfigImplCopyWith<$Res> {
  __$$ConfigImplCopyWithImpl(
    _$ConfigImpl _value,
    $Res Function(_$ConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ZenshieldConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remoteDns = null,
    Object? routes = null,
    Object? outboundsLinks = null,
    Object? logLevel = null,
    Object? logsPath = null,
    Object? directDns = null,
    Object? tunImplementation = null,
    Object? urlTestInterval = null,
    Object? clashApiToken = null,
    Object? clashApiPort = null,
    Object? isMobile = null,
    Object? socksInbound = freezed,
  }) {
    return _then(
      _$ConfigImpl(
        remoteDns: null == remoteDns
            ? _value.remoteDns
            : remoteDns // ignore: cast_nullable_to_non_nullable
                  as String,
        routes: null == routes
            ? _value.routes
            : routes // ignore: cast_nullable_to_non_nullable
                  as Routes,
        outboundsLinks: null == outboundsLinks
            ? _value._outboundsLinks
            : outboundsLinks // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        logLevel: null == logLevel
            ? _value.logLevel
            : logLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        logsPath: null == logsPath
            ? _value.logsPath
            : logsPath // ignore: cast_nullable_to_non_nullable
                  as String,
        directDns: null == directDns
            ? _value.directDns
            : directDns // ignore: cast_nullable_to_non_nullable
                  as String,
        tunImplementation: null == tunImplementation
            ? _value.tunImplementation
            : tunImplementation // ignore: cast_nullable_to_non_nullable
                  as String,
        urlTestInterval: null == urlTestInterval
            ? _value.urlTestInterval
            : urlTestInterval // ignore: cast_nullable_to_non_nullable
                  as int,
        clashApiToken: null == clashApiToken
            ? _value.clashApiToken
            : clashApiToken // ignore: cast_nullable_to_non_nullable
                  as String,
        clashApiPort: null == clashApiPort
            ? _value.clashApiPort
            : clashApiPort // ignore: cast_nullable_to_non_nullable
                  as int,
        isMobile: null == isMobile
            ? _value.isMobile
            : isMobile // ignore: cast_nullable_to_non_nullable
                  as bool,
        socksInbound: freezed == socksInbound
            ? _value.socksInbound
            : socksInbound // ignore: cast_nullable_to_non_nullable
                  as SocksInbound?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigImpl implements _Config {
  const _$ConfigImpl({
    required this.remoteDns,
    required this.routes,
    required final List<String> outboundsLinks,
    required this.logLevel,
    required this.logsPath,
    required this.directDns,
    required this.tunImplementation,
    required this.urlTestInterval,
    required this.clashApiToken,
    required this.clashApiPort,
    required this.isMobile,
    this.socksInbound,
  }) : _outboundsLinks = outboundsLinks;

  factory _$ConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigImplFromJson(json);

  @override
  final String remoteDns;
  @override
  final Routes routes;
  final List<String> _outboundsLinks;
  @override
  List<String> get outboundsLinks {
    if (_outboundsLinks is EqualUnmodifiableListView) return _outboundsLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outboundsLinks);
  }

  @override
  final String logLevel;
  @override
  final String logsPath;
  @override
  final String directDns;
  @override
  final String tunImplementation;
  @override
  final int urlTestInterval;
  @override
  final String clashApiToken;
  @override
  final int clashApiPort;
  @override
  final bool isMobile;
  @override
  final SocksInbound? socksInbound;

  @override
  String toString() {
    return 'ZenshieldConfig(remoteDns: $remoteDns, routes: $routes, outboundsLinks: $outboundsLinks, logLevel: $logLevel, logsPath: $logsPath, directDns: $directDns, tunImplementation: $tunImplementation, urlTestInterval: $urlTestInterval, clashApiToken: $clashApiToken, clashApiPort: $clashApiPort, isMobile: $isMobile, socksInbound: $socksInbound)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigImpl &&
            (identical(other.remoteDns, remoteDns) ||
                other.remoteDns == remoteDns) &&
            (identical(other.routes, routes) || other.routes == routes) &&
            const DeepCollectionEquality().equals(
              other._outboundsLinks,
              _outboundsLinks,
            ) &&
            (identical(other.logLevel, logLevel) ||
                other.logLevel == logLevel) &&
            (identical(other.logsPath, logsPath) ||
                other.logsPath == logsPath) &&
            (identical(other.directDns, directDns) ||
                other.directDns == directDns) &&
            (identical(other.tunImplementation, tunImplementation) ||
                other.tunImplementation == tunImplementation) &&
            (identical(other.urlTestInterval, urlTestInterval) ||
                other.urlTestInterval == urlTestInterval) &&
            (identical(other.clashApiToken, clashApiToken) ||
                other.clashApiToken == clashApiToken) &&
            (identical(other.clashApiPort, clashApiPort) ||
                other.clashApiPort == clashApiPort) &&
            (identical(other.isMobile, isMobile) ||
                other.isMobile == isMobile) &&
            (identical(other.socksInbound, socksInbound) ||
                other.socksInbound == socksInbound));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    remoteDns,
    routes,
    const DeepCollectionEquality().hash(_outboundsLinks),
    logLevel,
    logsPath,
    directDns,
    tunImplementation,
    urlTestInterval,
    clashApiToken,
    clashApiPort,
    isMobile,
    socksInbound,
  );

  /// Create a copy of ZenshieldConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith =>
      __$$ConfigImplCopyWithImpl<_$ConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigImplToJson(this);
  }
}

abstract class _Config implements ZenshieldConfig {
  const factory _Config({
    required final String remoteDns,
    required final Routes routes,
    required final List<String> outboundsLinks,
    required final String logLevel,
    required final String logsPath,
    required final String directDns,
    required final String tunImplementation,
    required final int urlTestInterval,
    required final String clashApiToken,
    required final int clashApiPort,
    required final bool isMobile,
    final SocksInbound? socksInbound,
  }) = _$ConfigImpl;

  factory _Config.fromJson(Map<String, dynamic> json) = _$ConfigImpl.fromJson;

  @override
  String get remoteDns;
  @override
  Routes get routes;
  @override
  List<String> get outboundsLinks;
  @override
  String get logLevel;
  @override
  String get logsPath;
  @override
  String get directDns;
  @override
  String get tunImplementation;
  @override
  int get urlTestInterval;
  @override
  String get clashApiToken;
  @override
  int get clashApiPort;
  @override
  bool get isMobile;
  @override
  SocksInbound? get socksInbound;

  /// Create a copy of ZenshieldConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Routes _$RoutesFromJson(Map<String, dynamic> json) {
  return _Routes.fromJson(json);
}

/// @nodoc
mixin _$Routes {
  List<String> get direct => throw _privateConstructorUsedError;
  List<String> get block => throw _privateConstructorUsedError;

  /// Serializes this Routes to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Routes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutesCopyWith<Routes> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutesCopyWith<$Res> {
  factory $RoutesCopyWith(Routes value, $Res Function(Routes) then) =
      _$RoutesCopyWithImpl<$Res, Routes>;
  @useResult
  $Res call({List<String> direct, List<String> block});
}

/// @nodoc
class _$RoutesCopyWithImpl<$Res, $Val extends Routes>
    implements $RoutesCopyWith<$Res> {
  _$RoutesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Routes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? direct = null, Object? block = null}) {
    return _then(
      _value.copyWith(
            direct: null == direct
                ? _value.direct
                : direct // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            block: null == block
                ? _value.block
                : block // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoutesImplCopyWith<$Res> implements $RoutesCopyWith<$Res> {
  factory _$$RoutesImplCopyWith(
    _$RoutesImpl value,
    $Res Function(_$RoutesImpl) then,
  ) = __$$RoutesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> direct, List<String> block});
}

/// @nodoc
class __$$RoutesImplCopyWithImpl<$Res>
    extends _$RoutesCopyWithImpl<$Res, _$RoutesImpl>
    implements _$$RoutesImplCopyWith<$Res> {
  __$$RoutesImplCopyWithImpl(
    _$RoutesImpl _value,
    $Res Function(_$RoutesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Routes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? direct = null, Object? block = null}) {
    return _then(
      _$RoutesImpl(
        direct: null == direct
            ? _value._direct
            : direct // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        block: null == block
            ? _value._block
            : block // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutesImpl implements _Routes {
  const _$RoutesImpl({
    required final List<String> direct,
    required final List<String> block,
  }) : _direct = direct,
       _block = block;

  factory _$RoutesImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutesImplFromJson(json);

  final List<String> _direct;
  @override
  List<String> get direct {
    if (_direct is EqualUnmodifiableListView) return _direct;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_direct);
  }

  final List<String> _block;
  @override
  List<String> get block {
    if (_block is EqualUnmodifiableListView) return _block;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_block);
  }

  @override
  String toString() {
    return 'Routes(direct: $direct, block: $block)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutesImpl &&
            const DeepCollectionEquality().equals(other._direct, _direct) &&
            const DeepCollectionEquality().equals(other._block, _block));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_direct),
    const DeepCollectionEquality().hash(_block),
  );

  /// Create a copy of Routes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutesImplCopyWith<_$RoutesImpl> get copyWith =>
      __$$RoutesImplCopyWithImpl<_$RoutesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutesImplToJson(this);
  }
}

abstract class _Routes implements Routes {
  const factory _Routes({
    required final List<String> direct,
    required final List<String> block,
  }) = _$RoutesImpl;

  factory _Routes.fromJson(Map<String, dynamic> json) = _$RoutesImpl.fromJson;

  @override
  List<String> get direct;
  @override
  List<String> get block;

  /// Create a copy of Routes
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutesImplCopyWith<_$RoutesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocksInbound _$SocksInboundFromJson(Map<String, dynamic> json) {
  return _SocksInbound.fromJson(json);
}

/// @nodoc
mixin _$SocksInbound {
  bool get enabled => throw _privateConstructorUsedError;
  String get listen => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;
  bool get direct => throw _privateConstructorUsedError;

  /// Serializes this SocksInbound to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocksInbound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocksInboundCopyWith<SocksInbound> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocksInboundCopyWith<$Res> {
  factory $SocksInboundCopyWith(
    SocksInbound value,
    $Res Function(SocksInbound) then,
  ) = _$SocksInboundCopyWithImpl<$Res, SocksInbound>;
  @useResult
  $Res call({bool enabled, String listen, int port, String tag, bool direct});
}

/// @nodoc
class _$SocksInboundCopyWithImpl<$Res, $Val extends SocksInbound>
    implements $SocksInboundCopyWith<$Res> {
  _$SocksInboundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocksInbound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? listen = null,
    Object? port = null,
    Object? tag = null,
    Object? direct = null,
  }) {
    return _then(
      _value.copyWith(
            enabled: null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            listen: null == listen
                ? _value.listen
                : listen // ignore: cast_nullable_to_non_nullable
                      as String,
            port: null == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                      as int,
            tag: null == tag
                ? _value.tag
                : tag // ignore: cast_nullable_to_non_nullable
                      as String,
            direct: null == direct
                ? _value.direct
                : direct // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SocksInboundImplCopyWith<$Res>
    implements $SocksInboundCopyWith<$Res> {
  factory _$$SocksInboundImplCopyWith(
    _$SocksInboundImpl value,
    $Res Function(_$SocksInboundImpl) then,
  ) = __$$SocksInboundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enabled, String listen, int port, String tag, bool direct});
}

/// @nodoc
class __$$SocksInboundImplCopyWithImpl<$Res>
    extends _$SocksInboundCopyWithImpl<$Res, _$SocksInboundImpl>
    implements _$$SocksInboundImplCopyWith<$Res> {
  __$$SocksInboundImplCopyWithImpl(
    _$SocksInboundImpl _value,
    $Res Function(_$SocksInboundImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SocksInbound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? listen = null,
    Object? port = null,
    Object? tag = null,
    Object? direct = null,
  }) {
    return _then(
      _$SocksInboundImpl(
        enabled: null == enabled
            ? _value.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        listen: null == listen
            ? _value.listen
            : listen // ignore: cast_nullable_to_non_nullable
                  as String,
        port: null == port
            ? _value.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int,
        tag: null == tag
            ? _value.tag
            : tag // ignore: cast_nullable_to_non_nullable
                  as String,
        direct: null == direct
            ? _value.direct
            : direct // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SocksInboundImpl implements _SocksInbound {
  const _$SocksInboundImpl({
    required this.enabled,
    required this.listen,
    required this.port,
    required this.tag,
    required this.direct,
  });

  factory _$SocksInboundImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocksInboundImplFromJson(json);

  @override
  final bool enabled;
  @override
  final String listen;
  @override
  final int port;
  @override
  final String tag;
  @override
  final bool direct;

  @override
  String toString() {
    return 'SocksInbound(enabled: $enabled, listen: $listen, port: $port, tag: $tag, direct: $direct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocksInboundImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.listen, listen) || other.listen == listen) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.direct, direct) || other.direct == direct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, enabled, listen, port, tag, direct);

  /// Create a copy of SocksInbound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocksInboundImplCopyWith<_$SocksInboundImpl> get copyWith =>
      __$$SocksInboundImplCopyWithImpl<_$SocksInboundImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocksInboundImplToJson(this);
  }
}

abstract class _SocksInbound implements SocksInbound {
  const factory _SocksInbound({
    required final bool enabled,
    required final String listen,
    required final int port,
    required final String tag,
    required final bool direct,
  }) = _$SocksInboundImpl;

  factory _SocksInbound.fromJson(Map<String, dynamic> json) =
      _$SocksInboundImpl.fromJson;

  @override
  bool get enabled;
  @override
  String get listen;
  @override
  int get port;
  @override
  String get tag;
  @override
  bool get direct;

  /// Create a copy of SocksInbound
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocksInboundImplCopyWith<_$SocksInboundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
