// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vpn_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VpnConfiguration _$VpnConfigurationFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'system':
      return SystemVpnConfiguration.fromJson(json);
    case 'user':
      return UserVpnConfiguration.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'type',
        'VpnConfiguration',
        'Invalid union type "${json['type']}"!',
      );
  }
}

/// @nodoc
mixin _$VpnConfiguration {
  String get ip => throw _privateConstructorUsedError;
  RegionResponse get region => throw _privateConstructorUsedError;
  List<VpnConfigurationDetails> get configurations =>
      throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )
    system,
    required TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )
    user,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )?
    system,
    TResult? Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )?
    user,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )?
    system,
    TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )?
    user,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SystemVpnConfiguration value) system,
    required TResult Function(UserVpnConfiguration value) user,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SystemVpnConfiguration value)? system,
    TResult? Function(UserVpnConfiguration value)? user,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SystemVpnConfiguration value)? system,
    TResult Function(UserVpnConfiguration value)? user,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this VpnConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VpnConfigurationCopyWith<VpnConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VpnConfigurationCopyWith<$Res> {
  factory $VpnConfigurationCopyWith(
    VpnConfiguration value,
    $Res Function(VpnConfiguration) then,
  ) = _$VpnConfigurationCopyWithImpl<$Res, VpnConfiguration>;
  @useResult
  $Res call({
    String ip,
    RegionResponse region,
    List<VpnConfigurationDetails> configurations,
    bool isFavorite,
  });

  $RegionResponseCopyWith<$Res> get region;
}

