// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/activeStar.png
  AssetGenImage get activeStar =>
      const AssetGenImage('assets/images/activeStar.png');

  /// File path: assets/images/appLogo.png
  AssetGenImage get appLogo => const AssetGenImage('assets/images/appLogo.png');

  /// File path: assets/images/appUpdatedCloseIcon.png
  AssetGenImage get appUpdatedCloseIcon =>
      const AssetGenImage('assets/images/appUpdatedCloseIcon.png');

  /// File path: assets/images/apple.png
  AssetGenImage get apple => const AssetGenImage('assets/images/apple.png');

  /// File path: assets/images/arrow.png
  AssetGenImage get arrow => const AssetGenImage('assets/images/arrow.png');

  /// File path: assets/images/auth_logo.png
  AssetGenImage get authLogo =>
      const AssetGenImage('assets/images/auth_logo.png');

  /// File path: assets/images/backgroundImage.png
  AssetGenImage get backgroundImage =>
      const AssetGenImage('assets/images/backgroundImage.png');

  /// File path: assets/images/backgroundPatternDecorative.png
  AssetGenImage get backgroundPatternDecorative =>
      const AssetGenImage('assets/images/backgroundPatternDecorative.png');

  /// File path: assets/images/changedPassword.png
  AssetGenImage get changedPassword =>
      const AssetGenImage('assets/images/changedPassword.png');

  /// File path: assets/images/chechCircle.png
  AssetGenImage get chechCircle =>
      const AssetGenImage('assets/images/chechCircle.png');

  /// File path: assets/images/checkInbox.png
  AssetGenImage get checkInbox =>
      const AssetGenImage('assets/images/checkInbox.png');

  /// File path: assets/images/chevronLeft.png
  AssetGenImage get chevronLeft =>
      const AssetGenImage('assets/images/chevronLeft.png');

  /// File path: assets/images/chevron_right.png
  AssetGenImage get chevronRight =>
      const AssetGenImage('assets/images/chevron_right.png');

  /// File path: assets/images/email.png
  AssetGenImage get email => const AssetGenImage('assets/images/email.png');

  /// File path: assets/images/facebook.png
  AssetGenImage get facebook =>
      const AssetGenImage('assets/images/facebook.png');

  /// File path: assets/images/google.png
  AssetGenImage get google => const AssetGenImage('assets/images/google.png');

  /// File path: assets/images/inactiveStar.png
  AssetGenImage get inactiveStar =>
      const AssetGenImage('assets/images/inactiveStar.png');

  /// File path: assets/images/info-circle.png
  AssetGenImage get infoCircle =>
      const AssetGenImage('assets/images/info-circle.png');

  /// File path: assets/images/loadingIcon.png
  AssetGenImage get loadingIcon =>
      const AssetGenImage('assets/images/loadingIcon.png');

  /// File path: assets/images/loadingLogo.png
  AssetGenImage get loadingLogo =>
      const AssetGenImage('assets/images/loadingLogo.png');

  /// File path: assets/images/onboardingFirst.png
  AssetGenImage get onboardingFirst =>
      const AssetGenImage('assets/images/onboardingFirst.png');

  /// File path: assets/images/onboardingSecond.png
  AssetGenImage get onboardingSecond =>
      const AssetGenImage('assets/images/onboardingSecond.png');

  /// File path: assets/images/onboardingThird.png
  AssetGenImage get onboardingThird =>
      const AssetGenImage('assets/images/onboardingThird.png');

  /// File path: assets/images/password.png
  AssetGenImage get password =>
      const AssetGenImage('assets/images/password.png');

  /// File path: assets/images/planetColor.png
  AssetGenImage get planetColor =>
      const AssetGenImage('assets/images/planetColor.png');

  /// File path: assets/images/search.png
  AssetGenImage get search => const AssetGenImage('assets/images/search.png');

  /// File path: assets/images/settingsChevronRight.png
  AssetGenImage get settingsChevronRight =>
      const AssetGenImage('assets/images/settingsChevronRight.png');

  /// File path: assets/images/telegram.png
  AssetGenImage get telegram =>
      const AssetGenImage('assets/images/telegram.png');

  /// File path: assets/images/user.png
  AssetGenImage get user => const AssetGenImage('assets/images/user.png');

  /// File path: assets/images/userIcon.png
  AssetGenImage get userIcon =>
      const AssetGenImage('assets/images/userIcon.png');

  /// File path: assets/images/xIcon.png
  AssetGenImage get xIcon => const AssetGenImage('assets/images/xIcon.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    activeStar,
    appLogo,
    appUpdatedCloseIcon,
    apple,
    arrow,
    authLogo,
    backgroundImage,
    backgroundPatternDecorative,
    changedPassword,
    chechCircle,
    checkInbox,
    chevronLeft,
    chevronRight,
    email,
    facebook,
    google,
    inactiveStar,
    infoCircle,
    loadingIcon,
    loadingLogo,
    onboardingFirst,
    onboardingSecond,
    onboardingThird,
    password,
    planetColor,
    search,
    settingsChevronRight,
    telegram,
    user,
    userIcon,
    xIcon,
  ];
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/settings_config.json
  String get settingsConfig => 'assets/json/settings_config.json';

  /// List of all assets
  List<String> get values => [settingsConfig];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
