import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/config/constants/secure_storage_keys.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/core/utils/utils.dart';
import 'package:zenshield/feature/vpn_config/data/model/zenshield_vpn_config.dart';
import 'package:zenshield/feature/vpn_config/domain/repositories/vpn_config_repository.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

// ignore: unused-code
@Injectable(as: AbstractVpnConfigRepository)
class VpnConfigRepository extends AbstractVpnConfigRepository {
  VpnConfigRepository(
    this._serversRepository,
    this._preferences,
    this._secureStorage,
    this._logger,
  );

  final AbstractServersRepository _serversRepository;
  final Preferences _preferences;
  final FlutterSecureStorage _secureStorage;
  final Talker _logger;
  final _uuid = const Uuid();

  static const String _configPath = 'assets/json/settings_config.json';

  @override
  Future<Map<String, dynamic>> loadConfig() async {
    try {
      _logger.info('[VPN] Loading VPN config...');

      String clashApiToken;

      try {
        final token =
            await _secureStorage.read(key: SecureStorageKeys.clashApiToken);
        if (token == null) {
          throw Exception();
        }
        clashApiToken = token;
      } catch (_) {
        final token = _uuid.v4();
        await _secureStorage.write(
          key: SecureStorageKeys.clashApiToken,
          value: token,
        );
        clashApiToken = token;
      }

      int clashApiPort;

      try {
        final port =
            await _secureStorage.read(key: SecureStorageKeys.clashApiPort);
        if (port == null) {
          throw Exception();
        }
        clashApiPort = int.parse(port);
      } catch (_) {
        const port = 16756;
        await _secureStorage.write(
          key: SecureStorageKeys.clashApiPort,
          value: port.toString(),
        );
        clashApiPort = port;
      }

      final (
        jsonString,
        outboundLinks,
      ) = await (
        rootBundle.loadString(_configPath),
        _prepareServers(),
      ).wait;

      _logger.info('[VPN] Loaded JSON base config and all dependencies');

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final baseConfig = ZenshieldConfig.fromJson(json);

      final config = baseConfig.copyWith(
        logLevel: 'debug',
        outboundsLinks: outboundLinks,
        clashApiToken: clashApiToken,
        clashApiPort: clashApiPort,
        isMobile: !PlatformUtils.isDesktop,
      );

      final configJson = config.toJson();

      _logger.info('[VPN] Final VPN config built successfully', configJson);
      return configJson;
    } catch (e, st) {
      _logger.error('[VPN] Failed to load VPN config', e, st);
      throw Exception('Failed to load config: $e');
    }
  }

  Future<List<String>> _prepareServers() async {
    try {
      _logger.info('[VPN] Preparing ordered outbound server list...');
      final servers = await _serversRepository.getServers(force: false);
      final currentServersId = await _preferences.currentServerId;
      final currentServer = servers.firstWhere((s) => s.ip == currentServersId);

      final currentSelectedProtocol = await _preferences.currentProtocol;
      final protocolPrefix = Utils.getProtocolPrefix(currentSelectedProtocol);

      // When the user explicitly picked a server, routing must stay inside
      // that server's country: the tunnel's urltest group routes through
      // whichever outbound it likes among the links we hand it, so pinning
      // is enforced by only handing it same-country links. In auto mode all
      // servers are included and urltest picks the best exit globally.
      final pinned = await _preferences.serverSelectionPinned;
      final pinnedCountry = currentServer.region.countryCode;
      final pool = pinned
          ? servers.where((s) => s.region.countryCode == pinnedCountry)
          : servers;

      final otherServers = pool.where((s) => s.ip != currentServersId);

      final currentLink = currentServer is! UserVpnConfiguration
          ? currentServer.configurations
              .where((e) => e.url.startsWith(protocolPrefix))
              .map((e) => e.url)
          : currentServer.configurations.map((e) => e.url);

      final otherLinks = otherServers
          .expand((e) => e.configurations)
          .where((e) => e.url.startsWith(protocolPrefix))
          .map((e) => e.url);

      final orderedLinks = [
        ...currentLink,
        ...otherLinks,
      ];

      _logger.info(
        '[VPN] Prepared ${orderedLinks.length} '
        'total outbound links for protocol $protocolPrefix'
        '${pinned ? ' (pinned to country=$pinnedCountry)' : ''}',
      );
      return orderedLinks;
    } catch (e, st) {
      _logger.error('[VPN] Error while preparing server links', e, st);
      rethrow;
    }
  }
}
