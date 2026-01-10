import 'package:flutter/material.dart';
import '../core/remote_ui.dart';
import '../core/widget_registry.dart';
import '../model/data_models.dart';
import '../utils/style_utils.dart';

class CoreWidgets {
  static void register(WidgetRegistry registry) {
    registry.register('column', _buildColumn);
    registry.register('row', _buildRow);
    registry.register('text', _buildText);
    registry.register('image', _buildImage);
    registry.register('button', _buildButton);
    registry.register('stack', _buildStack);
    registry.register('sized_box', _buildSizedBox);
  }

  static List<Widget> _buildChildren(BuildContext context, List<RemoteWidgetData>? children) {
    if (children == null) return [];
    return children.map((c) => RemoteUI.registry.build(context, c)).toList();
  }

  static Widget _buildColumn(BuildContext context, RemoteWidgetData data) {
    final children = _buildChildren(context, data.children);
    final mainAxis = _parseMainAxis(data.properties['mainAxisAlignment']);
    final crossAxis = _parseCrossAxis(data.properties['crossAxisAlignment']);
    
    return Column(
      mainAxisAlignment: mainAxis,
      crossAxisAlignment: crossAxis,
      children: children,
    );
  }

  static Widget _buildRow(BuildContext context, RemoteWidgetData data) {
    final children = _buildChildren(context, data.children);
    final mainAxis = _parseMainAxis(data.properties['mainAxisAlignment']);
    final crossAxis = _parseCrossAxis(data.properties['crossAxisAlignment']);

    return Row(
      mainAxisAlignment: mainAxis,
      crossAxisAlignment: crossAxis,
      children: children,
    );
  }
  
  static Widget _buildStack(BuildContext context, RemoteWidgetData data) {
    final children = _buildChildren(context, data.children);
    final alignment = _parseAlignment(data.properties['alignment']) ?? AlignmentDirectional.topStart;
    
    return Stack(
      alignment: alignment,
      children: children,
    );
  }

  static Widget _buildText(BuildContext context, RemoteWidgetData data) {
    final text = data.properties['text']?.toString() ?? '';
    final styleMap = data.properties['style'] as Map<String, dynamic>?;
    
    TextStyle? style;
    if (styleMap != null) {
      style = TextStyle(
        fontSize: (styleMap['fontSize'] as num?)?.toDouble(),
        fontWeight: _parseFontWeight(styleMap['fontWeight']),
        color: StyleUtils.parseColor(styleMap['color']),
      );
    }

    return Text(
      text,
      style: style,
      textAlign: _parseTextAlign(data.properties['textAlign']),
    );
  }

  static Widget _buildImage(BuildContext context, RemoteWidgetData data) {
    final url = data.properties['url'] as String?;
    final fit = _parseBoxFit(data.properties['fit']);
    
    if (url == null) return const SizedBox.shrink();
    
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (ctx, _, __) => const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  static Widget _buildButton(BuildContext context, RemoteWidgetData data) {
    final label = data.properties['label']?.toString() ?? 'Button';
    // Actions are handled by the wrapper in WidgetRegistry via 'actions' map.
    // However, for a native Button widget, the onPressed needs to trigger that.
    // But data.actions is generic. 
    // Usually 'button' type implies an interactive element.
    // The wrapper handles onTap for Container based widgets.
    // For Material Buttons, we must hook onPressed manually if we want the ripple.
    
    final onTapAction = data.actions?['onTap'];
    
    return ElevatedButton(
      onPressed: onTapAction != null 
          ? () => RemoteUI.actionHandler.onAction(onTapAction.type, onTapAction.payload) 
          : () {}, // empty callback to enable button visual state
      child: Text(label),
    );
  }

  static Widget _buildSizedBox(BuildContext context, RemoteWidgetData data) {
    return SizedBox(
      width: (data.properties['width'] as num?)?.toDouble(),
      height: (data.properties['height'] as num?)?.toDouble(),
    );
  }

  // --- Helpers ---

  static MainAxisAlignment _parseMainAxis(String? val) {
    switch (val) {
      case 'start': return MainAxisAlignment.start;
      case 'end': return MainAxisAlignment.end;
      case 'center': return MainAxisAlignment.center;
      case 'spaceBetween': return MainAxisAlignment.spaceBetween;
      case 'spaceAround': return MainAxisAlignment.spaceAround;
      case 'spaceEvenly': return MainAxisAlignment.spaceEvenly;
      default: return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment _parseCrossAxis(String? val) {
    switch (val) {
      case 'start': return CrossAxisAlignment.start;
      case 'end': return CrossAxisAlignment.end;
      case 'center': return CrossAxisAlignment.center;
      case 'stretch': return CrossAxisAlignment.stretch;
      default: return CrossAxisAlignment.center;
    }
  }
  
  static TextAlign _parseTextAlign(String? val) {
    switch (val) {
      case 'center': return TextAlign.center;
      case 'right': return TextAlign.right;
      case 'justify': return TextAlign.justify;
      default: return TextAlign.left;
    }
  }
  
  static FontWeight _parseFontWeight(dynamic val) {
    if (val == 'bold') return FontWeight.bold;
    if (val is int) {
      // 100-900
      if (val >= 100 && val <= 900) return FontWeight.values[(val ~/ 100) - 1];
    }
    return FontWeight.normal;
  }
  
  static BoxFit _parseBoxFit(String? val) {
    switch (val) {
      case 'cover': return BoxFit.cover;
      case 'contain': return BoxFit.contain;
      case 'fill': return BoxFit.fill;
      default: return BoxFit.cover;
    }
  }
  
  static AlignmentGeometry? _parseAlignment(String? val) {
     switch (val) {
       case 'center': return Alignment.center;
       case 'bottomCenter': return Alignment.bottomCenter;
       // ... others
       default: return null;
     }
  }
}
