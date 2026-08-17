import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/singbox/data/singbox_service.dart';
import 'package:zenshield/feature/vpn_config/domain/repositories/vpn_config_repository.dart';
// ignore: implementation_imports
import 'package:dart_peer_repo/src/classes/singbox_monitor.dart';

/// Runs connectivity checks after VPN reports Connected and prints a single
/// filterable report. Search logs for `[VPN-DIAG]`.
class VpnConnectivityDiagnostics {
  VpnConnectivityDiagnostics({
    required Talker logger,
    required SingboxService singboxService,
    required AbstractVpnConfigRepository configRepository,
    required Preferences preferences,
  })  : _logger = logger,
        _singboxService = singboxService,
        _configRepository = configRepository,
        _preferences = preferences;

  static const tag = '[VPN-DIAG]';

  final Talker _logger;
  final SingboxService _singboxService;
  final AbstractVpnConfigRepository _configRepository;
  final Preferences _preferences;

  void _line(String message) => _logger.info('$tag $message');

  Future<void> run() async {
    _line('========== VPN connectivity report ==========');
    _line('platform=${Platform.operatingSystem} time=${DateTime.now().toIso8601String()}');

    final findings = <String>[];
    Map<String, dynamic>? config;
    String? primaryLink;

    try {
      config = await _configRepository.loadConfig();
      final links = (config['outboundsLinks'] as List?)?.cast<String>() ?? [];
      _line('outbound_links=${links.length}');
      _line('remote_dns=${config['remoteDns']} direct_dns=${config['directDns']}');
      _line(
        'socks_inbound=${config['socksInbound'] != null ? jsonEncode(config['socksInbound']) : 'none'}',
      );

      if (links.isEmpty) {
        findings.add('NO_OUTBOUND_LINKS');
        _line('FAIL no outbound server links in config — cannot proxy traffic');
      } else {
        primaryLink = links.first;
        _line('primary_outbound=${_sanitizeLink(primaryLink)}');
        for (var i = 0; i < links.length && i < 3; i++) {
          _line('outbound[$i]=${_sanitizeLink(links[i])}');
        }
        if (links.length > 3) {
          _line('... ${links.length - 3} more outbound(s) omitted');
        }
      }
    } catch (e, st) {
      findings.add('CONFIG_LOAD_FAILED');
      _line('FAIL could not load VPN config: $e');
      _logger.error('$tag config load stack', e, st);
    }

    try {
      final serverId = await _preferences.currentServerId;
      final protocol = await _preferences.currentProtocol;
      final zenSdk = await _preferences.zenSdkEnabled;
      _line(
        'selected_server=$serverId protocol=${protocol?.name ?? 'unknown'} zen_sdk_enabled=$zenSdk',
      );
    } catch (e) {
      _line('WARN could not read preferences: $e');
    }

    final socksReady = await SingboxMonitor().isSocks5Ready(
      timeout: const Duration(seconds: 3),
    );
    _line('local_socks_10801=${socksReady ? 'REACHABLE' : 'NOT_REACHABLE'}');
    if (!socksReady) {
      findings.add('LOCAL_SOCKS_DOWN');
    }

    await _checkDns(findings);
    await _checkHttp(findings);

    if (primaryLink != null) {
      await _checkOutbound(primaryLink, findings);
    }

    await _checkSingboxLogs();
    await _checkSingboxStderr(findings);

    _line('--- likely causes (most specific first) ---');
    if (findings.isEmpty) {
      _line('ALL_CHECKS_PASSED — tunnel may work; issue could be app-specific or intermittent');
    } else {
      for (final f in findings) {
        _line(_describeFinding(f));
      }
    }
    _line('========== end VPN connectivity report ==========');
  }

  Future<void> _checkDns(List<String> findings) async {
    for (final host in const ['google.com', 'cloudflare.com']) {
      try {
        final sw = Stopwatch()..start();
        final result = await InternetAddress.lookup(host).timeout(
          const Duration(seconds: 8),
        );
        sw.stop();
        final ips = result.map((a) => a.address).join(', ');
        _line('dns_lookup $host OK (${sw.elapsedMilliseconds}ms) -> $ips');
      } catch (e) {
        findings.add('DNS_LOOKUP_FAILED');
        _line('dns_lookup $host FAIL -> $e');
      }
    }
  }

