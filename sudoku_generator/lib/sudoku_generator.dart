/// A modern, beautiful Sudoku game widget built with Flutter and Riverpod.
///
/// This package provides a complete Sudoku game implementation with:
/// - Automatic puzzle generation with adjustable difficulty
/// - Clean, modern UI with Material Design 3
/// - State management using Riverpod
/// - Mistake tracking and validation
/// - Completion detection and game over handling
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:flutter_riverpod/flutter_riverpod.dart';
/// import 'package:sudoku_generator/sudoku_generator.dart';
///
/// void main() {
///   runApp(const ProviderScope(child: MyApp()));
/// }
///
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: const GamePage(),
///     );
///   }
/// }
/// ```
library;

/// Exports the main game page widget.
export 'features/game/presentation/pages/game_page.dart';

/// Exports the game state model for advanced usage.
export 'features/game/domain/model/game_state.dart';

/// Exports the Sudoku cell model for advanced usage.
export 'features/game/domain/model/sudoku_cell.dart';

/// Exports the game provider for advanced state management.
export 'features/game/presentation/providers/game_provider.dart';

/// Exports difficulty levels.
export 'features/game/domain/model/difficulty_level.dart';
