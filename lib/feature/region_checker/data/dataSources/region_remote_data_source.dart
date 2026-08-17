import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/feature/region_checker/data/model/region_response.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class AbstractRegionRemoteDataSource {
  Future<RegionResponse?> getRegion(String ip);
}

// ignore: unused-code
@Injectable(as: AbstractRegionRemoteDataSource)
class RegionRemoteDataSource implements AbstractRegionRemoteDataSource {
  const RegionRemoteDataSource({
    required Talker logger,
    required Dio httpClient,
  })  : _logger = logger,
        _httpClient = httpClient;

  final Talker _logger;
  final Dio _httpClient;

  @override
  Future<RegionResponse?> getRegion(String ip) async {
    final endpoint = Api.endpoints.getUserInfoRegion;

    final response = await _httpClient.get<dynamic>(
      endpoint,
      queryParameters: {
        'ip': ip,
      },
    );

    _logger.debug('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return RegionResponse.fromJson(response.data as Map<String, dynamic>);
    }

    _logger.warning('Non-200 response for IP $ip: ${response.statusCode}');
    return null;
  }
}
