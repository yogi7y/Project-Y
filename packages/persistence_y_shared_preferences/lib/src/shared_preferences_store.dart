import 'package:meta/meta.dart';
import 'package:persistence_y/persistence_y.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A [KeyValueStore] implementation using Flutter's SharedPreferences.
///
/// Supports the following types:
/// - [String]
/// - [int]
/// - [double]
/// - [bool]
/// - [List<String>]
///
/// Example usage:
/// ```dart
/// final store = SharedPreferencesStore();
/// await store.init();
///
/// await store.set<String>('username', 'john_doe');
/// final username = await store.get<String>('username');
/// ```
@immutable
class SharedPreferencesStore implements KeyValueStore {
  /// Creates a [SharedPreferencesStore].
  const SharedPreferencesStore();

  static SharedPreferences? _instance;

  @override
  Future<void> init() async {
    _instance ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _preference {
    assert(
      _instance != null,
      'SharedPreferencesStore must be initialized before use. Call init() first.',
    );
    return _instance!;
  }

  @override
  Future<T?> get<T>(String key) async {
    final value = _preference.get(key);

    if (value == null) {
      return null;
    }

    // Type validation
    if (value is! T) {
      return null;
    }

    return value as T;
  }

  @override
  Future<void> set<T>(String key, T value) async {
    switch (value) {
      case final String stringValue:
        await _preference.setString(key, stringValue);
      case final int intValue:
        await _preference.setInt(key, intValue);
      case final double doubleValue:
        await _preference.setDouble(key, doubleValue);
      case final bool boolValue:
        await _preference.setBool(key, boolValue);
      case final List<String> listValue:
        await _preference.setStringList(key, listValue);
      default:
        throw UnsupportedError(
          'Type ${T.toString()} is not supported by SharedPreferences. '
          'Supported types: String, int, double, bool, List<String>',
        );
    }
  }

  @override
  Future<void> remove(String key) async {
    await _preference.remove(key);
  }

  @override
  Future<void> clear() async {
    await _preference.clear();
  }
}
