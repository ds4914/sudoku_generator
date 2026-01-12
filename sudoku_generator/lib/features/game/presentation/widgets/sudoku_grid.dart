import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/sudoku_cell.dart';
import '../providers/game_provider.dart';

/// A widget that displays the 9x9 Sudoku grid.
///
/// This widget renders all 81 cells of the Sudoku board with:
/// - Proper 3x3 subgrid borders
/// - Cell selection and highlighting
/// - Error indication for invalid moves
/// - Smooth animations for value changes
class SudokuGrid extends ConsumerWidget {
  /// Creates a [SudokuGrid] widget.
  const SudokuGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final board = gameState.board;

    if (gameState.isLoading || board.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4), // Soft shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: List.generate(9, (row) {
                return Row(
                  children: List.generate(9, (col) {
                    return Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _SudokuCellWidget(
                          row: row,
                          col: col,
                          cell: board[row][col],
                        ),
                      ),
                    );
                  }),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _SudokuCellWidget extends ConsumerWidget {
  final int row;
  final int col;
  final SudokuCell cell;

  const _SudokuCellWidget({
    required this.row,
    required this.col,
    required this.cell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = cell.isSelected;
    final isSameValue = cell.isSameValue;
    final isError = cell.isError;
    final isFixed = cell.isFixed;

    // Modern Colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bgColor = Colors.transparent;
    if (isError) {
      bgColor = colorScheme.errorContainer.withValues(alpha: 0.5);
    } else if (isSelected) {
      bgColor = colorScheme.primaryContainer;
    } else if (isSameValue) {
      bgColor = colorScheme.primary.withValues(alpha: 0.15);
    }

    Color textColor;
    if (isError) {
      textColor = colorScheme.error;
    } else if (isFixed) {
      textColor = colorScheme.onSurface;
    } else {
      textColor = colorScheme.primary;
    }

    // Borders
    // We draw borders on the right and bottom of each cell
    // Thicker borders for the 3x3 subgrids
    final borderRightWidth = (col % 3 == 2 && col != 8) ? 2.0 : 0.5;
    final borderBottomWidth = (row % 3 == 2 && row != 8) ? 2.0 : 0.5;
    final borderColor = colorScheme.outlineVariant;
    final subGridBorderColor = colorScheme.outline;

    return GestureDetector(
      onTap: () {
        ref.read(gameProvider.notifier).selectCell(row, col);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            right: BorderSide(
              width: borderRightWidth,
              color:
                  (col % 3 == 2 && col != 8) ? subGridBorderColor : borderColor,
            ),
            bottom: BorderSide(
              width: borderBottomWidth,
              color:
                  (row % 3 == 2 && row != 8) ? subGridBorderColor : borderColor,
            ),
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              cell.value == 0 ? '' : '${cell.value}',
              key: ValueKey(
                  '${cell.value}-$isError'), // Key triggers animation on change
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: isFixed ? FontWeight.w700 : FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
