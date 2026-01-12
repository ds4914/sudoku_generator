## 1.0.4
* Updated to use `NotifierProvider` and `Notifier` instead of the deprecated `StateNotifier` to support Riverpod 3.0.

## 1.0.3
* Fixed screenshot rendering in README.md by using standard Markdown syntax.

## 1.0.2

* **Fixes**:
  * Resolved static analysis errors in `GamePage` related to strict null safety checks.
  * Explicitly typed `ref.listen` callback parameters for better type safety.

## 1.0.1

* **Improvements**:
  * Reduced default maximum mistakes from 300 to 3.
  * Added `difficulty` and `maxMistakes` parameters to `GamePage` for customization.
  * Made the "Game Over" dialog non-dismissible to enforce game restart.
  * Added `DifficultyLevel` enum (Easy, Medium, Hard).
  * Added screenshots to pub.dev description.
  * Improved documentation and pub points score.

## 1.0.0

* **Initial release** of the Sudoku Generator package.

### Features

* ✨ Complete Sudoku game implementation with automatic puzzle generation
* 🎨 Beautiful Material Design 3 UI with light and dark theme support
* 🎮 Full game logic including:
  - Automatic puzzle generation with configurable difficulty
  - Cell selection and highlighting
  - Input validation with mistake tracking
  - Win/lose detection
  - Smooth animations and transitions
* 🏗️ Built with Riverpod for robust state management
* 📱 Responsive design that works on all platforms
* 📚 Comprehensive documentation with dartdoc comments
* 💡 Complete example application
* ♿ Accessible design with proper contrast and touch targets

### Package Structure

* Clean architecture with separation of concerns
* Domain models: `GameState`, `SudokuCell`
* Business logic: `SudokuGenerator`, `GameNotifier`
* Presentation: `GamePage`, `SudokuGrid`, `NumberPad`

### Dependencies

* flutter_riverpod: >=2.6.1 <4.0.0
* Flutter SDK: ^3.6.0
