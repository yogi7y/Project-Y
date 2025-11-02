import 'package:persistence_y_shared_preferences/persistence_y_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  group('SharedPreferencesStore', () {
    late SharedPreferencesStore store;

    setUp(() async {
      // Clear any existing data
      SharedPreferences.setMockInitialValues({});
      store = const SharedPreferencesStore();
      await store.init();
    });

    group('set and get operations', () {
      test('can store and retrieve String values', () async {
        await store.set<String>('username', 'john_doe');
        final result = await store.get<String>('username');
        expect(result, equals('john_doe'));
      });

      test('can store and retrieve int values', () async {
        await store.set<int>('count', 42);
        final result = await store.get<int>('count');
        expect(result, equals(42));
      });

      test('can store and retrieve double values', () async {
        await store.set<double>('rating', 4.5);
        final result = await store.get<double>('rating');
        expect(result, equals(4.5));
      });

      test('can store and retrieve bool values', () async {
        await store.set<bool>('is_premium', true);
        final result = await store.get<bool>('is_premium');
        expect(result, isTrue);
      });

      test('can store and retrieve List<String> values', () async {
        const tags = ['flutter', 'dart', 'mobile'];
        await store.set<List<String>>('tags', tags);
        final result = await store.get<List<String>>('tags');
        expect(result, equals(tags));
      });

      test('overwrites existing values', () async {
        await store.set<String>('key', 'value1');
        await store.set<String>('key', 'value2');
        final result = await store.get<String>('key');
        expect(result, equals('value2'));
      });
    });

    group('null handling', () {
      test('returns null for non-existent keys', () async {
        final result = await store.get<String>('missing_key');
        expect(result, isNull);
      });

      test('returns null for type mismatch', () async {
        await store.set<String>('key', 'value');
        final result = await store.get<int>('key');
        expect(result, isNull);
      });
    });

    group('remove operation', () {
      test('can remove values', () async {
        await store.set<String>('key', 'value');
        await store.remove('key');
        final result = await store.get<String>('key');
        expect(result, isNull);
      });

      test('remove on non-existent key does nothing', () async {
        await store.remove('non_existent');
        // Should not throw
      });
    });

    group('clear operation', () {
      test('can clear all values', () async {
        await store.set<String>('key1', 'value1');
        await store.set<int>('key2', 42);
        await store.set<bool>('key3', true);

        await store.clear();

        expect(await store.get<String>('key1'), isNull);
        expect(await store.get<int>('key2'), isNull);
        expect(await store.get<bool>('key3'), isNull);
      });

      test('clear on empty store does nothing', () async {
        await store.clear();
        // Should not throw
      });
    });

    group('unsupported types', () {
      test('throws UnsupportedError for unsupported types', () async {
        expect(
          () => store.set<Map<String, dynamic>>('key', {'test': 'value'}),
          throwsUnsupportedError,
        );
      });
    });

    group('persistence', () {
      test('values persist across store instances', () async {
        await store.set<String>('persistent_key', 'persistent_value');

        // Create new store instance
        final newStore = const SharedPreferencesStore();
        await newStore.init();

        final result = await newStore.get<String>('persistent_key');
        expect(result, equals('persistent_value'));
      });
    });
  });
}
