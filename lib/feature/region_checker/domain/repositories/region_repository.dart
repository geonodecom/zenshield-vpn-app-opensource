abstract class AbstractRegionService {
  Future<({String countryCode, String flagUrl})> getCountryCode(String ip);
}
