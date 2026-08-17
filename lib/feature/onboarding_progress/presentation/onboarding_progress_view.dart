import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/feature/agreements/data/model/agreements_response.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/core/widgets/web_view.dart';
import 'package:zenshield/core/widgets/bandwidth_policy_markdown.dart';
import 'package:zenshield/core/widgets/black_circular_progress_indicator.dart';
import 'package:zenshield/feature/onboarding_progress/presentation/onboarding_progress_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:zenshield/feature/onboarding_progress/presentation/onboarding_progress_side_effect.dart';
import 'package:zenshield/feature/geonode_key_setup/presentation/geonode_key_setup_view.dart';
import 'package:zenshield/feature/home/presentation/home_view.dart';
import 'package:zenshield/feature/auth/presentation/auth_view.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:talker_flutter/talker_flutter.dart';

class OnboardingProgressView extends StatelessWidget {
  const OnboardingProgressView({super.key});

  static const routeName = '/onboarding_progress';

  @override
  Widget build(BuildContext context) {
    final initialAgreementsResponse =
        ModalRoute.of(context)?.settings.arguments as AgreementsResponse?;
    return BlocProvider(
      create: (context) => OnboardingProgressBloc(
        agreementUseCase: getIt<AbstractAgreementUseCase>(),
        analyticsManager: getIt<AbstractAnalyticsManager>(),
        logger: getIt<Talker>(),
        authUseCase: getIt<AbstractAuthUserUseCase>(),
        vpnManager: getIt<AbstractVpnManager>(),
        preferences: getIt<Preferences>(),
        initialAgreementsResponse: initialAgreementsResponse,
      ),
      child:
          BlocSideEffectListener<
            OnboardingProgressBloc,
            OnboardingProgressSideEffect
          >(
            listener: (context, sideEffect) async {
              switch (sideEffect) {
                case NavigateToHome():
                  await Navigator.of(
                    context,
                  ).pushReplacementNamed(HomeView.routeName);
                case NavigateToGeonodeKeySetup():
                  await Navigator.of(
                    context,
                  ).pushReplacementNamed(GeonodeKeySetupView.routeName);
                case NavigateToAuth():
                  await Navigator.of(
                    context,
                  ).pushReplacementNamed(AuthView.routeName);
              }
            },
            child: const OnboardingProgressContent(),
          ),
    );
  }
}

class OnboardingProgressContent extends StatefulWidget {
  const OnboardingProgressContent({super.key});

  @override
  OnboardingProgressState createState() => OnboardingProgressState();
}

