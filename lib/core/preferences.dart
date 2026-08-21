import 'dart:convert';

import 'package:injectable/injectable.dart';
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

}
