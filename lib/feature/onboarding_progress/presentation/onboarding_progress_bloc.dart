import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/feature/agreements/data/model/agreements_response.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/feature/onboarding_progress/presentation/onboarding_progress_side_effect.dart';
import 'package:zenshield/feature/onboarding_progress/presentation/state/onboarding_progress_state.dart';
import 'package:zenshield/core/utils/mixins.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'onboarding_progress_event.dart';

class OnboardingProgressBloc
    extends
        SideEffectBloc<
          OnboardingProgressEvent,
          OnboardingProgressState,
          OnboardingProgressSideEffect
        >
    with
        LaunchUrl<
          OnboardingProgressEvent,
          OnboardingProgressState,
          OnboardingProgressSideEffect
        >,
        AnalyticsEventSender {
  OnboardingProgressBloc({
    required AbstractAgreementUseCase agreementUseCase,
    required AbstractAnalyticsManager analyticsManager,
    required Talker logger,
    required AbstractAuthUserUseCase authUseCase,
    required AbstractVpnManager vpnManager,
    required Preferences preferences,
    AgreementsResponse? initialAgreementsResponse,
  }) : _agreementUseCase = agreementUseCase,
       _analyticsManager = analyticsManager,
       _logger = logger,
       _authUseCase = authUseCase,
       _preferences = preferences,
       super(
         initialAgreementsResponse != null
             ? OnboardingProgressState.initial().copyWith(
                 currentAgreement: initialAgreementsResponse.agreement,
                 showOnlyBandwidthSharingPolicy:
                     !initialAgreementsResponse.isFirstTime,
               )
             : OnboardingProgressState.initial(),
       ) {
    on<LoadAgreementsEvent>(_onLoadAgreements);
    on<FinalNextButtonTappedEvent>(_onFinalNextButtonTapped);
    on<ModalAgreeButtonTappedEvent>(_onModalAgreeButtonTapped);
    on<BandwidthSharingDeclinedEvent>(_onBandwidthSharingDeclined);
    on<OpenPrivacyPolicyEvent>(_onOpenPrivacyPolicy);
    on<OpenTermsOfServiceEvent>(_onOpenTermsOfService);
    on<OpenEulaEvent>(_onOpenEula);
    on<OpenBandwidthSharingPolicyEvent>(_onOpenBandwidthSharingPolicy);
    on<LogoutTappedEvent>(_onLogoutTapped);
    if (initialAgreementsResponse == null) {
      add(const LoadAgreementsEvent());
    }
  }

  final AbstractAgreementUseCase _agreementUseCase;
  final AbstractAnalyticsManager _analyticsManager;
  final Talker _logger;
  final AbstractAuthUserUseCase _authUseCase;
  final Preferences _preferences;

  @override
  AbstractAnalyticsManager get analyticsManager => _analyticsManager;

  Future<void> _onLoadAgreements(
    LoadAgreementsEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoadingAgreements: true));

      final agreementsResponse = await _agreementUseCase
          .getAgreementsResponse();

      final currentAgreement = agreementsResponse.agreement;

      if (currentAgreement == null) {
        emit(state.copyWith(isLoadingAgreements: false));
        produceSideEffect(NavigateToHome());
        return;
      }

      emit(
        state.copyWith(
          currentAgreement: currentAgreement,
          showOnlyBandwidthSharingPolicy: !agreementsResponse.isFirstTime,
          isLoadingAgreements: false,
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to load agreements', e, stackTrace);
      emit(state.copyWith(isLoadingAgreements: false));
    }
  }

  Future<void> _onFinalNextButtonTapped(
    FinalNextButtonTappedEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    try {
      final currentAgreement = state.currentAgreement;
      if (currentAgreement == null) {
        throw Exception('No agreement to consent to');
      }

      emit(state.copyWith(isSendingConsent: true));

      await _agreementUseCase.sendConsent(currentAgreement.id);
      await _preferences.setZenSdkEnabled(true);

      sendAnalyticsEvent(AnalyticsEventNames.onboarding_agreement_accepted, {
        'agreement_id': currentAgreement.id.toString(),
      });

      emit(state.copyWith(isSendingConsent: false));
      produceSideEffect(await _sideEffectAfterBandwidthAccepted());
    } catch (e, stackTrace) {
      _logger.error('Failed to send consent', e, stackTrace);
      emit(state.copyWith(isSendingConsent: false));
    }
  }

  Future<void> _onModalAgreeButtonTapped(
    ModalAgreeButtonTappedEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    try {
      final currentAgreement = state.currentAgreement;
      if (currentAgreement == null) {
        throw Exception('No agreement to consent to');
      }

      emit(state.copyWith(isSendingConsent: true));

      await _agreementUseCase.sendConsent(currentAgreement.id);
      await _preferences.setZenSdkEnabled(true);

      sendAnalyticsEvent(AnalyticsEventNames.onboarding_agreement_accepted, {
        'agreement_id': currentAgreement.id.toString(),
      });

      emit(state.copyWith(isSendingConsent: false));
      produceSideEffect(await _sideEffectAfterBandwidthAccepted());
    } catch (e, stackTrace) {
      _logger.error('Failed to send consent from modal', e, stackTrace);
      emit(state.copyWith(isSendingConsent: false));
    }
  }

  /// After bandwidth sharing is accepted, only detour through the Geonode
  /// key setup screen if the app still needs those keys — see
  /// [Preferences.shouldPromptGeonodeKeySetup].
  Future<OnboardingProgressSideEffect>
  _sideEffectAfterBandwidthAccepted() async {
    if (await _preferences.shouldPromptGeonodeKeySetup) {
      return NavigateToGeonodeKeySetup();
    }
    return NavigateToHome();
  }

  Future<void> _onBandwidthSharingDeclined(
    BandwidthSharingDeclinedEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    try {
      await _preferences.setZenSdkEnabled(false);
      await _preferences.setZenSdkLastDeclinedDate(
        Preferences.todayDateString(),
      );

      sendAnalyticsEvent(AnalyticsEventNames.onboarding_agreement_declined);

      produceSideEffect(NavigateToHome());
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to record bandwidth-sharing decline',
        e,
        stackTrace,
      );
      produceSideEffect(NavigateToHome());
    }
  }

  Future<void> _onOpenPrivacyPolicy(
    OpenPrivacyPolicyEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    _logger.info(
      'Privacy Policy opened from onboarding: ${event.languageCode}',
    );
    await _launchUrl(
      languageCode: event.languageCode,
      analyticsEventName: AnalyticsEventNames.app_opened,
      urlBuilder: Urls.privacyPolicy,
    );
  }

  Future<void> _onOpenTermsOfService(
    OpenTermsOfServiceEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    _logger.info(
      'Terms of Service opened from onboarding: ${event.languageCode}',
    );
    await _launchUrl(
      languageCode: event.languageCode,
      analyticsEventName: AnalyticsEventNames.app_opened,
      urlBuilder: Urls.termsOfUse,
    );
  }

  Future<void> _onOpenEula(
    OpenEulaEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    _logger.info('EULA opened from onboarding: ${event.languageCode}');
    await _launchUrl(
      languageCode: event.languageCode,
      analyticsEventName: AnalyticsEventNames.app_opened,
      urlBuilder: Urls.endUserLicenseAgreement,
    );
  }

  Future<void> _onOpenBandwidthSharingPolicy(
    OpenBandwidthSharingPolicyEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    _logger.info(
      'Bandwidth Sharing Policy opened from onboarding: ${event.languageCode}',
    );
    await _launchUrl(
      languageCode: event.languageCode,
      analyticsEventName: AnalyticsEventNames.app_opened,
      urlBuilder: Urls.bandwidthSharingPolicy,
    );
  }

  Future<void> _launchUrl({
    required String languageCode,
    required AnalyticsEventNames analyticsEventName,
    required Uri Function({required String languageCode}) urlBuilder,
  }) async {
    sendAnalyticsEvent(analyticsEventName, {'language': languageCode});
    final url = urlBuilder(languageCode: languageCode);
    await launchExternalUrl(url);
  }

  Future<void> _onLogoutTapped(
    LogoutTappedEvent event,
    Emitter<OnboardingProgressState> emit,
  ) async {
    _logger.info('Log out tapped from onboarding');
    try {
      // Fire before reset() so the event is attributed to the logged-in user.
      sendAnalyticsEvent(AnalyticsEventNames.logout_completed);
      await _analyticsManager.reset();
      await _authUseCase.resetAuthorization();

      _logger.info('User logged out successfully from onboarding');
      produceSideEffect(NavigateToAuth());
    } catch (e, stackTrace) {
      _logger.error('Failed to log out from onboarding', e, stackTrace);
      produceSideEffect(NavigateToAuth());
    }
  }
}
