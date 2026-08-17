// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'servers_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ServersState {
  List<PingedVpnConfiguration> get servers =>
      throw _privateConstructorUsedError;
  List<PingedVpnConfiguration> get filteredServers =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSearchActive => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )
    initial,
    required TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )
    loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )?
    initial,
    TResult? Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )?
    loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )?
    initial,
    TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )?
    loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServersStateInitial value) initial,
    required TResult Function(_ServersStateLoaded value) loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServersStateInitial value)? initial,
    TResult? Function(_ServersStateLoaded value)? loaded,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServersStateInitial value)? initial,
    TResult Function(_ServersStateLoaded value)? loaded,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of ServersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServersStateCopyWith<ServersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServersStateCopyWith<$Res> {
  factory $ServersStateCopyWith(
    ServersState value,
    $Res Function(ServersState) then,
  ) = _$ServersStateCopyWithImpl<$Res, ServersState>;
  @useResult
  $Res call({
    List<PingedVpnConfiguration> servers,
    List<PingedVpnConfiguration> filteredServers,
    bool isLoading,
    bool isSearchActive,
    String searchQuery,
  });
}

/// @nodoc
class _$ServersStateCopyWithImpl<$Res, $Val extends ServersState>
    implements $ServersStateCopyWith<$Res> {
  _$ServersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servers = null,
    Object? filteredServers = null,
    Object? isLoading = null,
    Object? isSearchActive = null,
    Object? searchQuery = null,
  }) {
    return _then(
      _value.copyWith(
            servers: null == servers
                ? _value.servers
                : servers // ignore: cast_nullable_to_non_nullable
                      as List<PingedVpnConfiguration>,
            filteredServers: null == filteredServers
                ? _value.filteredServers
                : filteredServers // ignore: cast_nullable_to_non_nullable
                      as List<PingedVpnConfiguration>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSearchActive: null == isSearchActive
                ? _value.isSearchActive
                : isSearchActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServersStateInitialImplCopyWith<$Res>
    implements $ServersStateCopyWith<$Res> {
  factory _$$ServersStateInitialImplCopyWith(
    _$ServersStateInitialImpl value,
    $Res Function(_$ServersStateInitialImpl) then,
  ) = __$$ServersStateInitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PingedVpnConfiguration> servers,
    List<PingedVpnConfiguration> filteredServers,
    bool isLoading,
    bool isSearchActive,
    String searchQuery,
  });
}

/// @nodoc
class __$$ServersStateInitialImplCopyWithImpl<$Res>
    extends _$ServersStateCopyWithImpl<$Res, _$ServersStateInitialImpl>
    implements _$$ServersStateInitialImplCopyWith<$Res> {
  __$$ServersStateInitialImplCopyWithImpl(
    _$ServersStateInitialImpl _value,
    $Res Function(_$ServersStateInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servers = null,
    Object? filteredServers = null,
    Object? isLoading = null,
    Object? isSearchActive = null,
    Object? searchQuery = null,
  }) {
    return _then(
      _$ServersStateInitialImpl(
        servers: null == servers
            ? _value._servers
            : servers // ignore: cast_nullable_to_non_nullable
                  as List<PingedVpnConfiguration>,
        filteredServers: null == filteredServers
            ? _value._filteredServers
            : filteredServers // ignore: cast_nullable_to_non_nullable
                  as List<PingedVpnConfiguration>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSearchActive: null == isSearchActive
            ? _value.isSearchActive
            : isSearchActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ServersStateInitialImpl implements _ServersStateInitial {
  const _$ServersStateInitialImpl({
    final List<PingedVpnConfiguration> servers = const [],
    final List<PingedVpnConfiguration> filteredServers = const [],
    this.isLoading = false,
    this.isSearchActive = false,
    this.searchQuery = '',
  }) : _servers = servers,
       _filteredServers = filteredServers;

  final List<PingedVpnConfiguration> _servers;
  @override
  @JsonKey()
  List<PingedVpnConfiguration> get servers {
    if (_servers is EqualUnmodifiableListView) return _servers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_servers);
  }

  final List<PingedVpnConfiguration> _filteredServers;
  @override
  @JsonKey()
  List<PingedVpnConfiguration> get filteredServers {
    if (_filteredServers is EqualUnmodifiableListView) return _filteredServers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredServers);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSearchActive;
  @override
  @JsonKey()
  final String searchQuery;

  @override
  String toString() {
    return 'ServersState.initial(servers: $servers, filteredServers: $filteredServers, isLoading: $isLoading, isSearchActive: $isSearchActive, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServersStateInitialImpl &&
            const DeepCollectionEquality().equals(other._servers, _servers) &&
            const DeepCollectionEquality().equals(
              other._filteredServers,
              _filteredServers,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSearchActive, isSearchActive) ||
                other.isSearchActive == isSearchActive) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_servers),
    const DeepCollectionEquality().hash(_filteredServers),
    isLoading,
    isSearchActive,
    searchQuery,
  );

  /// Create a copy of ServersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServersStateInitialImplCopyWith<_$ServersStateInitialImpl> get copyWith =>
      __$$ServersStateInitialImplCopyWithImpl<_$ServersStateInitialImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )
    initial,
    required TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )
    loaded,
  }) {
    return initial(
      servers,
      filteredServers,
      isLoading,
      isSearchActive,
      searchQuery,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )?
    initial,
    TResult? Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )?
    loaded,
  }) {
    return initial?.call(
      servers,
      filteredServers,
      isLoading,
      isSearchActive,
      searchQuery,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )?
    initial,
    TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )?
    loaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(
        servers,
        filteredServers,
        isLoading,
        isSearchActive,
        searchQuery,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServersStateInitial value) initial,
    required TResult Function(_ServersStateLoaded value) loaded,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServersStateInitial value)? initial,
    TResult? Function(_ServersStateLoaded value)? loaded,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServersStateInitial value)? initial,
    TResult Function(_ServersStateLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _ServersStateInitial implements ServersState {
  const factory _ServersStateInitial({
    final List<PingedVpnConfiguration> servers,
    final List<PingedVpnConfiguration> filteredServers,
    final bool isLoading,
    final bool isSearchActive,
    final String searchQuery,
  }) = _$ServersStateInitialImpl;

  @override
  List<PingedVpnConfiguration> get servers;
  @override
  List<PingedVpnConfiguration> get filteredServers;
  @override
  bool get isLoading;
  @override
  bool get isSearchActive;
  @override
  String get searchQuery;

  /// Create a copy of ServersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServersStateInitialImplCopyWith<_$ServersStateInitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ServersStateLoadedImplCopyWith<$Res>
    implements $ServersStateCopyWith<$Res> {
  factory _$$ServersStateLoadedImplCopyWith(
    _$ServersStateLoadedImpl value,
    $Res Function(_$ServersStateLoadedImpl) then,
  ) = __$$ServersStateLoadedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PingedVpnConfiguration> servers,
    List<PingedVpnConfiguration> filteredServers,
    bool isLoading,
    bool isSearchActive,
    String searchQuery,
    bool pinned,
  });
}

