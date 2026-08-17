import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/feature/agreements/data/model/agreement.dart';
import 'package:zenshield/feature/about/presentation/about_side_effect.dart';
import 'package:zenshield/feature/about/presentation/state/about_state.dart';
import 'package:zenshield/core/utils/mixins.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'about_event.dart';

class AboutBloc extends SideEffectBloc<AboutEvent, AboutState, AboutSideEffect>
    with
        LaunchUrl<AboutEvent, AboutState, AboutSideEffect>,
        AnalyticsEventSender {
  AboutBloc({
    required Talker logger,
    required AbstractAnalyticsManager analyticsManager,
    required AbstractAgreementUseCase agreementUseCase,
  }) : _logger = logger,
       _analyticsManager = analyticsManager,
       _agreementUseCase = agreementUseCase,
       super(AboutState.initial()) {
    on<InitialLoadEvent>(_onInitialLoad);
    on<OpenPrivacyPolicyEvent>(_onOpenPrivacyPolicy);
    on<OpenTermsOfServiceEvent>(_onOpenTermsOfService);
    on<OpenBandwidthSharingPolicyEvent>(_onOpenBandwidthSharingPolicy);
    on<OpenEulaEvent>(_onOpenEula);
    on<OpenEmailEvent>(_onOpenEmail);
    on<VersionTappedEvent>(_onVersionTapped);
    add(const InitialLoadEvent());
  }

  final Talker _logger;
  final AbstractAnalyticsManager _analyticsManager;
  final AbstractAgreementUseCase _agreementUseCase;

  @override
  AbstractAnalyticsManager get analyticsManager => _analyticsManager;

  Future<void> _onInitialLoad(
    InitialLoadEvent event,
    Emitter<AboutState> emit,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    final appVersion = 'v$version (build $buildNumber)';

    emit(state.copyWith(appVersion: appVersion));
  }

  Future<void> _onOpenPrivacyPolicy(
    OpenPrivacyPolicyEvent event,
    Emitter<AboutState> emit,
  ) async {
    _logger.info('Privacy Policy opened: ${event.languageCode}');
    await _launchUrl(
      languageCode: event.languageCode,
      analyticsEventName: AnalyticsEventNames.about_privacy_policy_tapped,
      urlBuilder: Urls.privacyPolicy,
    );
  }

  Future<void> _onOpenTermsOfService(
    OpenTermsOfServiceEvent event,
    Emitter<AboutState> emit,
  ) async {
    _logger.info('Terms of Service opened: ${event.languageCode}');
    await _launchUrl(
      languageCode: event.languageCode,
      analyticsEventName: AnalyticsEventNames.about_terms_of_service_tapped,
      urlBuilder: Urls.termsOfUse,
    );
  }

  Future<void> _onOpenBandwidthSharingPolicy(
    OpenBandwidthSharingPolicyEvent event,
    Emitter<AboutState> emit,
  ) async {
    _logger.info('Bandwidth Sharing Policy opened: ${event.languageCode}');
    sendAnalyticsEvent(
      AnalyticsEventNames.about_bandwidth_sharing_policy_tapped,
      {'language': event.languageCode},
    );

    try {
      emit(state.copyWith(isLoadingAgreement: true));

      final savedAgreement = await _agreementUseCase
          .getCurrentBandwidthSharingPolicy();

      final currentAgreement = Agreement(
        id: 0,
        text: savedAgreement ?? "",
        createdAt: "createdAt",
      );

      emit(state.copyWith(isLoadingAgreement: false));

      produceSideEffect(
        ShowBandwidthSharingPolicyPage(
          htmlContent: currentAgreement.text.isNotEmpty
              ? currentAgreement.text
              : null,
          fallbackUrl: currentAgreement.text.isEmpty
              ? Urls.bandwidthSharingPolicy(languageCode: event.languageCode)
              : null,
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to load agreement', e, stackTrace);
      emit(state.copyWith(isLoadingAgreement: false));
      produceSideEffect(
        ShowBandwidthSharingPolicyPage(
          fallbackUrl: Urls.bandwidthSharingPolicy(
            languageCode: event.languageCode,
          ),
        ),
      );
    }
  }

  Future<void> _onOpenEula(
    OpenEulaEvent event,
    Emitter<AboutState> emit,
  ) async {
    final url = Urls.endUserLicenseAgreement(languageCode: event.languageCode);
    _logger.info('EULA opened: $url');
    sendAnalyticsEvent(AnalyticsEventNames.about_email_tapped, {
      'language': event.languageCode,
    });
    await launchExternalUrl(url);
  }

  Future<void> _onOpenEmail(
    OpenEmailEvent event,
    Emitter<AboutState> emit,
  ) async {
    _logger.info('Email opened: ${Urls.supportEmail}');
    sendAnalyticsEvent(AnalyticsEventNames.support_email_tapped);
    await launchExternalUrl(Uri.parse('mailto:${Urls.supportEmail}'));
  }

  Future<void> _launchUrl({
    required String languageCode,
    required AnalyticsEventNames analyticsEventName,
    required Uri Function({required String languageCode}) urlBuilder,
  }) async {
    _logger.info('URL launch with language code: $languageCode');
    sendAnalyticsEvent(analyticsEventName, {'language': languageCode});

    final url = urlBuilder(languageCode: languageCode);
    await launchExternalUrl(url);
  }

  void _onVersionTapped(VersionTappedEvent event, Emitter<AboutState> emit) {
    final newCount = state.versionTapCount + 1;
    emit(state.copyWith(versionTapCount: newCount));

    if (newCount >= 5) {
      produceSideEffect(NavigateToLogsSideEffect());
      emit(state.copyWith(versionTapCount: 0));
    }
  }
}
