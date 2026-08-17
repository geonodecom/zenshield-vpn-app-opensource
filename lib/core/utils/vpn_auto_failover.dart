import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/config/constants/secure_storage_keys.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';
import 'package:zenshield/feature/vpn_config/domain/repositories/vpn_config_repository.dart';

/// Runs *after* the tunnel reports Connected and verifies that real traffic
/// actually flows through the currently-selected outbound. If it does not, it
/// walks the candidate server list, tests each one through the tunnel, and
/// switches the sing-box selector to the first server that genuinely works.
///
/// Why this exists: sing-box's own `urltest` can pick a server that completes a
/// light probe (e.g. `generate_204`) but whose exit cannot actually carry real
/// browsing traffic — the tunnel reports Connected yet pages time out. The app
/// itself is `selfExcluded` from the tunnel, so a plain `HttpClient` probe would
/// test the *direct* connection, not the tunnel. We therefore drive the probes
/// through sing-box's local Clash API (`127.0.0.1:<port>`), which makes sing-box
/// dial the target *through* the chosen outbound — an honest end-to-end check.
///
/// When the user explicitly pinned a country, failover is restricted to
/// servers in that *same country* — switching a user from e.g. Canada to
/// Australia without asking breaks anything that depends on the exit region
/// (region-locked content, expected latency) and is a worse surprise than the
/// original "connected but no traffic" bug. If every same-country candidate is
/// unhealthy, we leave the current selection rather than cross into another
/// country silently.
///
/// When the user never pinned a country (auto-select connect), the current
/// country was never a deliberate choice — it's just whatever the client
/// happened to land on first — so there is nothing to "stay loyal to". In
/// that case failover searches *all* candidates regardless of country, so an
/// auto-selected dead country doesn't strand the user on a broken tunnel.
///
/// Search logs for `[VPN-FAILOVER]`.
class VpnAutoFailover {
  VpnAutoFailover({
    required Talker logger,
    required AbstractVpnConfigRepository configRepository,
    required Preferences preferences,
    required FlutterSecureStorage secureStorage,
    required AbstractServersRepository serversRepository,
  })  : _logger = logger,
        _configRepository = configRepository,
        _preferences = preferences,
        _secureStorage = secureStorage,
        _serversRepository = serversRepository;

  static const tag = '[VPN-FAILOVER]';

  /// The routing selector defined in the sing-box config. Pinning it to a
  /// concrete outbound is what actually redirects traffic.
  static const _selector = 'mainSelector';

  /// The urltest group the selector auto-mode points at.
  static const _urlTest = 'mainUrlTest';

  /// Diverse targets so a single well-peered host (Google/Cloudflare anycast is
  /// often reachable even from a degraded exit) cannot make a broken server
  /// look healthy. An outbound must reach at least [_minHealthyProbes] of them.
  static const _probeUrls = <String>[
    'https://www.gstatic.com/generate_204',
    'https://www.bing.com/',
    'https://duckduckgo.com/',
  ];
  static const _minHealthyProbes = 2;
  static const _probeTimeout = Duration(seconds: 5);

  /// Absolute ceiling on how many alternative servers we try before giving
  /// up, so a large server list (dozens/hundreds of servers) can never turn
  /// into a very long stall. The actual per-run limit is
  /// `min(candidates.length, _maxSwitchesCeiling)` — with a small server
  /// pool (e.g. 9 servers total) this lets every candidate be tried instead
  /// of silently giving up partway through a pool this ceiling was never
  /// meant to bound.
  static const _maxSwitchesCeiling = 6;

  /// Time to let a freshly-selected outbound settle before re-probing.
  static const _settleDelay = Duration(milliseconds: 800);

  final Talker _logger;
  final AbstractVpnConfigRepository _configRepository;
  final Preferences _preferences;
  final FlutterSecureStorage _secureStorage;
  final AbstractServersRepository _serversRepository;

  void _line(String message) => _logger.info('$tag $message');

