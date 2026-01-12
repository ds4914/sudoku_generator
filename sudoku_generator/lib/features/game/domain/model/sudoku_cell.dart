import 'package:meta/meta.dart';

/// A model representing a single cell in the Sudoku grid.
///
/// Each cell contains a value (0-9, where 0 represents an empty cell)
/// and various state flags for UI rendering and game logic.
@immutable
class SudokuCell {
  /// The numeric value of the cell (0-9, where 0 is empty).
  final int value;

  /// Whether this cell is pre-filled and cannot be changed by the player.
  final bool isFixed;

  /// Whether the current value creates a conflict in the Sudoku rules.
  final bool isError;

  /// Whether this cell is currently selected by the player.
  final bool isSelected;

  /// Whether this cell has the same value as the currently selected cell.
  /// Used for highlighting matching numbers.
  final bool isSameValue;

  /// Notes/pencil marks for this cell (e.g., [1, 2, 3]).
  final List<int> notes;

  /// Creates a new [SudokuCell] with the given properties.
  ///
  /// All parameters are optional and have sensible defaults for an empty cell.
  const SudokuCell({
    this.value = 0,
    this.isFixed = false,
    this.isError = false,
    this.isSelected = false,
    this.isSameValue = false,
    this.notes = const [],
  });

  /// Creates a copy of this cell with the given fields replaced with new values.
  ///
  /// All parameters are optional; any omitted parameter will keep its current value.
  SudokuCell copyWith({
    int? value,
    bool? isFixed,
    bool? isError,
    bool? isSelected,
    bool? isSameValue,
    List<int>? notes,
  }) {
    return SudokuCell(
      value: value ?? this.value,
      isFixed: isFixed ?? this.isFixed,
      isError: isError ?? this.isError,
      isSelected: isSelected ?? this.isSelected,
      isSameValue: isSameValue ?? this.isSameValue,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SudokuCell &&
        other.value == value &&
        other.isFixed == isFixed &&
        other.isError == isError &&
        other.isSelected == isSelected &&
        other.isSameValue == isSameValue;
  }

  @override
  int get hashCode {
    return value.hashCode ^
        isFixed.hashCode ^
        isError.hashCode ^
        isSelected.hashCode ^
        isSameValue.hashCode;
  }
}
