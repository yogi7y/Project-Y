# persistence_y

Abstract persistence layer for Project Y.

## Overview

`persistence_y` provides type-safe abstractions for local data persistence. This package defines core interfaces that can be implemented by various storage backends, including key-value stores, local databases, and other persistence mechanisms.

## Features

- **Type-safe interfaces**: Generic methods for type-safe data operations
- **Multiple storage patterns**: Support for key-value stores and future database abstractions
- **Implementation agnostic**: Abstract interfaces allow for multiple storage backends
- **Pure Dart**: No Flutter dependencies, can be used in any Dart project

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  persistence_y: ^0.1.0
```

## Usage

This package provides only the abstract interfaces. You'll need to use an implementation package such as `persistence_y_shared_preferences`.

### Creating Custom Implementations

You can create your own implementation by implementing `KeyValueStore`:

```dart
import 'package:persistence_y/persistence_y.dart';

class MyCustomStore implements KeyValueStore {
  @override
  Future<void> init() async {
    // Initialize your storage backend
  }

  @override
  Future<T?> get<T>(String key) async {
    // Retrieve value from your storage
  }

  @override
  Future<void> set<T>(String key, T value) async {
    // Store value in your storage
  }

  @override
  Future<void> remove(String key) async {
    // Remove value from your storage
  }

  @override
  Future<void> clear() async {
    // Clear all values from your storage
  }
}
```

## Available Implementations

- **[persistence_y_shared_preferences](../persistence_y_shared_preferences)**: Key-value storage using Flutter's SharedPreferences
