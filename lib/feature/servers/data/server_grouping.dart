import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';

class ServerGrouping {
  ServerGrouping._();

  static Map<String, List<VpnConfiguration>> groupByCountry(
    List<VpnConfiguration> servers,
  ) {
    final grouped = <String, List<VpnConfiguration>>{};

    for (final server in servers) {
      if (!grouped.containsKey(server.region.countryCode)) {
        grouped[server.region.countryCode] = [];
      }
      grouped[server.region.countryCode]?.add(server);
    }

    return grouped;
  }

  static Map<String, List<VpnConfiguration>> groupByCountryAndCity(
    List<VpnConfiguration> servers,
  ) {
    final grouped = <String, List<VpnConfiguration>>{};

    for (final server in servers) {
      final city = server is SystemVpnConfiguration ? server.city : '';
      final key = _countryCityKey(
        server.region.countryCode,
        city,
      );
      grouped.putIfAbsent(key, () => []).add(server);
    }

    return grouped;
  }

  static String _countryCityKey(String countryCode, String city) {
    final nCountry = countryCode.trim().toUpperCase();
    final nCity = city.trim().toLowerCase();
    return '$nCountry|$nCity';
  }

  static ({String countryCode, String city}) parseCountryCityKey(String key) {
    final parts = key.split('|');
    return (
      countryCode: parts.first,
      city: parts.length > 1 ? parts.sublist(1).join('|') : '',
    );
  }
}
