import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/feature/user_info/data/model/user_info.dart';
import 'package:zenshield/feature/user_info/domain/useCase/user_info_use_case.dart';

@Injectable(as: AbstractUserInfoUseCase)
class UserInfoUseCase implements AbstractUserInfoUseCase {
  UserInfoUseCase(
    this._httpClient,
    this._logger,
  );

  final Dio _httpClient;
  final Talker _logger;

  @override
  Future<UserInfo> getUserInfo() async {
    const maxRetries = 3;
    const retryDelay = Duration(milliseconds: 500);
    final endpoint = Api.endpoints.getUserInfo;

    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        _logger.info('Attempt $attempt to get user info');

        final response = await _httpClient.get<Map<String, dynamic>>(
          endpoint,
        );

        _logger.info('Successfully got user info');
        _logger.info('User info response data: ${response.data}');
        final userInfo = UserInfo.fromJson(response.data!);
        _logger
            .info('Parsed user info, securedSince: ${userInfo.securedSince}');
        return userInfo;
      } on DioException catch (e) {
        if (e.type != DioExceptionType.unknown &&
            e.type != DioExceptionType.connectionError) {
          _logger.error(e);
          rethrow;
        }
        _logger.error(e);
        if (attempt == maxRetries) {
          _logger.error('All attempts to get user info have failed', e);
        } else {
          await Future<void>.delayed(retryDelay);
        }
      }
    }

    throw Exception('Failed to get user info after $maxRetries attempts');
  }
}
