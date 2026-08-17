import 'package:zenshield/feature/agreements/data/model/agreements_response.dart';

abstract class AbstractAgreementUseCase {
  Future<bool> hasPendingAgreements();

  Future<AgreementsResponse> getAgreementsResponse();

  Future<void> sendConsent(int agreementId);

  Future<String?> getCurrentBandwidthSharingPolicy();
}
