import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/storage/appsflyer_event_flags_store.dart';
import 'package:zenshield/core/storage/cf_click_id_store.dart';

abstract class AbstractAppsFlyerManager {
  /// Call once during app startup. Safe to call multiple times.
  Future<void> init();

  /// Returns the AppsFlyer device UID (useful for diagnostics / support).
  /// Returns `null` on non-Android or when the SDK has not been initialized.
  Future<String?> getAppsFlyerUID();

  /// Custom funnel event. Recommended once-per-install.
  Future<void> logVpnConnected();

  /// Standard funnel event. Fire after sign-up succeeds.
  Future<void> logCompleteRegistration({String? registrationMethod});
}

/// No-op AppsFlyer manager. This app previously reported install/attribution
/// events to AppsFlyer; that integration has been removed for the
/// open-source release. Kept as a no-op (rather than deleting the
/// abstraction) so the rest of the app's call sites don't need to change.
@LazySingleton(as: AbstractAppsFlyerManager)
class AppsFlyerManager extends AbstractAppsFlyerManager {
  AppsFlyerManager(this._logger, this._cfClickIdStore, this._flagsStore);

  // ignore: unused_field
  final Talker _logger;
  // ignore: unused_field
  final AbstractCfClickIdStore _cfClickIdStore;
  // ignore: unused_field
  final AbstractAppsflyerEventFlagsStore _flagsStore;

  @override
  Future<void> init() async {}

  @override
  Future<String?> getAppsFlyerUID() async => null;

  @override
  Future<void> logVpnConnected() async {}

  @override
  Future<void> logCompleteRegistration({String? registrationMethod}) async {}
}
