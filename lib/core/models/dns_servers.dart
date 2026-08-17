import 'package:collection/collection.dart';

enum DnsServers { google, cloudflare, openDns, cleanBrowsing, quad }

extension DnsServerExtension on DnsServers {
  String get name {
    switch (this) {
      case DnsServers.google:
        return 'Google';
      case DnsServers.cloudflare:
        return 'Cloudflare';
      case DnsServers.openDns:
        return 'Cisco OpenDNS';
      case DnsServers.cleanBrowsing:
        return 'CleanBrowsing';
      case DnsServers.quad:
        return 'Quad9';
    }
  }

  String get ip {
    switch (this) {
      case DnsServers.google:
        return '8.8.8.8';
      case DnsServers.cloudflare:
        return '1.1.1.1';
      case DnsServers.openDns:
        return '208.67.222.222';
      case DnsServers.cleanBrowsing:
        return '185.228.168.168';
      case DnsServers.quad:
        return '9.9.9.9';
    }
  }

  String get dohUrl {
    switch (this) {
      case DnsServers.google:
        return 'https://dns.google/dns-query';
      case DnsServers.cloudflare:
        return 'https://cloudflare-dns.com/dns-query';
      case DnsServers.openDns:
        return 'https://doh.opendns.com/dns-query';
      case DnsServers.cleanBrowsing:
        return 'https://doh.cleanbrowsing.org/doh/security-filter/';
      case DnsServers.quad:
        return 'https://dns.quad9.net/dns-query';
    }
  }

  String get key => toString().split('.').last;

  static DnsServers? fromKey(String key) {
    return DnsServers.values.firstWhereOrNull(
      (server) => server.key == key,
    );
  }
}
