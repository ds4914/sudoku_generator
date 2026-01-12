import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';

/// A widget that displays the number input pad for the Sudoku game.
///
/// This widget provides:
/// - Buttons for numbers 1-9 to input into selected cells
/// - A backspace button to clear the selected cell
/// - Modern, accessible button design with visual feedback
class NumberPad extends ConsumerWidget {
  /// Creates a [NumberPad] widget.
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                5, (index) => _buildNumberButton(context, ref, index + 1)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                  4, (index) => _buildNumberButton(context, ref, index + 6)),
              _buildActionButton(
                context,
                ref,
                icon: Icons.backspace_rounded,
                onTap: () => ref.read(gameProvider.notifier).inputNumber(0),
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(BuildContext context, WidgetRef ref, int number) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 56, // Slightly wider
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            ref.read(gameProvider.notifier).inputNumber(number);
          },
          child: Center(
            child: Text(
              '$number',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, WidgetRef ref,
      {required IconData icon,
      required VoidCallback onTap,
      bool isDestructive = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bgColor = isDestructive
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final iconColor =
        isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Center(
            child: Icon(icon, color: iconColor, size: 28),
          ),
        ),
      ),
    );
  }
}
