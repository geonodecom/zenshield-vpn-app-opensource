import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/storage/cf_click_id_store.dart';

abstract class AbstractAnalyticsManager {
  /// Call once during app startup.
  Future<void> init();

  Future<void> sendEvent(
    AnalyticsEventNames event,
    Map<String, String>? parameters,
  );

  /// Bind anonymous device identity to an authenticated user identity.
  Future<void> identify({required String distinctId, String? email});

  /// Clears any identified user and starts a new anonymous session.
  Future<void> reset();
}

/// No-op analytics manager. This app previously reported events to PostHog;
/// that integration has been removed for the open-source release. Kept as a
/// no-op (rather than deleting the abstraction) so the rest of the app's
/// call sites don't need to change.
@LazySingleton(as: AbstractAnalyticsManager)
class AnalyticsManager extends AbstractAnalyticsManager {
  AnalyticsManager(
    this._packageInfo,
    this._cfClickIdStore,
    this._secureStorage,
  );

  // ignore: unused_field
  final PackageInfo _packageInfo;
  // ignore: unused_field
  final AbstractCfClickIdStore _cfClickIdStore;
  // ignore: unused_field
  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> init() async {}

  @override
  Future<void> sendEvent(
    AnalyticsEventNames event,
    Map<String, String>? parameters,
  ) async {}

  @override
  Future<void> identify({required String distinctId, String? email}) async {}

  @override
  Future<void> reset() async {}
}
