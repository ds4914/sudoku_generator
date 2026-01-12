# Sudoku Generator Example

This is a simple example demonstrating how to use the `sudoku_generator` package to create a beautiful Sudoku game in your Flutter application.

## Features Demonstrated

- Basic integration of the Sudoku game widget
- Material Design 3 theming (light and dark modes)
- Riverpod state management setup

## Running the Example

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Code Overview

The example shows the minimal setup required to use the package:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku_generator/sudoku_generator.dart';

void main() {
  // Wrap your app with ProviderScope (required for Riverpod)
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GamePage(), // Simply use the GamePage widget
    );
  }
}
```

## What You'll See

- A fully functional Sudoku game with:
  - Automatic puzzle generation
  - Cell selection and number input
  - Mistake tracking
  - Win/lose dialogs
  - Ability to start new games

## Customization

The game automatically adapts to your app's theme. Try switching between light and dark modes to see the difference!

## Learn More

For more information about the package, see the [main README](../README.md).
