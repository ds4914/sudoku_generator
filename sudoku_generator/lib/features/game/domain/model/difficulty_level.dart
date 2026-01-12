/// Represents the difficulty level of a Sudoku game.
///
/// Each difficulty level corresponds to a different number of cells
/// removed from the complete puzzle.
enum DifficultyLevel {
  /// Easy difficulty - 30-35 cells removed.
  easy,

  /// Medium difficulty - 40-45 cells removed.
  medium,

  /// Hard difficulty - 50-55 cells removed.
  hard;

  /// Returns the number of cells to remove for this difficulty level.
  int get cellsToRemove {
    switch (this) {
      case DifficultyLevel.easy:
        return 30;
      case DifficultyLevel.medium:
        return 45;
      case DifficultyLevel.hard:
        return 55;
    }
  }

  /// Returns a human-readable name for this difficulty level.
  String get displayName {
    switch (this) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }
}
