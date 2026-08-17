import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/feature/region_checker/data/dataSources/region_remote_data_source.dart';
import 'package:zenshield/feature/region_checker/domain/repositories/region_repository.dart';

// ignore: unused-code
@Injectable(as: AbstractRegionService)
class RegionService implements AbstractRegionService {
  const RegionService({
    required Talker logger,
    required AbstractRegionRemoteDataSource remoteDataSource,
  })  : _logger = logger,
        _remoteDataSource = remoteDataSource;

  final Talker _logger;
  final AbstractRegionRemoteDataSource _remoteDataSource;

  @override
  Future<({String countryCode, String flagUrl})> getCountryCode(
    String ip,
  ) async {
    _logger.info('Request to get country code for IP: $ip');

    try {
      final region = await _remoteDataSource.getRegion(ip);

      if (region != null) {
        _logger.info('Country code for IP $ip: ${region.countryCode}');

        return (
          countryCode: region.countryCode,
          flagUrl: region.flagImage,
        );
      } else {
        return (countryCode: 'Unknown', flagUrl: 'Unknown');
      }
    } catch (e, stack) {
      _logger.error(
        'Exception while requesting country code for IP $ip',
        e,
        stack,
      );
      return (countryCode: 'Unknown', flagUrl: 'Unknown');
    }
  }
}