class OnboardingProgressState extends State<OnboardingProgressContent> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showBandwidthSharingModal(BuildContext context) {
    final appColors = AppColors();
    final bloc = context.read<OnboardingProgressBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: appColors.black.withValues(alpha: 0.6),
      builder: (context) => BandwidthSharingModal(
        onAgree: () {
          Navigator.of(context).pop();
          bloc.add(ModalAgreeButtonTappedEvent());
        },
        onDisagree: () {
          Navigator.of(context).pop();
          bloc.add(BandwidthSharingDeclinedEvent());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final bloc = context.watch<OnboardingProgressBloc>();
    final blocState = bloc.state;
    final showOnlyBandwidthSharingPolicy =
        blocState.showOnlyBandwidthSharingPolicy;
    final l10n = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    const totalPages = 3;
    final lastPage = totalPages - 1;

    const baseBottomOffset = 40;

    final lastPageReduction =
        (_currentPage == lastPage || showOnlyBandwidthSharingPolicy)
        ? 20.0
        : 0.0;
    final bottomPadding = (baseBottomOffset - lastPageReduction).clamp(
      0.0,
      double.infinity,
    );

    return Scaffold(
      backgroundColor: appColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: showOnlyBandwidthSharingPolicy
                    ? PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _OnboardingPage3(currentPage: 2, showDots: false),
                        ],
                      )
                    : PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          _OnboardingPage1(
                            currentPage: _currentPage,
                            screenHeight: screenHeight,
                            totalPages: totalPages,
                          ),
                          _OnboardingPage2(
                            currentPage: _currentPage,
                            screenHeight: screenHeight,
                            totalPages: totalPages,
                          ),
                          _OnboardingPage3(
                            currentPage: _currentPage,
                            showDots: true,
                          ),
                        ],
                      ),
              ),
              SizedBox(
                height: (!showOnlyBandwidthSharingPolicy && _currentPage == 0)
                    ? 45
                    : 47,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height:
                          (!showOnlyBandwidthSharingPolicy && _currentPage == 0)
                          ? 70
                          : 52,
                      width:
                          (!showOnlyBandwidthSharingPolicy && _currentPage == 0)
                          ? 70
                          : null,
                      child: Center(
                        child: AnimatedButtonTransition(
                          isCircular:
                              !showOnlyBandwidthSharingPolicy &&
                              _currentPage == 0,
                          onTap:
                              !showOnlyBandwidthSharingPolicy &&
                                  _currentPage == 0
                              ? () {
                                  _pageController.animateToPage(
                                    1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : () {
                                  if (!showOnlyBandwidthSharingPolicy &&
                                      _currentPage < lastPage) {
                                    _pageController.animateToPage(
                                      _currentPage + 1,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    final state = bloc.state;
                                    if (!state.isSendingConsent) {
                                      bloc.add(FinalNextButtonTappedEvent());
                                    }
                                  }
                                },
                          buttonTitle:
                              l10n?.buttonAgreeAndContinue ?? 'wrong title',
                          color: appColors.black,
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      layoutBuilder:
                          (
                            Widget? currentChild,
                            List<Widget> previousChildren,
                          ) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                if (currentChild != null)
                                  SizedBox(
                                    width: double.infinity,
                                    child: currentChild,
                                  ),
                                ...previousChildren.map(
                                  (child) => Positioned(
                                    left: 0,
                                    right: 0,
                                    child: child,
                                  ),
                                ),
                              ],
                            );
                          },
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0, -0.05),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: child,
                              ),
                            );
                          },
                      child:
                          (_currentPage == 2 || showOnlyBandwidthSharingPolicy)
                          ? Column(
                              key: const ValueKey('i_disagree'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    _showBandwidthSharingModal(context);
                                  },
                                  child: Text(
                                    l10n?.buttonIDisagree ?? 'wrong title',
                                    textAlign: TextAlign.center,
                                    style: appTextStyles
                                        .interRegular14(
                                          color: appColors.black.withValues(
                                            alpha: 0.5,
                                          ),
                                        )
                                        .copyWith(fontSize: 13),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(key: ValueKey('empty')),
                    ),
                    SizedBox(
                      height:
                          (_currentPage == 2 || showOnlyBandwidthSharingPolicy)
                          ? 0
                          : 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1({
    required this.currentPage,
    required this.screenHeight,
    required this.totalPages,
  });

  final int currentPage;
  final double screenHeight;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: PlatformUtils.isDesktop ? 0 : 16,
      ),
      child: Column(
        children: [
          Assets.images.onboardingFirst.image(
            height: ResponsiveValue<double>(
              context,
              defaultValue: 360,
              conditionalValues: [
                if (screenHeight <= 700)
                  const Condition.equals(name: MOBILE, value: 260),
              ],
            ).value,
          ),
          PlatformUtils.isDesktop ? SizedBox(height: 70) : SizedBox(height: 40),

          PlatformUtils.isDesktop ? SizedBox.shrink() : Spacer(),
          //const SizedBox(height: 22),
          Text(
            l10n?.onboardingPage1Title ?? 'wrong title',
            textAlign: TextAlign.center,
            style: appTextStyles
                .helveticaNeueBold24(color: appColors.black)
                .copyWith(fontSize: 22),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              Platform.isIOS
                  ? (l10n?.onboardingPage1TextIos ?? 'wrong title')
                  : (l10n?.onboardingPage1Text ?? 'wrong title'),
              textAlign: TextAlign.center,
              style: appTextStyles
                  .interMedium14(color: appColors.grayLight)
                  .copyWith(fontSize: 13),
            ),
          ),
          const SizedBox(height: 30),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (index) => OnboardingDot(index: index, currentPage: currentPage),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2({
    required this.currentPage,
    required this.screenHeight,
    required this.totalPages,
  });

  final int currentPage;
  final double screenHeight;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    final eula = l10n?.onboardingPage2Eula ?? 'wrong title';
    final privacyPolicy = l10n?.onboardingPage2PrivacyPolicy ?? 'wrong title';
    final bandwidthSharingPolicy =
        l10n?.onboardingPage2BandwidthSharingPolicy ?? 'wrong title';
    final text =
        l10n?.onboardingPage2TextAndroid(
          eula,
          privacyPolicy,
          bandwidthSharingPolicy,
        ) ??
        'wrong title';

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Spacer(),
              const SizedBox(height: 0),
              FittedBox(
                child: Assets.images.onboardingSecond.image(height: 360),
              ),

              SizedBox(height: PlatformUtils.isDesktop ? 60 : 80),
              Text(
                l10n?.onboardingPage2Title ?? 'wrong title',
                textAlign: TextAlign.center,
                style: appTextStyles
                    .helveticaNeueBold24(color: appColors.black)
                    .copyWith(fontSize: 23),
              ),
              SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9),
                child: _buildFormattedText(
                  context,
                  text,
                  eula,
                  privacyPolicy,
                  appTextStyles,
                  appColors,
                  bandwidthSharingPolicy: bandwidthSharingPolicy,
                ),
              ),
              SizedBox(height: 10),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  totalPages,
                  (index) =>
                      OnboardingDot(index: index, currentPage: currentPage),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        if (Platform.isIOS)
          Positioned(top: 10, right: 6, child: _LogoutButton()),
      ],
    );
  }

  Widget _buildFormattedText(
    BuildContext context,
    String fullText,
    String eula,
    String privacyPolicy,
    AppTextStyles appTextStyles,
    AppColors appColors, {
    String? bandwidthSharingPolicy,
  }) {
    final baseStyle = appTextStyles
        .interRegular14(color: appColors.grayLight)
        .copyWith(fontSize: 13);
    final linkStyle = appTextStyles
        .interRegular14(color: appColors.grayLight)
        .copyWith(decoration: TextDecoration.underline, fontSize: 13);

    final links = [
      (
        label: eula,
        onTap: () {
          final lang = Localizations.localeOf(context).languageCode;
          if (PlatformUtils.isDesktop) {
            context.read<OnboardingProgressBloc>().add(OpenEulaEvent(lang));
          } else {
            showCupertinoModalBottomSheet<void>(
              enableDrag: false,
              backgroundColor: appColors.background,
              context: context,
              builder: (context) => FractionallySizedBox(
                heightFactor: 0.85,
                child: WebView(
                  url: Urls.endUserLicenseAgreement(languageCode: lang),
                ),
              ),
            );
          }
        },
      ),
      (
        label: privacyPolicy,
        onTap: () {
          final lang = Localizations.localeOf(context).languageCode;
          if (PlatformUtils.isDesktop) {
            context.read<OnboardingProgressBloc>().add(
              OpenPrivacyPolicyEvent(lang),
            );
          } else {
            showCupertinoModalBottomSheet<void>(
              enableDrag: false,
              backgroundColor: appColors.background,
              context: context,
              builder: (context) => FractionallySizedBox(
                heightFactor: 0.85,
                child: WebView(url: Urls.privacyPolicy(languageCode: lang)),
              ),
            );
          }
        },
      ),
      if (bandwidthSharingPolicy != null)
        (
          label: bandwidthSharingPolicy,
          onTap: () {
            final lang = Localizations.localeOf(context).languageCode;
            if (PlatformUtils.isDesktop) {
              context.read<OnboardingProgressBloc>().add(
                OpenBandwidthSharingPolicyEvent(lang),
              );
            } else {
              showCupertinoModalBottomSheet<void>(
                enableDrag: false,
                backgroundColor: appColors.background,
                context: context,
                builder: (context) => FractionallySizedBox(
                  heightFactor: 0.85,
                  child: WebView(
                    url: Urls.bandwidthSharingPolicy(languageCode: lang),
                  ),
                ),
              );
            }
          },
        ),
    ];

    final spans = <TextSpan>[];
    int lastIndex = 0;

    for (final link in links) {
      final index = fullText.indexOf(link.label, lastIndex);
      if (index == -1) continue;

      if (index > lastIndex) {
        spans.add(
          TextSpan(
            text: fullText.substring(lastIndex, index),
            style: baseStyle,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: link.label,
          style: linkStyle,
          recognizer: TapGestureRecognizer()..onTap = link.onTap,
        ),
      );

      lastIndex = index + link.label.length;
    }

    if (lastIndex < fullText.length) {
      spans.add(
        TextSpan(text: fullText.substring(lastIndex), style: baseStyle),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}

class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3({required this.currentPage, this.showDots = true});

  final int currentPage;
  final bool showDots;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);
    final bloc = context.watch<OnboardingProgressBloc>();
    final state = bloc.state;

    final title = l10n?.onboardingPage3Title ?? 'wrong title';
    final textWithoutPolicy = l10n?.onboardingPage3Text ?? '';

    final policyUrl = Urls.bandwidthSharingPolicy(
      languageCode: Localizations.localeOf(context).languageCode,
    ).toString();

    final agreementText = state.currentAgreement?.text;

    const baseTopOffset = 21.0; // 8 (vertical padding) + 13 (SizedBox)
    final safeTop = MediaQuery.of(context).padding.top;
    final topPadding = (baseTopOffset - safeTop).clamp(0.0, double.infinity);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: topPadding,
            bottom: 8,
          ),
          child: Column(
            children: [
              Assets.images.onboardingThird.image(width: 114, height: 105),
              const SizedBox(height: 0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: appTextStyles
                    .helveticaNeueBold24(color: appColors.black)
                    .copyWith(fontSize: 22),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  textWithoutPolicy,
                  style: appTextStyles
                      .interRegular14(color: appColors.grayLight)
                      .copyWith(fontSize: 13, height: 16.5 / 13),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: state.isLoadingAgreements
                      ? const Center(child: BlackCircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _PolicyContent(
                                url: policyUrl,
                                htmlContent: agreementText,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              if (showDots) ...[
                const SizedBox(height: 19),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) =>
                        OnboardingDot(index: index, currentPage: currentPage),
                  ),
                ),
                const SizedBox(height: 1),
              ],
            ],
          ),
        ),
        Positioned(top: 10, right: 6, child: _LogoutButton()),
      ],
    );
  }
}

