library flutter_remote_ui;

export 'src/core/remote_ui.dart';
export 'src/core/widget_registry.dart';
export 'src/model/data_models.dart';
export 'src/engine/renderer.dart';
export 'src/engine/state_controller.dart';
export 'src/widgets/core_widgets.dart';
export 'src/widgets/form_widgets.dart';
export 'src/widgets/logic_widgets.dart';

import 'src/core/widget_registry.dart';
import 'src/widgets/core_widgets.dart';
import 'src/widgets/form_widgets.dart';
import 'src/widgets/logic_widgets.dart';

/// Creates a new [WidgetRegistry] pre-populated with all standard widgets:
/// - Core: column, row, stack, text, image, button, sized_box
/// - Forms: text_input
/// - Logic: conditional
WidgetRegistry createDefaultRegistry() {
  final registry = WidgetRegistry();
  CoreWidgets.register(registry);
  FormWidgets.register(registry);
  LogicWidgets.register(registry);
  return registry;
}
