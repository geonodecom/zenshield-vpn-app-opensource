import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:zenshield/config/constants/secure_storage_keys.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/services/device_info_provider.dart';
import 'package:zenshield/feature/agreements/data/model/agreements_response.dart';
import 'package:zenshield/feature/agreements/data/model/consent_metadata.dart';
import 'package:zenshield/feature/agreements/data/model/consent_request.dart';
import 'package:zenshield/feature/agreements/domain/repositories/agreement_repository.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/feature/user_info/domain/useCase/user_info_use_case.dart';

@Injectable(as: AbstractAgreementUseCase)
class AgreementUseCase implements AbstractAgreementUseCase {
  AgreementUseCase({
    required AbstractAgreementRepository agreementRepository,
    required FlutterSecureStorage secureStorage,
    required DeviceInfoPlugin deviceInfo,
    required PackageInfo packageInfo,
    required Talker logger,
    required AbstractUserInfoUseCase userInfoUseCase,
    required AbstractDeviceInfoProvider deviceInfoProvider,
    required Preferences preferences,
  }) : _agreementRepository = agreementRepository,
       _secureStorage = secureStorage,
       _deviceInfo = deviceInfo,
       _packageInfo = packageInfo,
       _logger = logger,
       _userInfoUseCase = userInfoUseCase,
       _deviceInfoProvider = deviceInfoProvider,
       _preferences = preferences,
       _uuid = const Uuid();

  final AbstractAgreementRepository _agreementRepository;
  final FlutterSecureStorage _secureStorage;
  // ignore: unused_field
  final DeviceInfoPlugin _deviceInfo;
  final PackageInfo _packageInfo;
  final Talker _logger;
  final AbstractUserInfoUseCase _userInfoUseCase;
  final AbstractDeviceInfoProvider _deviceInfoProvider;
  final Preferences _preferences;
  // ignore: unused_field
  final Uuid _uuid;

  @override
  Future<bool> hasPendingAgreements() async {
    try {
      final agreementsResponse = await getAgreementsResponse();
      return agreementsResponse.agreement != null;
    } catch (e, stackTrace) {
      _logger.error('Error checking pending agreements', e, stackTrace);
      return false;
    }
  }

  @override
  Future<AgreementsResponse> getAgreementsResponse() async {
    final userId = await _getUserId();
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final deviceId = await _getDeviceId();
    final agreementsResponse = await _agreementRepository.getAgreements(
      userId: userId,
      deviceId: deviceId,
    );

    if (agreementsResponse.agreement != null) {
      await _preferences.setBandwidthSharingPolicy(
        agreementsResponse.agreement!.text,
      );
    }

    return agreementsResponse;
  }

  @override
  Future<void> sendConsent(int agreementId) async {
    final userId = await _getUserId();
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final userInfo = await _userInfoUseCase.getUserInfo();
    final deviceId = await _getDeviceId();
    final metadata = await _prepareConsentMetadata(ip: userInfo.ip);

    final consentRequest = ConsentRequest(
      externalId: userId,
      userId: userId,
      deviceId: deviceId,
      agreementId: agreementId,
      metadata: metadata,
    );

    await _agreementRepository.sendConsent(consentRequest);
  }

  Future<String?> _getUserId() async {
    return await _secureStorage.read(key: SecureStorageKeys.userId);
  }

  Future<String> _getDeviceId() async {
    return _deviceInfoProvider.getHwid();
  }

  Future<ConsentMetadata> _prepareConsentMetadata({required String ip}) async {
    return ConsentMetadata(
      os: (await _deviceInfoProvider.getDeviceOs()).toLowerCase(),
      arch: await _deviceInfoProvider.getArchitecture(),
      osVersion: await _deviceInfoProvider.getOsVersion(),
      model: await _deviceInfoProvider.getDeviceModel(),
      systemLocale: Platform.localeName.isNotEmpty ? Platform.localeName : null,
      appVersion: _packageInfo.version,
      appBuild: _packageInfo.buildNumber,
      ip: ip,
    );
  }

  @override
  Future<String?> getCurrentBandwidthSharingPolicy() async {
    return await _preferences.bandwidthSharingPolicy;
  }
}