/// @nodoc
class _$VpnConfigurationCopyWithImpl<$Res, $Val extends VpnConfiguration>
    implements $VpnConfigurationCopyWith<$Res> {
  _$VpnConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? region = null,
    Object? configurations = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _value.copyWith(
            ip: null == ip
                ? _value.ip
                : ip // ignore: cast_nullable_to_non_nullable
                      as String,
            region: null == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                      as RegionResponse,
            configurations: null == configurations
                ? _value.configurations
                : configurations // ignore: cast_nullable_to_non_nullable
                      as List<VpnConfigurationDetails>,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegionResponseCopyWith<$Res> get region {
    return $RegionResponseCopyWith<$Res>(_value.region, (value) {
      return _then(_value.copyWith(region: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SystemVpnConfigurationImplCopyWith<$Res>
    implements $VpnConfigurationCopyWith<$Res> {
  factory _$$SystemVpnConfigurationImplCopyWith(
    _$SystemVpnConfigurationImpl value,
    $Res Function(_$SystemVpnConfigurationImpl) then,
  ) = __$$SystemVpnConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String ip,
    RegionResponse region,
    List<VpnConfigurationDetails> configurations,
    String city,
    bool isFree,
    bool isFavorite,
  });

  @override
  $RegionResponseCopyWith<$Res> get region;
}

/// @nodoc
class __$$SystemVpnConfigurationImplCopyWithImpl<$Res>
    extends _$VpnConfigurationCopyWithImpl<$Res, _$SystemVpnConfigurationImpl>
    implements _$$SystemVpnConfigurationImplCopyWith<$Res> {
  __$$SystemVpnConfigurationImplCopyWithImpl(
    _$SystemVpnConfigurationImpl _value,
    $Res Function(_$SystemVpnConfigurationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? region = null,
    Object? configurations = null,
    Object? city = null,
    Object? isFree = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _$SystemVpnConfigurationImpl(
        ip: null == ip
            ? _value.ip
            : ip // ignore: cast_nullable_to_non_nullable
                  as String,
        region: null == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as RegionResponse,
        configurations: null == configurations
            ? _value._configurations
            : configurations // ignore: cast_nullable_to_non_nullable
                  as List<VpnConfigurationDetails>,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        isFree: null == isFree
            ? _value.isFree
            : isFree // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemVpnConfigurationImpl implements SystemVpnConfiguration {
  const _$SystemVpnConfigurationImpl({
    required this.ip,
    required this.region,
    required final List<VpnConfigurationDetails> configurations,
    required this.city,
    required this.isFree,
    this.isFavorite = false,
    final String? $type,
  }) : _configurations = configurations,
       $type = $type ?? 'system';

  factory _$SystemVpnConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemVpnConfigurationImplFromJson(json);

  @override
  final String ip;
  @override
  final RegionResponse region;
  final List<VpnConfigurationDetails> _configurations;
  @override
  List<VpnConfigurationDetails> get configurations {
    if (_configurations is EqualUnmodifiableListView) return _configurations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_configurations);
  }

  @override
  final String city;
  @override
  final bool isFree;
  @override
  @JsonKey()
  final bool isFavorite;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'VpnConfiguration.system(ip: $ip, region: $region, configurations: $configurations, city: $city, isFree: $isFree, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemVpnConfigurationImpl &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.region, region) || other.region == region) &&
            const DeepCollectionEquality().equals(
              other._configurations,
              _configurations,
            ) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    ip,
    region,
    const DeepCollectionEquality().hash(_configurations),
    city,
    isFree,
    isFavorite,
  );

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemVpnConfigurationImplCopyWith<_$SystemVpnConfigurationImpl>
  get copyWith =>
      __$$SystemVpnConfigurationImplCopyWithImpl<_$SystemVpnConfigurationImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )
    system,
    required TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )
    user,
  }) {
    return system(ip, region, configurations, city, isFree, isFavorite);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )?
    system,
    TResult? Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )?
    user,
  }) {
    return system?.call(ip, region, configurations, city, isFree, isFavorite);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )?
    system,
    TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )?
    user,
    required TResult orElse(),
  }) {
    if (system != null) {
      return system(ip, region, configurations, city, isFree, isFavorite);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SystemVpnConfiguration value) system,
    required TResult Function(UserVpnConfiguration value) user,
  }) {
    return system(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SystemVpnConfiguration value)? system,
    TResult? Function(UserVpnConfiguration value)? user,
  }) {
    return system?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SystemVpnConfiguration value)? system,
    TResult Function(UserVpnConfiguration value)? user,
    required TResult orElse(),
  }) {
    if (system != null) {
      return system(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemVpnConfigurationImplToJson(this);
  }
}

abstract class SystemVpnConfiguration implements VpnConfiguration {
  const factory SystemVpnConfiguration({
    required final String ip,
    required final RegionResponse region,
    required final List<VpnConfigurationDetails> configurations,
    required final String city,
    required final bool isFree,
    final bool isFavorite,
  }) = _$SystemVpnConfigurationImpl;

  factory SystemVpnConfiguration.fromJson(Map<String, dynamic> json) =
      _$SystemVpnConfigurationImpl.fromJson;

  @override
  String get ip;
  @override
  RegionResponse get region;
  @override
  List<VpnConfigurationDetails> get configurations;
  String get city;
  bool get isFree;
  @override
  bool get isFavorite;

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemVpnConfigurationImplCopyWith<_$SystemVpnConfigurationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserVpnConfigurationImplCopyWith<$Res>
    implements $VpnConfigurationCopyWith<$Res> {
  factory _$$UserVpnConfigurationImplCopyWith(
    _$UserVpnConfigurationImpl value,
    $Res Function(_$UserVpnConfigurationImpl) then,
  ) = __$$UserVpnConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String ip,
    RegionResponse region,
    List<VpnConfigurationDetails> configurations,
    String title,
    bool isFavorite,
  });

  @override
  $RegionResponseCopyWith<$Res> get region;
}

