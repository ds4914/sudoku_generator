import 'package:flutter/widgets.dart';
import '../model/data_models.dart';
import '../utils/style_utils.dart';
import 'remote_ui.dart';

/// Function signature for building a widget from data.
typedef JsonWidgetBuilder = Widget Function(
  BuildContext context,
  RemoteWidgetData data,
);

/// The central registry for mapping string types to widget builders.
class WidgetRegistry {
  final Map<String, JsonWidgetBuilder> _builders = {};
  
  /// A fallback builder when a type is not found.
  /// Defaults to a SizedBox.shrink() (fail-silent).
  JsonWidgetBuilder _fallbackBuilder = (context, data) {
    debugPrint('NativeRemoteUI: Unknown widget type: ${data.type}');
    return const SizedBox.shrink();
  };

  WidgetRegistry();

  /// Register a builder for a specific type.
  void register(String type, JsonWidgetBuilder builder) {
    _builders[type] = builder;
  }

  /// Set a custom fallback builder (e.g., to show a generic error box in debug).
  void setFallback(JsonWidgetBuilder fallback) {
    _fallbackBuilder = fallback;
  }

  /// Retrieve the builder for a given type.
  JsonWidgetBuilder getBuilder(String type) {
    return _builders[type] ?? _fallbackBuilder;
  }
  
  /// Build a widget from data, wrapping it with common styles and actions.
  Widget build(BuildContext context, RemoteWidgetData data) {
    final builder = getBuilder(data.type);
    
    // Build the specific widget
    Widget child;
    try {
      child = builder(context, data);
    } catch (e, stack) {
      // Fail-safe: if a specific builder crashes, return fallback and log
      debugPrint('Error building widget ${data.type}: $e');
      debugPrint(stack.toString());
      child = _fallbackBuilder(context, data);
    }

    // Wrap with common styles (padding, background, gestures)
    return StyleUtils.wrap(
      child: child,
      style: data.style,
      actions: data.actions,
      onAction: (type, payload) {
        RemoteUI.actionHandler.onAction(type, payload);
      },
    );
  }
}
