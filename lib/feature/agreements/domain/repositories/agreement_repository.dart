import 'package:zenshield/feature/agreements/data/model/agreements_response.dart';
import 'package:zenshield/feature/agreements/data/model/consent_request.dart';

abstract class AbstractAgreementRepository {
  Future<AgreementsResponse> getAgreements({
    required String userId,
    required String deviceId,
  });

  Future<void> sendConsent(ConsentRequest request);
}