  Future<void> _checkHttp(List<String> findings) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final sw = Stopwatch()..start();
      final request = await client.getUrl(
        Uri.parse('https://www.google.com/generate_204'),
      );
      final response = await request.close().timeout(const Duration(seconds: 10));
      await response.drain<void>();
      sw.stop();
      _line(
        'http_probe generate_204 status=${response.statusCode} (${sw.elapsedMilliseconds}ms)',
      );
      if (response.statusCode != 204 && response.statusCode != 200) {
        findings.add('HTTP_PROBE_BAD_STATUS');
      }
    } catch (e) {
      findings.add('HTTP_PROBE_FAILED');
      _line('http_probe generate_204 FAIL -> $e');
    } finally {
      client.close(force: true);
    }
  }

  Future<void> _checkOutbound(String link, List<String> findings) async {
    try {
      final sw = Stopwatch()..start();
      await _singboxService.testLink(link);
      sw.stop();
      _line(
        'outbound_test_link OK (${sw.elapsedMilliseconds}ms) host=${await _hostFromLink(link)}',
      );
    } catch (e) {
      findings.add('VPN_SERVER_UNREACHABLE');
      _line('outbound_test_link FAIL host=${await _hostFromLink(link)} -> $e');
      _line('HINT server-side or bad outbound credentials — not a local TUN routing issue');
    }

    try {
      final linksJson = jsonEncode([link]);
      final map = await _singboxService.getLinksOutboundsMap(linksJson);
      if (map.isEmpty) {
        _line('outbound_parse WARN empty outbounds map from sing-box');
      } else {
        _line('outbound_parse keys=${map.keys.join(', ')}');
      }
    } catch (e) {
      _line('outbound_parse FAIL -> $e');
    }
  }

  Future<void> _checkSingboxStderr(List<String> findings) async {
    if (!Platform.isAndroid) return;
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        _line('singbox_stderr=<external storage unavailable>');
        return;
      }
      final file = File('${dir.path}/stderr.log');
      if (!await file.exists()) {
        _line('singbox_stderr=<no stderr.log at ${dir.path}>');
        return;
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        _line('singbox_stderr=<empty>');
        return;
      }
      final lines = content.split('\n');
      final tail = lines.length > 20 ? lines.sublist(lines.length - 20) : lines;
      _line('singbox_stderr (last ${tail.length} lines):');
      for (final line in tail) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;
        _line('  $trimmed');
        if (trimmed.contains('no available outbound found')) {
          findings.add('NO_AVAILABLE_OUTBOUND');
        }
      }
    } catch (e) {
      _line('singbox_stderr FAIL -> $e');
    }
  }

  Future<void> _checkSingboxLogs() async {
    try {
      final logs = await _singboxService.getActualLogs();
      if (logs.trim().isEmpty) {
        _line('singbox_logs=<empty or command socket unavailable>');
        return;
      }
      final lines = logs.split('\n');
      final tail = lines.length > 40 ? lines.sublist(lines.length - 40) : lines;
      _line('singbox_logs (last ${tail.length} lines):');
      for (final line in tail) {
        if (line.trim().isNotEmpty) _line('  $line');
      }
    } catch (e) {
      _line('singbox_logs FAIL -> $e');
    }
  }

  Future<String> _hostFromLink(String link) async {
    try {
      final uri = Uri.parse(link);
      if (uri.host.isNotEmpty) {
        return uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
      }
    } catch (_) {}
    return 'unknown';
  }

  static String _sanitizeLink(String link) {
    try {
      final uri = Uri.parse(link);
      final scheme = uri.scheme;
      if (scheme == 'vless' || scheme == 'trojan' || scheme == 'ss') {
        final port = uri.hasPort ? uri.port : '';
        final portSuffix = port == '' ? '' : ':$port';
        return '$scheme://***@${uri.host}$portSuffix';
      }
      if (scheme == 'vmess') {
        return 'vmess://*** (${link.length} chars)';
      }
      return '$scheme://*** (${link.length} chars)';
    } catch (_) {
      return '<unparseable ${link.length} chars>';
    }
  }

  static String _describeFinding(String code) {
    switch (code) {
      case 'NO_OUTBOUND_LINKS':
        return 'NO_OUTBOUND_LINKS — server list empty; API did not return usable links';
      case 'CONFIG_LOAD_FAILED':
        return 'CONFIG_LOAD_FAILED — could not build sing-box config';
      case 'LOCAL_SOCKS_DOWN':
        return 'LOCAL_SOCKS_DOWN — 127.0.0.1:10801 not up (smart mode / peer SDK / sing-box inbound)';
      case 'DNS_LOOKUP_FAILED':
        return 'DNS_LOOKUP_FAILED — DNS through VPN tunnel is broken (routing/DNS config)';
      case 'HTTP_PROBE_FAILED':
        return 'HTTP_PROBE_FAILED — TCP/HTTPS through tunnel failed (routing or all servers down)';
      case 'HTTP_PROBE_BAD_STATUS':
        return 'HTTP_PROBE_BAD_STATUS — HTTP responded but not 204/200';
      case 'VPN_SERVER_UNREACHABLE':
        return 'VPN_SERVER_UNREACHABLE — sing-box testLink failed; likely server/credentials/firewall';
      case 'NO_AVAILABLE_OUTBOUND':
        return 'NO_AVAILABLE_OUTBOUND — sing-box has zero healthy VPN servers; browser traffic cannot be proxied (backend/server issue)';
      default:
        return code;
    }
  }
}
