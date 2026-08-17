import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';

// ignore: unused-code
@Injectable(as: AbstractServersRepository)
class ServersRepository implements AbstractServersRepository {
  ServersRepository({
    required Dio httpClient,
    required Preferences preferences,
    required Talker logger,
  })  : _httpClient = httpClient,
        _preferences = preferences,
        _logger = logger;

  static List<SystemVpnConfiguration> _preloadSystemConfigs = [];

  final Dio _httpClient;
  final Preferences _preferences;

  final Talker _logger;

  @override
  Future<VpnConfiguration?> prepare() async {
    _logger.info('Try to prefetch servers');

    await getServers(force: true);
    final selectedServer = await getSelectedServer();

    _logger.info('Servers prefetched');
    return selectedServer;
  }

  @override
  Future<List<VpnConfiguration>> getServers({required bool force}) async {
    _logger.info('[VPN] Try to get VPN servers');

    final servers = await _getSystemConfigs(force: force);

    _logger.info('[VPN] Got ${servers.length} VPN servers');
    return servers;
  }

  Future<List<SystemVpnConfiguration>> _getSystemConfigs({
    required bool force,
  }) async {
    if (_preloadSystemConfigs.isNotEmpty && !force) {
      _logger.info('Servers already preloaded');
      return _preloadSystemConfigs;
    }

    try {
      _logger.info('Try to get system configs');

      final endpoint = Api.endpoints.vpnConfigurations;
      final response = await _httpClient.get<List<dynamic>>(
        endpoint,
        queryParameters: {'locale': 'en'},
      );

      final configurations = response.data
          ?.map((e) {
            final json = e as Map<String, dynamic>;
            return VpnConfiguration.fromJson(json);
          })
          .whereType<SystemVpnConfiguration>()
          .toList();

      _logger.info('Got system configs');

      if (configurations == null) {
        _logger.warning('Configurations are null');
        return [];
      }

      await _preferences.setCachedSystemServersList(configurations);
      _logger.info('New system configs cached');

      _preloadSystemConfigs = configurations;

      return configurations;
    } on Exception catch (e) {
      _logger.error('Failed to fetch actual system configs', e);
      final cachedSystemConfigs = await _preferences.cachedSystemServersList;
      return cachedSystemConfigs;
    }
  }

  @override
  Future<VpnConfiguration> getServerById(String ip) async {
    _logger.info('[VPN] Searching for VPN server with ID: $ip');
    final servers = await getServers(force: false);
    final serverById = IterableExtension(servers)
        .firstWhereOrNull((server) => server.ip == ip);
    if (serverById == null) {
      _logger.info('Server with ID: $ip not found');
      return servers.first;
    }

    _logger.info('Server with ID: $ip found, server: $serverById');

    return serverById;
  }

  @override
  Future<VpnConfiguration?> getSelectedServer() async {
    _logger.info('Try to get current server');
    final currentServerId = await _preferences.currentServerId;

    if (currentServerId == null) {
      _logger.info('Current server not found, try to get default server');
      final servers = await getServers(force: false);
      if (servers.isNotEmpty) {
        final firstFreeServer = servers.firstWhere(
          (server) => (server as SystemVpnConfiguration).isFree,
        );
        _logger.info(
          'Default server found, first server: $firstFreeServer',
        );
        return firstFreeServer;
      }
      return null;
    }

    return getServerById(currentServerId);
  }
}
