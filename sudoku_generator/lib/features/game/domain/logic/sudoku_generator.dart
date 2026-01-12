import 'dart:math';

/// A generator for creating valid Sudoku puzzles.
///
/// This class uses a backtracking algorithm to generate complete, valid
/// Sudoku grids and can remove cells to create puzzles of varying difficulty.
///
/// The generated puzzles follow standard 9x9 Sudoku rules where each row,
/// column, and 3x3 box must contain the digits 1-9 without repetition.
class SudokuGenerator {
  /// The size of the Sudoku grid (always 9 for standard Sudoku).
  static const int N = 9;

  /// The size of each 3x3 box (square root of N).
  static const int srn = 3;

  /// The 2D array representing the Sudoku grid.
  ///
  /// Values range from 0 (empty) to 9 (filled).
  List<List<int>> mat = [];

  /// Creates a new [SudokuGenerator] and initializes an empty 9x9 grid.
  SudokuGenerator() {
    mat = List.generate(N, (_) => List.filled(N, 0));
  }

  /// Fills the entire Sudoku grid with a valid solution.
  ///
  /// This method first fills the diagonal boxes (which don't interfere with each other)
  /// and then fills the remaining cells using a backtracking algorithm.
  void fillValues() {
    fillDiagonal();
    fillRemaining(0, srn);
  }

  void fillDiagonal() {
    for (int i = 0; i < N; i = i + srn) {
      fillBox(i, i);
    }
  }

  bool unUsedInBox(int rowStart, int colStart, int num) {
    for (int i = 0; i < srn; i++) {
      for (int j = 0; j < srn; j++) {
        if (mat[rowStart + i][colStart + j] == num) {
          return false;
        }
      }
    }
    return true;
  }

  void fillBox(int row, int col) {
    int num;
    for (int i = 0; i < srn; i++) {
      for (int j = 0; j < srn; j++) {
        do {
          num = Random().nextInt(N) + 1;
        } while (!unUsedInBox(row, col, num));
        mat[row + i][col + j] = num;
      }
    }
  }

  bool checkIfSafe(int i, int j, int num) {
    return (unUsedInRow(i, num) &&
        unUsedInCol(j, num) &&
        unUsedInBox(i - i % srn, j - j % srn, num));
  }

  bool unUsedInRow(int i, int num) {
    for (int j = 0; j < N; j++) {
      if (mat[i][j] == num) {
        return false;
      }
    }
    return true;
  }

  bool unUsedInCol(int j, int num) {
    for (int i = 0; i < N; i++) {
      if (mat[i][j] == num) {
        return false;
      }
    }
    return true;
  }

  bool fillRemaining(int i, int j) {
    if (j >= N && i < N - 1) {
      i = i + 1;
      j = 0;
    }
    if (i >= N && j >= N) {
      return true;
    }
    if (i < srn) {
      if (j < srn) {
        j = srn;
      }
    } else if (i < N - srn) {
      if (j == (i ~/ srn) * srn) {
        j = j + srn;
      }
    } else {
      if (j == N - srn) {
        i = i + 1;
        j = 0;
        if (i >= N) {
          return true;
        }
      }
    }

    for (int num = 1; num <= N; num++) {
      if (checkIfSafe(i, j, num)) {
        mat[i][j] = num;
        if (fillRemaining(i, j + 1)) {
          return true;
        }
        mat[i][j] = 0;
      }
    }
    return false;
  }

  /// Removes [k] digits from the completed grid to create a puzzle.
  ///
  /// The [k] parameter determines the difficulty - higher values create
  /// harder puzzles. Cells are removed randomly until [k] cells are empty.
  void removeKDigits(int k) {
    int count = k;
    while (count != 0) {
      int i = Random().nextInt(N);
      int j = Random().nextInt(N);
      if (mat[i][j] != 0) {
        count--;
        mat[i][j] = 0;
      }
    }
  }
}
