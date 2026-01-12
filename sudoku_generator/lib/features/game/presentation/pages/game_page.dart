import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_pad.dart';
import '../../domain/model/game_state.dart';
import '../../domain/model/difficulty_level.dart';

/// The main page widget for the Sudoku game.
///
/// This widget displays the complete Sudoku game interface.
class GamePage extends ConsumerStatefulWidget {
  /// The difficulty level of the game.
  final DifficultyLevel difficulty;

  /// The maximum allowed mistakes before game over.
  final int maxMistakes;

  /// Creates a [GamePage] widget.
  const GamePage({
    super.key,
    this.difficulty = DifficultyLevel.medium,
    this.maxMistakes = 3,
  });

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNewGame();
    });
  }

  @override
  void didUpdateWidget(GamePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.difficulty != widget.difficulty ||
        oldWidget.maxMistakes != widget.maxMistakes) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startNewGame();
      });
    }
  }

  void _startNewGame() {
    ref.read(gameProvider.notifier).startNewGame(
          difficulty: widget.difficulty,
          maxMistakes: widget.maxMistakes,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(gameProvider, (GameState? previous, GameState next) {
      if (next.isComplete) {
        _showCompletionDialog(context);
      } else if (next.mistakes >= next.maxMistakes) {
        _showGameOverDialog(context);
      }
    });

    final gameState = ref.watch(gameProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Sudoku',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'New Game',
            onPressed: _startNewGame,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: gameState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 8),
                _buildHeader(context, gameState),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SudokuGrid(),
                          const SizedBox(height: 24),
                          const NumberPad(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              icon: const Icon(Icons.emoji_events_rounded,
                  size: 48, color: Colors.amber),
              title: const Text('Congratulations!'),
              content: const Text('You solved the puzzle! Great job.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _startNewGame();
                  },
                  child: const Text('New Game'),
                )
              ],
            ));
  }

  void _showGameOverDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (_) => PopScope(
              canPop: false, // Prevent back button
              child: AlertDialog(
                icon: const Icon(Icons.error_outline_rounded,
                    size: 48, color: Colors.red),
                title: const Text('Game Over'),
                content: const Text('You reached the mistake limit.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startNewGame();
                    },
                    child: const Text('Try Again'),
                  )
                ],
              ),
            ));
  }

  Widget _buildHeader(BuildContext context, GameState gameState) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoChip(context,
                label: 'Difficulty',
                value: widget.difficulty.displayName,
                icon: Icons.signal_cellular_alt_rounded),
            Container(width: 1, height: 24, color: colorScheme.outlineVariant),
            _buildInfoChip(
              context,
              label: 'Mistakes',
              value: '${gameState.mistakes}/${gameState.maxMistakes}',
              icon: Icons.warning_amber_rounded,
              isWarning: gameState.mistakes >= gameState.maxMistakes - 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required String label,
      required String value,
      required IconData icon,
      bool isWarning = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = isWarning ? colorScheme.error : colorScheme.onSurface;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            Text(value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
          ],
        )
      ],
    );
  }
}
