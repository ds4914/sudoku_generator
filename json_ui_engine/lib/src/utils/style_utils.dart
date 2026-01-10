import 'package:flutter/widgets.dart';
import '../model/data_models.dart';

class StyleUtils {
  /// Parses a hex color string (e.g. "#FF0000" or "#AAFF0000").
  static Color? parseColor(String? hexString) {
    if (hexString == null) return null;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return null;
    }
  }

  static EdgeInsetsGeometry? parsePadding(dynamic padding) {
    if (padding is num) {
      return EdgeInsets.all(padding.toDouble());
    }
    // Handle map for LTRB...
    if (padding is Map) {
      return EdgeInsets.only(
        left: (padding['left'] as num?)?.toDouble() ?? 0,
        right: (padding['right'] as num?)?.toDouble() ?? 0,
        top: (padding['top'] as num?)?.toDouble() ?? 0,
        bottom: (padding['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
    return null;
  }

  /// Wraps a widget with common styling layout (Padding, Container checks, Gestures).
  static Widget wrap({
    required Widget child,
    required Map<String, dynamic>? style,
    required Map<String, RemoteAction>? actions,
    required Function(String, Map<String, dynamic>)? onAction,
  }) {
    if (style == null && (actions == null || actions.isEmpty)) {
      return child;
    }

    Widget current = child;
    
    // 1. Padding
    if (style != null && style.containsKey('padding')) {
      final padding = parsePadding(style['padding']);
      if (padding != null) {
        current = Padding(padding: padding, child: current);
      }
    }

    // 2. Background / Decoration / Margin (Container)
    // Basic implementation for background color
    if (style != null && style.containsKey('backgroundColor')) {
      current = DecoratedBox(
        decoration: BoxDecoration(
          color: parseColor(style['backgroundColor']),
        ),
        child: current,
      );
    }
    
    // 3. Gestures
    if (actions != null && actions.isNotEmpty && onAction != null) {
      current = GestureDetector(
        onTap: actions.containsKey('onTap')
            ? () => onAction(actions['onTap']!.type, actions['onTap']!.payload)
            : null,
        onLongPress: actions.containsKey('onLongPress')
            ? () => onAction(actions['onLongPress']!.type, actions['onLongPress']!.payload)
            : null,
        child: current,
      );
    }

    // 4. Visibility/Opacity could go here
    
    return current;
  }
}