  /// [shouldContinue] is polled between steps; it must return `false` once the
  /// tunnel is no longer connected or the user has taken over server selection,
  /// so failover never fights a manual switch or a disconnect.
  ///
  /// Returns the host (server IP) that is *actually* routing traffic when it
  /// finishes — resolved from sing-box's live selector, not from what the UI
  /// thinks — so the caller can sync the displayed server to reality, plus
  /// whether the tunnel is verified to carry real traffic: `healthy` is true
  /// when a probe succeeded (current or switched-to server), false when every
  /// candidate failed, and null when the check couldn't run to a conclusion
  /// (aborted, credentials missing, error). `serversTried` counts alternative
  /// servers probed during this run, and `currentServerFailed` is true when
  /// the user's selected server failed its health probe — even if traffic was
  /// rescued through another exit (both for failure analytics).
  Future<
      ({
        String? activeHost,
        bool? healthy,
        int serversTried,
        bool currentServerFailed,
      })> run({
    required bool Function() shouldContinue,
    required bool pinned,
  }) async {
    var switches = 0;
    var currentFailed = false;
    try {
      final (token, port) = await _clashCredentials();
      if (token == null || port == null) {
        _line('skip — clash api token/port unavailable');
        return (
          activeHost: null,
          healthy: null,
          serversTried: switches,
          currentServerFailed: currentFailed,
        );
      }

      final candidates = await _loadCandidates();
      if (candidates.isEmpty) {
        _line('skip — no candidate outbounds in config');
        return (
          activeHost: null,
          healthy: null,
          serversTried: switches,
          currentServerFailed: currentFailed,
        );
      }

      final currentId = await _preferences.currentServerId;
      final hostCountry = await _hostCountryMap();
      final currentCountry = hostCountry[currentId];
      _line(
        'starting — current_server=$currentId country=${currentCountry ?? "unknown"} candidates=${candidates.length}',
      );

      // 1) Is the server we're already on actually carrying traffic?
      _Candidate? current;
      for (final c in candidates) {
        if (c.host == currentId) {
          current = c;
          break;
        }
      }

      if (current != null) {
        if (!shouldContinue()) {
          _line('aborted before initial probe (no longer connected)');
          return (
          activeHost: null,
          healthy: null,
          serversTried: switches,
          currentServerFailed: currentFailed,
        );
        }
        final healthy = await _isOutboundHealthy(current.tag, token, port);
        if (healthy) {
          _line('current server ${current.host} healthy — no failover needed');
          return (
            activeHost: await _resolveActiveHost(token, port, candidates),
            healthy: true,
            serversTried: switches,
            currentServerFailed: currentFailed,
          );
        }
        currentFailed = true;
        _line(
          'current server ${current.host} FAILED health check — searching for a working server',
        );
      } else {
        _line(
          'current server not found in candidates — searching from top of list',
        );
      }

      // 2) Walk candidates and switch to the first that works. When the user
      // pinned a country, stay inside it — crossing without asking is a
      // worse surprise than staying on a degraded server. When the country
      // was only auto-selected (never pinned), there is no user choice to
      // respect, so search every candidate to avoid stranding the user on an
      // auto-picked dead country.
      final searchPool = pinned
          ? (currentCountry == null
              ? const <_Candidate>[]
              : candidates
                  .where((c) =>
                      c.host != currentId &&
                      hostCountry[c.host] == currentCountry)
                  .toList())
          : candidates.where((c) => c.host != currentId).toList();

      if (pinned && currentCountry == null) {
        _line('skip cross-server search — current server country unknown');
      } else if (pinned && searchPool.isEmpty) {
        _line(
          'no other candidate in country=$currentCountry — not crossing to another country',
        );
      } else if (!pinned) {
        _line(
          'not pinned to a country — searching all ${searchPool.length} candidates',
        );
      }

      final maxSwitches = min(searchPool.length, _maxSwitchesCeiling);
      for (final candidate in searchPool) {
        if (switches >= maxSwitches) {
          _line('reached max switch attempts ($maxSwitches) — stopping');
          break;
        }
        if (!shouldContinue()) {
          _line('aborted mid-failover (disconnected or manual switch)');
          return (
          activeHost: null,
          healthy: null,
          serversTried: switches,
          currentServerFailed: currentFailed,
        );
        }

        switches++;
        _line('trying server ${candidate.host} ($switches/$maxSwitches)...');

        final selected = await _selectOutbound(candidate.tag, token, port);
        if (!selected) {
          _line('  could not select ${candidate.host} — skipping');
          continue;
        }
        await Future<void>.delayed(_settleDelay);

        if (!shouldContinue()) {
          _line('aborted after selecting ${candidate.host}');
          return (
          activeHost: null,
          healthy: null,
          serversTried: switches,
          currentServerFailed: currentFailed,
        );
        }

        if (await _isOutboundHealthy(candidate.tag, token, port)) {
          await _preferences.setCurrentServerId(candidate.host);
          _line('SWITCHED to working server ${candidate.host}');
          return (
            activeHost: candidate.host,
            healthy: true,
            serversTried: switches,
            currentServerFailed: currentFailed,
          );
        }
        _line('  ${candidate.host} also failed — continuing');
      }

      _line(
        'no working server found after $switches attempt(s) — leaving current selection',
      );
      var activeHost = await _resolveActiveHost(token, port, candidates);
      // Traffic follows the urltest group's live pick even while the selector
      // is pinned to the (dead) chosen server, so the exit that actually
      // carries traffic can differ from both. The UI must reflect what
      // traffic really does: probe the true exit before declaring the tunnel
      // unhealthy.
      if (activeHost == null || activeHost == currentId) {
        final pick = await _selectorNow(_urlTest, token, port);
        for (final c in candidates) {
          if (c.tag == pick) {
            activeHost = c.host;
            break;
          }
        }
      }
      if (activeHost != null && activeHost != currentId && shouldContinue()) {
        _Candidate? active;
        for (final c in candidates) {
          if (c.host == activeHost) {
            active = c;
            break;
          }
        }
        if (active != null &&
            await _isOutboundHealthy(active.tag, token, port)) {
          _line(
            'actual routing exit $activeHost is healthy — tunnel carries traffic',
          );
          return (
            activeHost: activeHost,
            healthy: true,
            serversTried: switches,
            currentServerFailed: currentFailed,
          );
        }
      }
      return (
        activeHost: activeHost,
        healthy: false,
        serversTried: switches,
        currentServerFailed: currentFailed,
      );
    } catch (e, st) {
      _logger.error('$tag failover run failed', e, st);
      return (
        activeHost: null,
        healthy: null,
        serversTried: switches,
        currentServerFailed: currentFailed,
      );
    }
  }