class _PolicyContent extends StatefulWidget {
  const _PolicyContent({required this.url, this.htmlContent});

  final String url;
  final String? htmlContent;

  @override
  State<_PolicyContent> createState() => _PolicyContentState();
}

class _PolicyContentState extends State<_PolicyContent> {
  @override
  Widget build(BuildContext context) {
    return BandwidthPolicyMarkdown(content: widget.htmlContent);
  }
}

class OnboardingDot extends StatelessWidget {
  const OnboardingDot({
    required this.index,
    required this.currentPage,
    super.key,
  });

  final int index;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 7,
      width: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == currentPage
            ? appColors.black
            : appColors.black.withValues(alpha: 0.3),
      ),
    );
  }
}

class AnimatedButtonTransition extends StatelessWidget {
  const AnimatedButtonTransition({
    required this.isCircular,
    required this.onTap,
    required this.buttonTitle,
    required this.color,
    super.key,
  });

  final bool isCircular;
  final VoidCallback onTap;
  final String buttonTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            width: isCircular ? 76 : maxWidth,
            height: isCircular ? 76 : 57,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(isCircular ? 38 : 29),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: isCircular
                    ? Assets.images.arrow.image(
                        key: const ValueKey('arrow'),
                        width: 16,
                        height: 16,
                      )
                    : Text(
                        buttonTitle,
                        key: ValueKey(buttonTitle),
                        style: appTextStyles
                            .nunitoSansBold18(color: appColors.white)
                            .copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BandwidthSharingModal extends StatelessWidget {
  const BandwidthSharingModal({
    required this.onAgree,
    required this.onDisagree,
    super.key,
  });

  final VoidCallback onAgree;
  final VoidCallback onDisagree;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            20,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 350,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        l10n?.bandwidthSharingModalTitle ??
                            'Bandwidth Sharing Required',
                        textAlign: TextAlign.center,
                        style: appTextStyles
                            .interBold16(color: appColors.black)
                            .copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 20),
                      // Text paragraphs
                      Text(
                        l10n?.bandwidthSharingModalText1 ??
                            'You must agree to bandwidth sharing...',
                        textAlign: TextAlign.center,
                        style: appTextStyles
                            .interRegular14Alt(color: appColors.grayLight)
                            .copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.bandwidthSharingModalText2 ??
                            'Zenshield stays free because...',
                        textAlign: TextAlign.center,
                        style: appTextStyles
                            .interRegular14Alt(color: appColors.grayLight)
                            .copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.bandwidthSharingModalText3 ??
                            'This shared bandwidth helps...',
                        textAlign: TextAlign.center,
                        style: appTextStyles
                            .interRegular14Alt(color: appColors.grayLight)
                            .copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.bandwidthSharingModalText4 ??
                            'Your personal data and browsing...',
                        textAlign: TextAlign.center,
                        style: appTextStyles
                            .interRegular14Alt(color: appColors.grayLight)
                            .copyWith(fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'Bandwidth Sharing Policy',
                          textAlign: TextAlign.center,
                          style: appTextStyles
                              .interRegular14Alt(color: appColors.grayLight)
                              .copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: appColors.grayLight,
                              ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Agree button
                      SizedBox(
                        width: double.infinity,
                        height: 57,
                        child: ElevatedButton(
                          onPressed: onAgree,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(29),
                            ),
                            elevation: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n?.bandwidthSharingModalButtonAgree ??
                                    'I Agree',
                                style: appTextStyles.nunitoSansBold18(
                                  color: appColors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n?.bandwidthSharingModalButtonSubtext ??
                                    'Allow app to use idle resources...',
                                style: appTextStyles.interRegular10(
                                  color: appColors.white.withAlpha(100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Not now button
                      GestureDetector(
                        onTap: onDisagree,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            l10n?.bandwidthSharingModalButtonNotNow ??
                                'Not now',
                            textAlign: TextAlign.center,
                            style: appTextStyles.interMedium14(
                              color: appColors.grayLight,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<OnboardingProgressBloc>();

    return GestureDetector(
      onTap: () {
        bloc.add(const LogoutTappedEvent());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          l10n?.settingsLogOut ?? 'Log out',
          style: appTextStyles.interRegular14(color: appColors.grayLight),
        ),
      ),
    );
  }
}
