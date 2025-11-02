# persistence_y_shared_preferences

SharedPreferences implementation for `persistence_y`.

## Overview

This package provides a concrete implementation of the `KeyValueStore` interface from `persistence_y` using Flutter's SharedPreferences. It's ideal for storing simple key-value data that persists across app restarts.

## Features

- **Type-safe storage**: Supports String, int, double, bool, and List<String>
- **Simple API**: Clean interface inherited from `persistence_y`
- **Persistent storage**: Data survives app restarts
- **Lazy initialization**: SharedPreferences instance is created on first use

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  persistence_y_shared_preferences: ^0.1.0
```

## Usage

### Basic Example

```dart
import 'package:persistence_y_shared_preferences/persistence_y_shared_preferences.dart';

void main() async {
  // Create store instance
  final store = SharedPreferencesStore();

  // Initialize (must be called before any operations)
  await store.init();

  // Store values
  await store.set<String>('username', 'john_doe');
  await store.set<int>('login_count', 5);
  await store.set<bool>('is_premium', true);
  await store.set<double>('rating', 4.5);
  await store.set<List<String>>('tags', ['flutter', 'dart']);

  // Retrieve values
  final username = await store.get<String>('username'); // 'john_doe'
  final loginCount = await store.get<int>('login_count'); // 5
  final isPremium = await store.get<bool>('is_premium'); // true
  final rating = await store.get<double>('rating'); // 4.5
  final tags = await store.get<List<String>>('tags'); // ['flutter', 'dart']

  // Remove a single value
  await store.remove('username');

  // Clear all data
  await store.clear();
}
```

### Using with Dependency Injection

```dart
import 'package:persistence_y/persistence_y.dart';
import 'package:persistence_y_shared_preferences/persistence_y_shared_preferences.dart';

class UserRepository {
  UserRepository(this._store);

  final KeyValueStore _store;

  Future<void> saveUsername(String username) async {
    await _store.set<String>('username', username);
  }

  Future<String?> getUsername() async {
    return _store.get<String>('username');
  }
}

// Setup
void main() async {
  final store = SharedPreferencesStore();
  await store.init();

  final userRepo = UserRepository(store);
  await userRepo.saveUsername('alice');

  final username = await userRepo.getUsername();
  print(username); // 'alice'
}
```

## Supported Types

The following types are supported by SharedPreferences:

- `String`
- `int`
- `double`
- `bool`
- `List<String>`

Attempting to store unsupported types will throw an `UnsupportedError`.

## Important Notes

### Initialization

Always call `init()` before performing any operations:

```dart
final store = SharedPreferencesStore();
await store.init(); // Required!
```

Failing to initialize will result in an assertion error in debug mode.

### Type Safety

The `get` method returns `null` if:
- The key doesn't exist
- The stored value cannot be cast to the requested type

```dart
await store.set<String>('name', 'Alice');
final name = await store.get<int>('name'); // Returns null (type mismatch)
```

### Clear vs Remove

- `remove(key)`: Removes a single key-value pair
- `clear()`: Removes ALL data from SharedPreferences

```dart
await store.remove('username'); // Removes only 'username'
await store.clear(); // Removes everything
```

## See Also

- [persistence_y](../persistence_y): The abstract persistence API
- [shared_preferences](https://pub.dev/packages/shared_preferences): The underlying SharedPreferences package