/// @nodoc
class __$$UserVpnConfigurationImplCopyWithImpl<$Res>
    extends _$VpnConfigurationCopyWithImpl<$Res, _$UserVpnConfigurationImpl>
    implements _$$UserVpnConfigurationImplCopyWith<$Res> {
  __$$UserVpnConfigurationImplCopyWithImpl(
    _$UserVpnConfigurationImpl _value,
    $Res Function(_$UserVpnConfigurationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? region = null,
    Object? configurations = null,
    Object? title = null,
    Object? isFavorite = null,
  }) {
    return _then(
      _$UserVpnConfigurationImpl(
        ip: null == ip
            ? _value.ip
            : ip // ignore: cast_nullable_to_non_nullable
                  as String,
        region: null == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as RegionResponse,
        configurations: null == configurations
            ? _value._configurations
            : configurations // ignore: cast_nullable_to_non_nullable
                  as List<VpnConfigurationDetails>,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserVpnConfigurationImpl implements UserVpnConfiguration {
  const _$UserVpnConfigurationImpl({
    required this.ip,
    required this.region,
    required final List<VpnConfigurationDetails> configurations,
    required this.title,
    this.isFavorite = false,
    final String? $type,
  }) : _configurations = configurations,
       $type = $type ?? 'user';

  factory _$UserVpnConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserVpnConfigurationImplFromJson(json);

  @override
  final String ip;
  @override
  final RegionResponse region;
  final List<VpnConfigurationDetails> _configurations;
  @override
  List<VpnConfigurationDetails> get configurations {
    if (_configurations is EqualUnmodifiableListView) return _configurations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_configurations);
  }

  @override
  final String title;
  @override
  @JsonKey()
  final bool isFavorite;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'VpnConfiguration.user(ip: $ip, region: $region, configurations: $configurations, title: $title, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserVpnConfigurationImpl &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.region, region) || other.region == region) &&
            const DeepCollectionEquality().equals(
              other._configurations,
              _configurations,
            ) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    ip,
    region,
    const DeepCollectionEquality().hash(_configurations),
    title,
    isFavorite,
  );

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserVpnConfigurationImplCopyWith<_$UserVpnConfigurationImpl>
  get copyWith =>
      __$$UserVpnConfigurationImplCopyWithImpl<_$UserVpnConfigurationImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )
    system,
    required TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )
    user,
  }) {
    return user(ip, region, configurations, title, isFavorite);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )?
    system,
    TResult? Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )?
    user,
  }) {
    return user?.call(ip, region, configurations, title, isFavorite);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String city,
      bool isFree,
      bool isFavorite,
    )?
    system,
    TResult Function(
      String ip,
      RegionResponse region,
      List<VpnConfigurationDetails> configurations,
      String title,
      bool isFavorite,
    )?
    user,
    required TResult orElse(),
  }) {
    if (user != null) {
      return user(ip, region, configurations, title, isFavorite);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SystemVpnConfiguration value) system,
    required TResult Function(UserVpnConfiguration value) user,
  }) {
    return user(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SystemVpnConfiguration value)? system,
    TResult? Function(UserVpnConfiguration value)? user,
  }) {
    return user?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SystemVpnConfiguration value)? system,
    TResult Function(UserVpnConfiguration value)? user,
    required TResult orElse(),
  }) {
    if (user != null) {
      return user(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UserVpnConfigurationImplToJson(this);
  }
}

abstract class UserVpnConfiguration implements VpnConfiguration {
  const factory UserVpnConfiguration({
    required final String ip,
    required final RegionResponse region,
    required final List<VpnConfigurationDetails> configurations,
    required final String title,
    final bool isFavorite,
  }) = _$UserVpnConfigurationImpl;

  factory UserVpnConfiguration.fromJson(Map<String, dynamic> json) =
      _$UserVpnConfigurationImpl.fromJson;

  @override
  String get ip;
  @override
  RegionResponse get region;
  @override
  List<VpnConfigurationDetails> get configurations;
  String get title;
  @override
  bool get isFavorite;

  /// Create a copy of VpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserVpnConfigurationImplCopyWith<_$UserVpnConfigurationImpl>
  get copyWith => throw _privateConstructorUsedError;
}
