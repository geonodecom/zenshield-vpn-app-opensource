// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppTheme {
  ThemeType get themeType => throw _privateConstructorUsedError;
  AppColors get colors => throw _privateConstructorUsedError;

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppThemeCopyWith<AppTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppThemeCopyWith<$Res> {
  factory $AppThemeCopyWith(AppTheme value, $Res Function(AppTheme) then) =
      _$AppThemeCopyWithImpl<$Res, AppTheme>;
  @useResult
  $Res call({ThemeType themeType, AppColors colors});

  $AppColorsCopyWith<$Res> get colors;
}

/// @nodoc
class _$AppThemeCopyWithImpl<$Res, $Val extends AppTheme>
    implements $AppThemeCopyWith<$Res> {
  _$AppThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? themeType = null, Object? colors = null}) {
    return _then(
      _value.copyWith(
            themeType: null == themeType
                ? _value.themeType
                : themeType // ignore: cast_nullable_to_non_nullable
                      as ThemeType,
            colors: null == colors
                ? _value.colors
                : colors // ignore: cast_nullable_to_non_nullable
                      as AppColors,
          )
          as $Val,
    );
  }

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppColorsCopyWith<$Res> get colors {
    return $AppColorsCopyWith<$Res>(_value.colors, (value) {
      return _then(_value.copyWith(colors: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppThemeImplCopyWith<$Res>
    implements $AppThemeCopyWith<$Res> {
  factory _$$AppThemeImplCopyWith(
    _$AppThemeImpl value,
    $Res Function(_$AppThemeImpl) then,
  ) = __$$AppThemeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ThemeType themeType, AppColors colors});

  @override
  $AppColorsCopyWith<$Res> get colors;
}

/// @nodoc
class __$$AppThemeImplCopyWithImpl<$Res>
    extends _$AppThemeCopyWithImpl<$Res, _$AppThemeImpl>
    implements _$$AppThemeImplCopyWith<$Res> {
  __$$AppThemeImplCopyWithImpl(
    _$AppThemeImpl _value,
    $Res Function(_$AppThemeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? themeType = null, Object? colors = null}) {
    return _then(
      _$AppThemeImpl(
        themeType: null == themeType
            ? _value.themeType
            : themeType // ignore: cast_nullable_to_non_nullable
                  as ThemeType,
        colors: null == colors
            ? _value.colors
            : colors // ignore: cast_nullable_to_non_nullable
                  as AppColors,
      ),
    );
  }
}

/// @nodoc

class _$AppThemeImpl implements _AppTheme {
  const _$AppThemeImpl({required this.themeType, required this.colors});

  @override
  final ThemeType themeType;
  @override
  final AppColors colors;

  @override
  String toString() {
    return 'AppTheme(themeType: $themeType, colors: $colors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppThemeImpl &&
            (identical(other.themeType, themeType) ||
                other.themeType == themeType) &&
            (identical(other.colors, colors) || other.colors == colors));
  }

  @override
  int get hashCode => Object.hash(runtimeType, themeType, colors);

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppThemeImplCopyWith<_$AppThemeImpl> get copyWith =>
      __$$AppThemeImplCopyWithImpl<_$AppThemeImpl>(this, _$identity);
}

abstract class _AppTheme implements AppTheme {
  const factory _AppTheme({
    required final ThemeType themeType,
    required final AppColors colors,
  }) = _$AppThemeImpl;

  @override
  ThemeType get themeType;
  @override
  AppColors get colors;

  /// Create a copy of AppTheme
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppThemeImplCopyWith<_$AppThemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
