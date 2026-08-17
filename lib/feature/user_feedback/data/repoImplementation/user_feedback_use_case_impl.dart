import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/core/extensions/logger_extension.dart';
import 'package:zenshield/feature/singbox/data/singbox_service.dart';
import 'package:zenshield/feature/user_feedback/data/model/log_environment.dart';
import 'package:zenshield/feature/user_feedback/domain/useCase/user_feedback_use_case.dart';

// ignore: unused-code
@Injectable(as: AbstractUserFeedbackUseCase)
class UserFeedbackUseCase implements AbstractUserFeedbackUseCase {
  UserFeedbackUseCase({
    required Talker logger,
    required Dio httpClient,
    required SingboxService singboxService,
    required DeviceInfoPlugin deviceInfo,
    required PackageInfo packageInfo,
  })  : _logger = logger,
        _httpClient = httpClient,
        _singboxService = singboxService,
        _deviceInfo = deviceInfo,
        _packageInfo = packageInfo;

  final Talker _logger;
  final Dio _httpClient;
  final SingboxService _singboxService;
  final DeviceInfoPlugin _deviceInfo;
  final PackageInfo _packageInfo;
  static final String uuid = const Uuid().v4();

  @override
  Future<void> sendUserFeedback({
    required String name,
    required String email,
    required String message,
  }) async {
    _logger.info('Try to send user feedback');
    final history = _logger.history;
    final data = history.toJsonString();
    final endpoint = Api.endpoints.pushLogs;

    final logEnvironment = await _prepareLogEnvironment(
      name: name,
      email: email,
      message: message,
    );

    final singboxLogs = await _singboxService.getActualLogs();

    final formData = FormData.fromMap({
      'log_environment': jsonEncode(logEnvironment.toJson()),
      'flutter_logs': MultipartFile.fromString(
        data,
        filename: 'logs.json',
        contentType: DioMediaType.parse('application/json'),
      ),
      'tunnel_logs': MultipartFile.fromString(
        singboxLogs,
        filename: 'tunnel_logs.json',
        contentType: DioMediaType.parse('application/json'),
      ),
    });

    await _httpClient.post<Map<String, dynamic>>(
      endpoint,
      data: formData,
    );

    _logger
      ..info('User feedback sent')
      ..cleanHistory()
      ..info('History cleaned');
  }

  Future<LogEnvironment> _prepareLogEnvironment({
    required String name,
    required String email,
    required String message,
  }) async {
    var deviceModel = '';
    var osVersion = '';
    var osType = '';
    final appVersion = _packageInfo.version;
    final buildNumber = _packageInfo.buildNumber;
    final offsetInMinutes = DateTime.now().timeZoneOffset.inMinutes;

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
      osVersion = androidInfo.version.release;
      osType = 'Android';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      deviceModel = iosInfo.utsname.machine;
      osVersion = iosInfo.systemVersion;
      osType = 'iOS';
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfo.macOsInfo;
      deviceModel = macInfo.model;
      osVersion = macInfo.osRelease;
      osType = 'macOS';
    } else if (Platform.isWindows) {
      final windowsInfo = await _deviceInfo.windowsInfo;
      deviceModel = windowsInfo.computerName;
      osVersion = windowsInfo.productName;
      osType = 'Windows';
    } else {
      osType = 'Unknown OS';
    }

    return LogEnvironment(
      sessionId: uuid,
      timeZoneOffsetInMinutes: offsetInMinutes.toDouble(),
      name: name,
      email: email,
      message: message,
      deviceModel: deviceModel,
      osVersion: osVersion,
      osType: osType,
      appVersion: appVersion,
      buildNumber: buildNumber,
    );
  }
}
