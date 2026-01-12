import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/logic/sudoku_generator.dart';
import '../../domain/model/game_state.dart';
import '../../domain/model/sudoku_cell.dart';
import '../../domain/model/difficulty_level.dart';

/// The main Riverpod provider for the Sudoku game state.
///
/// This provider manages all game logic including puzzle generation,
/// cell selection, input validation, and mistake tracking.
final gameProvider =
    NotifierProvider<GameNotifier, GameState>(GameNotifier.new);

/// A [Notifier] that manages the Sudoku game state and logic.
///
/// This class handles:
/// - Generating new Sudoku puzzles
/// - Tracking the solution for validation
/// - Managing cell selection and input
/// - Counting mistakes and checking for completion
class GameNotifier extends Notifier<GameState> {
  List<List<int>> _solution = [];

  @override
  GameState build() {
    // Initialize with default state
    // We defer the heavy startNewGame work to be called explicitly or
    // we could call it here if we want immediate initialization.
    // Given the previous design, we'll start with a default state
    // and let the UI trigger the game start, OR we can start it here.
    //
    // However, Notifier build() must return the state.
    // We will initialize a "loading" or empty state first,
    // and then immediately trigger a new game in the constructor logic equivalence.

    // NOTE: In Notifier, we shouldn't trigger side effects in build().
    // But to match previous behavior where the constructor started the game:
    // We will return a default state and assume logic is called via startNewGame.
    // BUT, the previous code called startNewGame() in the constructor.
    // To preserve this, we can't easily do it in build() without side effects.
    //
    // Best practice: Return a valid initial state.
    // The GamePage already calls startNewGame() in initState/postFrameCallback.
    // So we can simply return a clean initial state here.

    return const GameState(maxMistakes: 3);
  }

  /// Generates and starts a new Sudoku game.
  ///
  /// The [difficulty] parameter determines how many cells are removed.
  /// The [maxMistakes] parameter allows overriding the maximum allowed mistakes.
  void startNewGame({
    DifficultyLevel difficulty = DifficultyLevel.medium,
    int? maxMistakes,
  }) async {
    state = state.copyWith(isLoading: true);

    // meaningful delay is not needed for logic, but good for UI to show loading if needed,
    // but here we just run it.
    // Run in microtask to avoid blocking UI if it takes time, though N=9 is fast.

    final generator = SudokuGenerator();
    generator.fillValues();

    // Store solution
    _solution = List.generate(
      9,
      (i) => List.generate(9, (j) => generator.mat[i][j]),
    );

    // Remove digits to create puzzle
    generator.removeKDigits(difficulty.cellsToRemove);

    // Convert to SudokoCells
    final List<List<SudokuCell>> newBoard = List.generate(9, (row) {
      return List.generate(9, (col) {
        final val = generator.mat[row][col];
        return SudokuCell(
          value: val,
          isFixed: val != 0,
        );
      });
    });

    state = GameState(
      board: newBoard,
      isLoading: false,
      mistakes: 0,
      maxMistakes:
          maxMistakes ?? state.maxMistakes, // Use provided or preserve setting
      isComplete: false,
      selectedRow: null,
      selectedCol: null,
    );
  }

  /// Selects a cell at the given [row] and [col] position.
  ///
  /// This also highlights all cells with the same value as the selected cell.
  /// Does nothing if the game is loading or already complete.
  void selectCell(int row, int col) {
    if (state.isLoading || state.isComplete) return;

    // Do nothing if we select a cell, just update state
    // We also want to highlight same numbers

    final cellValue = state.board[row][col].value;

    final newBoard = List.generate(9, (r) {
      return List.generate(9, (c) {
        final cell = state.board[r][c];
        final isSelected = (r == row && c == col);
        final isSameValue = (cellValue != 0 && cell.value == cellValue);

        return cell.copyWith(
          isSelected: isSelected,
          isSameValue: isSameValue,
        );
      });
    });

    state = state.copyWith(
      board: newBoard,
      selectedRow: row,
      selectedCol: col,
    );
  }

  /// Inputs a [number] (1-9) into the currently selected cell.
  ///
  /// Validates the input against the solution and updates the mistake count
  /// if incorrect. Also checks if the puzzle is complete after each input.
  /// Does nothing if no cell is selected or the selected cell is fixed.
  void inputNumber(int number) {
    if (state.isLoading || state.isComplete) return;
    if (state.selectedRow == null || state.selectedCol == null) return;

    final row = state.selectedRow!;
    final col = state.selectedCol!;
    final currentCell = state.board[row][col];

    // Cannot edit fixed cells
    if (currentCell.isFixed) return;

    final isCorrect = _solution[row][col] == number;

    // Update the cell
    final newCell = currentCell.copyWith(
      value: number,
      isError: !isCorrect,
      isSameValue: true, // It's the selected number now
    );

    // Update board
    List<List<SudokuCell>> newBoard = [
      for (final r in state.board) [...r]
    ];
    newBoard[row][col] = newCell;

    // If it was valid, check if we need to update "isSameValue" for other cells
    if (number != 0) {
      for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
          newBoard[r][c] = newBoard[r][c]
              .copyWith(isSameValue: newBoard[r][c].value == number);
        }
      }
    }

    int newMistakes = state.mistakes;
    if (!isCorrect) {
      newMistakes++;
    }

    // Check completion
    bool isComplete = true;
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (newBoard[r][c].value != _solution[r][c]) {
          isComplete = false;
          break;
        }
      }
    }

    state = state.copyWith(
      board: newBoard,
      mistakes: newMistakes,
      isComplete: isComplete,
    );
  }
}