/// @nodoc
class __$$ServersStateLoadedImplCopyWithImpl<$Res>
    extends _$ServersStateCopyWithImpl<$Res, _$ServersStateLoadedImpl>
    implements _$$ServersStateLoadedImplCopyWith<$Res> {
  __$$ServersStateLoadedImplCopyWithImpl(
    _$ServersStateLoadedImpl _value,
    $Res Function(_$ServersStateLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servers = null,
    Object? filteredServers = null,
    Object? isLoading = null,
    Object? isSearchActive = null,
    Object? searchQuery = null,
    Object? pinned = null,
  }) {
    return _then(
      _$ServersStateLoadedImpl(
        servers: null == servers
            ? _value._servers
            : servers // ignore: cast_nullable_to_non_nullable
                  as List<PingedVpnConfiguration>,
        filteredServers: null == filteredServers
            ? _value._filteredServers
            : filteredServers // ignore: cast_nullable_to_non_nullable
                  as List<PingedVpnConfiguration>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSearchActive: null == isSearchActive
            ? _value.isSearchActive
            : isSearchActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        pinned: null == pinned
            ? _value.pinned
            : pinned // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ServersStateLoadedImpl implements _ServersStateLoaded {
  const _$ServersStateLoadedImpl({
    required final List<PingedVpnConfiguration> servers,
    required final List<PingedVpnConfiguration> filteredServers,
    required this.isLoading,
    required this.isSearchActive,
    this.searchQuery = '',
    this.pinned = true,
  }) : _servers = servers,
       _filteredServers = filteredServers;

  final List<PingedVpnConfiguration> _servers;
  @override
  List<PingedVpnConfiguration> get servers {
    if (_servers is EqualUnmodifiableListView) return _servers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_servers);
  }

  final List<PingedVpnConfiguration> _filteredServers;
  @override
  List<PingedVpnConfiguration> get filteredServers {
    if (_filteredServers is EqualUnmodifiableListView) return _filteredServers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredServers);
  }

  @override
  final bool isLoading;
  @override
  final bool isSearchActive;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool pinned;

  @override
  String toString() {
    return 'ServersState.loaded(servers: $servers, filteredServers: $filteredServers, isLoading: $isLoading, isSearchActive: $isSearchActive, searchQuery: $searchQuery, pinned: $pinned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServersStateLoadedImpl &&
            const DeepCollectionEquality().equals(other._servers, _servers) &&
            const DeepCollectionEquality().equals(
              other._filteredServers,
              _filteredServers,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSearchActive, isSearchActive) ||
                other.isSearchActive == isSearchActive) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.pinned, pinned) || other.pinned == pinned));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_servers),
    const DeepCollectionEquality().hash(_filteredServers),
    isLoading,
    isSearchActive,
    searchQuery,
    pinned,
  );

  /// Create a copy of ServersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServersStateLoadedImplCopyWith<_$ServersStateLoadedImpl> get copyWith =>
      __$$ServersStateLoadedImplCopyWithImpl<_$ServersStateLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )
    initial,
    required TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )
    loaded,
  }) {
    return loaded(
      servers,
      filteredServers,
      isLoading,
      isSearchActive,
      searchQuery,
      pinned,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )?
    initial,
    TResult? Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )?
    loaded,
  }) {
    return loaded?.call(
      servers,
      filteredServers,
      isLoading,
      isSearchActive,
      searchQuery,
      pinned,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
    )?
    initial,
    TResult Function(
      List<PingedVpnConfiguration> servers,
      List<PingedVpnConfiguration> filteredServers,
      bool isLoading,
      bool isSearchActive,
      String searchQuery,
      bool pinned,
    )?
    loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        servers,
        filteredServers,
        isLoading,
        isSearchActive,
        searchQuery,
        pinned,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServersStateInitial value) initial,
    required TResult Function(_ServersStateLoaded value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServersStateInitial value)? initial,
    TResult? Function(_ServersStateLoaded value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServersStateInitial value)? initial,
    TResult Function(_ServersStateLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _ServersStateLoaded implements ServersState {
  const factory _ServersStateLoaded({
    required final List<PingedVpnConfiguration> servers,
    required final List<PingedVpnConfiguration> filteredServers,
    required final bool isLoading,
    required final bool isSearchActive,
    final String searchQuery,
    final bool pinned,
  }) = _$ServersStateLoadedImpl;

  @override
  List<PingedVpnConfiguration> get servers;
  @override
  List<PingedVpnConfiguration> get filteredServers;
  @override
  bool get isLoading;
  @override
  bool get isSearchActive;
  @override
  String get searchQuery;
  bool get pinned;

  /// Create a copy of ServersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServersStateLoadedImplCopyWith<_$ServersStateLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