  /// Reads the outbound sing-box is *actually* routing through right now:
  /// the selector's current target, following one hop into the urltest group
  /// if the selector points at it. Returns the matching server host, or null.
  Future<String?> _resolveActiveHost(
    String token,
    int port,
    List<_Candidate> candidates,
  ) async {
    var name = await _selectorNow(_selector, token, port);
    if (name == null) return null;
    if (name == _urlTest) {
      name = await _selectorNow(_urlTest, token, port) ?? name;
    }
    for (final c in candidates) {
      if (c.tag == name) return c.host;
    }
    return null;
  }

  /// `GET /proxies/{group}` → the group's `now` (currently-selected member).
  Future<String?> _selectorNow(String group, String token, int port) async {
    final client = HttpClient()..connectionTimeout = _probeTimeout;
    try {
      final uri = Uri.http('127.0.0.1:$port', '/proxies/$group');
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      final response =
          await request.close().timeout(const Duration(seconds: 4));
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != HttpStatus.ok) return null;
      final json = jsonDecode(body) as Map<String, dynamic>;
      final now = json['now'];
      return now is String && now.isNotEmpty ? now : null;
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  Future<(String?, int?)> _clashCredentials() async {
    try {
      final (token, portStr) = await (
        _secureStorage.read(key: SecureStorageKeys.clashApiToken),
        _secureStorage.read(key: SecureStorageKeys.clashApiPort),
      ).wait;
      return (token, int.tryParse(portStr ?? ''));
    } catch (e) {
      _logger.error('$tag failed to read clash credentials', e);
      return (null, null);
    }
  }

  /// Maps server IP -> country code, so failover can be confined to the
  /// country the user is already connected to.
  Future<Map<String, String>> _hostCountryMap() async {
    try {
      final servers = await _serversRepository.getServers(force: false);
      return {for (final s in servers) s.ip: s.region.countryCode};
    } catch (e) {
      _logger.error('$tag failed to load server list for country map', e);
      return const {};
    }
  }

  /// Builds the ordered candidate list from the same links the config was built
  /// from. Tag = the link's URL fragment (matches the sing-box outbound tag);
  /// host = the link's host (the app uses the server IP as its id).
  Future<List<_Candidate>> _loadCandidates() async {
    final config = await _configRepository.loadConfig();
    final links = (config['outboundsLinks'] as List?)?.cast<String>() ?? [];

    final seen = <String>{};
    final candidates = <_Candidate>[];
    for (final link in links) {
      try {
        final uri = Uri.parse(link);
        final tag = uri.fragment;
        final host = uri.host;
        if (tag.isEmpty || host.isEmpty) continue;
        if (!seen.add(tag)) continue;
        candidates.add(_Candidate(tag: tag, host: host));
      } catch (_) {
        // Skip unparseable links.
      }
    }
    return candidates;
  }

  /// Healthy = reaches at least [_minHealthyProbes] of [_probeUrls] *through*
  /// the given outbound, measured by sing-box via the Clash delay endpoint.
  Future<bool> _isOutboundHealthy(String tag, String token, int port) async {
    var ok = 0;
    for (final url in _probeUrls) {
      final delay = await _delayThroughOutbound(tag, url, token, port);
      if (delay != null) {
        ok++;
        if (ok >= _minHealthyProbes) {
          _line('  probe $tag: healthy ($ok/${_probeUrls.length} reachable)');
          return true;
        }
      }
    }
    _line('  probe $tag: unhealthy ($ok/${_probeUrls.length} reachable)');
    return false;
  }

  /// `GET /proxies/{tag}/delay` — sing-box dials [url] through [tag] and returns
  /// the round-trip delay in ms, or an error status if it cannot reach it.
  Future<int?> _delayThroughOutbound(
    String tag,
    String url,
    String token,
    int port,
  ) async {
    final client = HttpClient()..connectionTimeout = _probeTimeout;
    try {
      final uri = Uri.http('127.0.0.1:$port', '/proxies/$tag/delay', {
        'url': url,
        'timeout': _probeTimeout.inMilliseconds.toString(),
      });
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      // Give sing-box the full probe timeout plus a little slack for the local
      // round-trip before we give up on the API call itself.
      final response =
          await request.close().timeout(_probeTimeout + const Duration(seconds: 2));
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != HttpStatus.ok) return null;
      final json = jsonDecode(body) as Map<String, dynamic>;
      final delay = json['delay'];
      // A missing/zero delay means sing-box could not complete the probe
      // through this outbound — treat it as unreachable, not healthy.
      return (delay is int && delay > 0) ? delay : null;
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }

  /// `PUT /proxies/{selector}` — pin the routing selector to [tag].
  Future<bool> _selectOutbound(String tag, String token, int port) async {
    final client = HttpClient()..connectionTimeout = _probeTimeout;
    try {
      final uri = Uri.http('127.0.0.1:$port', '/proxies/$_selector');
      final request = await client.putUrl(uri);
      request.headers
        ..set(HttpHeaders.authorizationHeader, 'Bearer $token')
        ..contentType = ContentType.json;
      request.write(jsonEncode({'name': tag}));
      final response =
          await request.close().timeout(const Duration(seconds: 4));
      await response.drain<void>();
      return response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent;
    } catch (e) {
      _logger.error('$tag select failed', e);
      return false;
    } finally {
      client.close(force: true);
    }
  }
}

class _Candidate {
  const _Candidate({required this.tag, required this.host});

  final String tag;
  final String host;
}
