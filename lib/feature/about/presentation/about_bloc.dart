import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/feature/about/presentation/about_side_effect.dart';
import 'package:zenshield/feature/about/presentation/state/about_state.dart';
import 'package:zenshield/core/utils/mixins.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'about_event.dart';

class AboutBloc extends SideEffectBloc<AboutEvent, AboutState, AboutSideEffect>
    with LaunchUrl<AboutEvent, AboutState, AboutSideEffect> {
  AboutBloc({required Talker logger})
    : _logger = logger,
      super(AboutState.initial()) {
    on<InitialLoadEvent>(_onInitialLoad);
    on<OpenPrivacyPolicyEvent>(_onOpenPrivacyPolicy);
    on<OpenTermsOfServiceEvent>(_onOpenTermsOfService);
    on<OpenEulaEvent>(_onOpenEula);
    on<OpenEmailEvent>(_onOpenEmail);
    on<VersionTappedEvent>(_onVersionTapped);
    add(const InitialLoadEvent());
  }

  final Talker _logger;

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
      urlBuilder: Urls.termsOfUse,
    );
  }

  Future<void> _onOpenEula(
    OpenEulaEvent event,
    Emitter<AboutState> emit,
  ) async {
    final url = Urls.endUserLicenseAgreement(languageCode: event.languageCode);
    _logger.info('EULA opened: $url');
    await launchExternalUrl(url);
  }

  Future<void> _onOpenEmail(
    OpenEmailEvent event,
    Emitter<AboutState> emit,
  ) async {
    _logger.info('Email opened: ${Urls.supportEmail}');
    await launchExternalUrl(Uri.parse('mailto:${Urls.supportEmail}'));
  }

  Future<void> _launchUrl({
    required String languageCode,
    required Uri Function({required String languageCode}) urlBuilder,
  }) async {
    _logger.info('URL launch with language code: $languageCode');

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
