import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/core/services/device_info_provider.dart';
import 'package:zenshield/feature/app_version/data/model/app_version_request.dart';
import 'package:zenshield/feature/app_version/domain/useCase/app_version_use_case.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';

@Injectable(as: AbstractAppVersionUseCase)
class AppVersionUseCase implements AbstractAppVersionUseCase {
  AppVersionUseCase({
    required Dio httpClient,
    required PackageInfo packageInfo,
    required Talker logger,
    required AbstractDeviceInfoProvider deviceInfoProvider,
    required AbstractAuthUserUseCase authUserUseCase,
  })  : _httpClient = httpClient,
        _packageInfo = packageInfo,
        _logger = logger,
        _deviceInfoProvider = deviceInfoProvider,
        _authUserUseCase = authUserUseCase;

  final Dio _httpClient;
  final PackageInfo _packageInfo;
  final Talker _logger;
  final AbstractDeviceInfoProvider _deviceInfoProvider;
  final AbstractAuthUserUseCase _authUserUseCase;

  @override
  Future<void> sendAppVersion() async {
    try {
      final isAuthorized = await _authUserUseCase.isAuthorized();

      if (!isAuthorized) {
        _logger.info('User not initialized, skipping app version send');
        return;
      }

      _logger.info('Sending app version info');

      final request = await _prepareAppVersionRequest();

      final endpoint = Api.endpoints.appVersion;

      await _httpClient.post<void>(
        endpoint,
        data: request.toJson(),
      );

      _logger.info('App version info sent successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to send app version info', e, stackTrace);
      rethrow;
    }
  }

  Future<AppVersionRequest> _prepareAppVersionRequest() async {
    final hwid = await _deviceInfoProvider.getHwid();
    final deviceOs = await _deviceInfoProvider.getDeviceOs();
    final versionOs = await _deviceInfoProvider.getOsVersion();
    final deviceModel = await _deviceInfoProvider.getDeviceModel();
    final appVersion = _packageInfo.version;

    return AppVersionRequest(
      hwid: hwid,
      deviceOs: deviceOs,
      versionOs: versionOs,
      deviceModel: deviceModel,
      appVersion: appVersion,
    );
  }
}
