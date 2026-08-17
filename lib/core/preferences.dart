import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:zenshield/config/constants/common_constants.dart';
import 'package:zenshield/config/constants/shared_preference_keys.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/core/models/protocols.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton()
class Preferences {
  // Launch
  Future<int> get launchCount async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedPreferenceKeys.launchCount) ?? 0;
  }

  Future<void> setLaunchCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPreferenceKeys.launchCount, count);
  }

  // Protocol
  Future<Protocols?> get currentProtocol async {
    final prefs = await SharedPreferences.getInstance();
    final protocolString = prefs.getString(
      SharedPreferenceKeys.currentProtocol,
    );

    if (protocolString == null || protocolString.isEmpty) {
      return null;
    }

    return Protocols.values.firstWhere((e) => e.name == protocolString);
  }

  Future<void> setCurrentProtocol(Protocols protocol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.currentProtocol, protocol.name);
  }

  Future<void> removeCurrentProtocol() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceKeys.currentProtocol);
  }

  // Servers list
  Future<List<SystemVpnConfiguration>> get cachedSystemServersList async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getString(
      SharedPreferenceKeys.cachedSystemServersList,
    );

    if (jsonList == null) {
      return [];
    }

    final decodedList = json.decode(jsonList) as List;

    return decodedList
        .map(
          (jsonItem) =>
              SystemVpnConfiguration.fromJson(jsonItem as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> setCachedSystemServersList(
    List<SystemVpnConfiguration> servers,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = servers.map((e) => e.toJson()).toList();
    await prefs.setString(
      SharedPreferenceKeys.cachedSystemServersList,
      json.encode(jsonList),
    );
  }

  // Selected server
  Future<String?> get currentServerId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.selectedServerId);
  }

  Future<void> setCurrentServerId(String serverId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.selectedServerId, serverId);
  }

  Future<void> removeCurrentServerId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceKeys.selectedServerId);
  }

  // Whether the user explicitly picked the current server (pins routing to
  // that server's country). Reset to false on app start: a plain Connect
  // after opening the app goes back to auto best-server mode.
  Future<bool> get serverSelectionPinned async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.serverSelectionPinned) ?? false;
  }

  Future<void> setServerSelectionPinned(bool pinned) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceKeys.serverSelectionPinned, pinned);
  }

  // Timer value
  Future<int?> get timerStartTime async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedPreferenceKeys.timerStartTime);
  }

  Future<void> setTimerStartTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPreferenceKeys.timerStartTime, value);
  }

  Future<void> removeTimerStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceKeys.timerStartTime);
  }

  // HWID
  Future<String?> get hwid async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.hwid);
  }

  Future<void> setHwid(String hwid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.hwid, hwid);
  }

  Future<String?> get bandwidthSharingPolicy async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.bandwidthSharingPolicy);
  }

  Future<void> setBandwidthSharingPolicy(String policyText) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      SharedPreferenceKeys.bandwidthSharingPolicy,
      policyText,
    );
  }

  /// Bandwidth sharing is opt-in: stays off until the user explicitly
  /// accepts the bandwidth-sharing consent screen.
  Future<bool> get zenSdkEnabled async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.zenSdkEnabled) ?? false;
  }

  Future<void> setZenSdkEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceKeys.zenSdkEnabled, enabled);
  }

  /// Calendar date (see [todayDateString]) the user last tapped "Not now" on
  /// the bandwidth-sharing consent prompt. Used to only re-prompt once per
  /// calendar day instead of on every app open.
  Future<String?> get zenSdkLastDeclinedDate async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.zenSdkLastDeclinedDate);
  }

  Future<void> setZenSdkLastDeclinedDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.zenSdkLastDeclinedDate, date);
  }

  /// User-supplied override for [CommonConstants.geonodeApiKey], entered on
  /// the Geonode key setup screen when the build doesn't already ship one.
  Future<String?> get geonodeApiKeyOverride async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.geonodeApiKeyOverride);
  }

  Future<void> setGeonodeApiKeyOverride(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.geonodeApiKeyOverride, value);
  }

  /// User-supplied override for [CommonConstants.geonodeAppIdAndroid].
  Future<String?> get geonodeAppIdOverride async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.geonodeAppIdOverride);
  }

  Future<void> setGeonodeAppIdOverride(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.geonodeAppIdOverride, value);
  }

  /// Calendar date the user last tapped "Skip" on the Geonode key setup
  /// screen. Used to only re-prompt once per calendar day, same as
  /// [zenSdkLastDeclinedDate].
  Future<String?> get geonodeKeysLastDeclinedDate async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.geonodeKeysLastDeclinedDate);
  }

  Future<void> setGeonodeKeysLastDeclinedDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      SharedPreferenceKeys.geonodeKeysLastDeclinedDate,
      date,
    );
  }

  /// Whether to show the Geonode key setup screen: only relevant once
  /// bandwidth sharing is accepted, only needed if the build doesn't already
  /// ship its own keys, skipped once the user has entered an override, and
  /// re-prompted at most once per calendar day after a "Skip".
  Future<bool> get shouldPromptGeonodeKeySetup async {
    if (!await zenSdkEnabled) return false;

    if (CommonConstants.geonodeApiKey.isNotEmpty &&
        CommonConstants.geonodeAppIdForCurrentPlatform.isNotEmpty) {
      return false;
    }

    final apiKeyOverride = await geonodeApiKeyOverride;
    final appIdOverride = await geonodeAppIdOverride;
    if ((apiKeyOverride?.isNotEmpty ?? false) &&
        (appIdOverride?.isNotEmpty ?? false)) {
      return false;
    }

    final lastDeclinedDate = await geonodeKeysLastDeclinedDate;
    return lastDeclinedDate != todayDateString();
  }

  /// Today's date as `yyyy-MM-dd`, for calendar-day comparisons (not tied to
  /// a 24h timer) — see [zenSdkLastDeclinedDate].
  static String todayDateString() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  // App version
  Future<String?> get previousAppVersion async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.previousAppVersion);
  }

  Future<void> setPreviousAppVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.previousAppVersion, version);
  }

  // Rating
  Future<int> get ratingCount async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedPreferenceKeys.ratingCount) ?? 0;
  }

  Future<void> setRatingCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPreferenceKeys.ratingCount, count);
  }

  // VPN connect count
  Future<int> get vpnConnectCount async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedPreferenceKeys.vpnConnectCount) ?? 0;
  }

  Future<void> setVpnConnectCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPreferenceKeys.vpnConnectCount, count);
  }

  Future<bool> get vpnRestoreOnBoot async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.vpnRestoreOnBoot) ?? false;
  }

  Future<void> setVpnRestoreOnBoot(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceKeys.vpnRestoreOnBoot, value);
  }

  Future<bool> get bootRestoreManagedLaunchOnStartup async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(
          SharedPreferenceKeys.bootRestoreManagedLaunchOnStartup,
        ) ??
        false;
  }

  Future<void> setBootRestoreManagedLaunchOnStartup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      SharedPreferenceKeys.bootRestoreManagedLaunchOnStartup,
      value,
    );
  }

  // Curl log
  Future<String?> get curlLog async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.curlLog);
  }

  Future<void> setCurlLog(String log) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.curlLog, log);
  }
}
