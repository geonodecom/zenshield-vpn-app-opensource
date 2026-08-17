import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractAppsflyerEventFlagsStore {
  Future<bool> getVpnConnectedFired();
  Future<void> setVpnConnectedFired();

  Future<bool> getRegistrationFired();
  Future<void> setRegistrationFired();
}

@LazySingleton(as: AbstractAppsflyerEventFlagsStore)
class AppsflyerEventFlagsStore extends AbstractAppsflyerEventFlagsStore {
  AppsflyerEventFlagsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _vpnConnectedKey = 'af_vpn_connected_fired';
  static const _registrationKey = 'af_complete_registration_fired';

  @override
  Future<bool> getVpnConnectedFired() async => _prefs.getBool(_vpnConnectedKey) ?? false;

  @override
  Future<void> setVpnConnectedFired() async {
    await _prefs.setBool(_vpnConnectedKey, true);
  }

  @override
  Future<bool> getRegistrationFired() async => _prefs.getBool(_registrationKey) ?? false;

  @override
  Future<void> setRegistrationFired() async {
    await _prefs.setBool(_registrationKey, true);
  }
}

