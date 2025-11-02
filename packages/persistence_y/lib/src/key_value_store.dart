/// Abstract interface for key-value storage operations.
///
/// Provides a simple API for storing and retrieving typed values
/// with String keys. Implementations should handle serialization
/// and deserialization of supported types.
abstract interface class KeyValueStore {

  /// Initializes the storage.
  ///
  /// This method should be called before any other operations.
  /// Implementations may use this to set up database connections,
  /// load data, or perform other initialization tasks.
  Future<void> init();

  /// Retrieves a value of type [T] for the given [key].
  ///
  /// Returns `null` if the key doesn't exist or if the value
  /// cannot be cast to type [T].
  ///
  /// Example:
  /// ```dart
  /// final name = await store.get<String>('user_name');
  /// final count = await store.get<int>('login_count');
  /// ```
  Future<T?> get<T>(String key);

  /// Stores a [value] of type [T] for the given [key].
  ///
  /// If the key already exists, the value will be overwritten.
  /// The supported types depend on the implementation.
  ///
  /// Example:
  /// ```dart
  /// await store.set<String>('user_name', 'John');
  /// await store.set<int>('login_count', 42);
  /// ```
  Future<void> set<T>(String key, T value);

  /// Removes the value associated with the given [key].
  ///
  /// Does nothing if the key doesn't exist.
  ///
  /// Example:
  /// ```dart
  /// await store.remove('user_name');
  /// ```
  Future<void> remove(String key);

  /// Removes all key-value pairs from the storage.
  ///
  /// Example:
  /// ```dart
  /// await store.clear();
  /// ```
  Future<void> clear();
}
