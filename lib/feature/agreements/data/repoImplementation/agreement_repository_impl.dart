import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/feature/agreements/data/model/agreements_response.dart';
import 'package:zenshield/feature/agreements/data/model/consent_request.dart';
import 'package:zenshield/feature/agreements/domain/repositories/agreement_repository.dart';

@Injectable(as: AbstractAgreementRepository)
class AgreementRepository implements AbstractAgreementRepository {
  AgreementRepository(
    this._httpClient,
    this._logger,
  );

  final Dio _httpClient;
  final Talker _logger;

  @override
  Future<AgreementsResponse> getAgreements({
    required String userId,
    required String deviceId,
  }) async {
    try {
      _logger
          .info('Fetching agreements for userId: $userId, deviceId: $deviceId');

      final endpoint = Api.endpoints.agreements;

      final httpResponse = await _httpClient.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: {
          'userId': userId,
          'deviceId': deviceId,
        },
      );

      final data = httpResponse.data;
      if (data == null) {
        throw Exception('Empty response data');
      }

      final agreementsResponse = AgreementsResponse.fromJson(data);
      _logger.info(
          'Fetched agreements response - isFirstTime: ${agreementsResponse.isFirstTime}, agreement: ${agreementsResponse.agreement?.id}');
      return agreementsResponse;
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch agreements', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> sendConsent(ConsentRequest request) async {
    try {
      _logger.info('Sending consent for agreementId: ${request.agreementId}');

      final endpoint = Api.endpoints.consents;

      await _httpClient.post<Map<String, dynamic>>(
        endpoint,
        data: request.toJson(),
      );

      _logger.info('Consent sent successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to send consent', e, stackTrace);
      rethrow;
    }
  }
}
