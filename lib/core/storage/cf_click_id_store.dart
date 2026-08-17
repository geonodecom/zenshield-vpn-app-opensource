import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractCfClickIdStore {
  Future<String?> get();
  Future<void> set(String? value);
}

@LazySingleton(as: AbstractCfClickIdStore)
class CfClickIdStore extends AbstractCfClickIdStore {
  CfClickIdStore(this._prefs);

  static const _key = 'cf_click_id';

  final SharedPreferences _prefs;

  @override
  Future<String?> get() async {
    final v = _prefs.getString(_key);
    if (v == null) return null;
    final t = v.trim();
    return t.isEmpty ? null : t;
  }

  @override
  Future<void> set(String? value) async {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      // Keep the existing value if we get empty/invalid input.
      return;
    }
    await _prefs.setString(_key, normalized);
  }
}

