import 'package:flutter/cupertino.dart';

import 'sudoku_cell.dart';

/// Represents the complete state of a Sudoku game.
///
/// This class holds all the information needed to render the game UI
/// and track the player's progress, including the board state, selected cell,
/// mistakes count, and completion status.
@immutable
class GameState {
  /// The 9x9 grid of Sudoku cells representing the game board.
  final List<List<SudokuCell>> board;

  /// The row index of the currently selected cell (0-8), or null if no cell is selected.
  final int? selectedRow;

  /// The column index of the currently selected cell (0-8), or null if no cell is selected.
  final int? selectedCol;

  /// The number of mistakes the player has made so far.
  final int mistakes;

  /// The maximum number of mistakes allowed before game over.
  final int maxMistakes;

  /// Whether the puzzle has been completed successfully.
  final bool isComplete;

  /// Whether a new game is currently being generated.
  final bool isLoading;

  /// Creates a new [GameState] with the given properties.
  ///
  /// All parameters are optional and have sensible defaults for a new game.
  /// The default [maxMistakes] is 3, and [isLoading] defaults to false.
  const GameState({
    this.board = const [],
    this.selectedRow,
    this.selectedCol,
    this.mistakes = 0,
    this.maxMistakes = 3, // Default, can be overridden
    this.isComplete = false,
    this.isLoading = false,
  });

  /// Creates a copy of this state with the given fields replaced with new values.
  ///
  /// All parameters are optional; any omitted parameter will keep its current value.
  GameState copyWith({
    List<List<SudokuCell>>? board,
    int? selectedRow,
    int? selectedCol,
    int? mistakes,
    int? maxMistakes,
    bool? isComplete,
    bool? isLoading,
  }) {
    return GameState(
      board: board ?? this.board,
      selectedRow: selectedRow ?? this.selectedRow,
      selectedCol: selectedCol ?? this.selectedCol,
      mistakes: mistakes ?? this.mistakes,
      maxMistakes: maxMistakes ?? this.maxMistakes,
      isComplete: isComplete ?? this.isComplete,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
