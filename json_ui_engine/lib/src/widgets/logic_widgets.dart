import 'package:flutter/widgets.dart';
import '../core/remote_ui.dart';
import '../core/widget_registry.dart';
import '../model/data_models.dart';
import '../engine/state_controller.dart';

class LogicWidgets {
  static void register(WidgetRegistry registry) {
    registry.register('conditional', _buildConditional);
  }

  static Widget _buildConditional(BuildContext context, RemoteWidgetData data) {
    final condition = data.properties['condition'];
    final trueChild = data.properties['true'];
    final falseChild = data.properties['false'];
    
    // Evaluate condition
    bool isTrue = false;
    
    // Case 1: condition is a boolean directly (from JSON boolean)
    if (condition is bool) {
      isTrue = condition;
    } 
    // Case 2: String expression
    else if (condition is String) {
      isTrue = _evaluateStringCondition(context, condition);
    }
    
    final childData = isTrue 
        ? (trueChild != null ? RemoteWidgetData.fromJson(trueChild) : null)
        : (falseChild != null ? RemoteWidgetData.fromJson(falseChild) : null);
        
    if (childData == null) {
      return const SizedBox.shrink();
    }
    
    return RemoteUI.registry.build(context, childData);
  }
  
  static bool _evaluateStringCondition(BuildContext context, String expression) {
    // Very basic 'variable > value' or 'variable' parser
    // Supported: "${variable}" (truthy), "${variable} == value", "${variable} > value"
    
    final controller = RemoteStateProvider.of(context);
    if (controller == null) return false;
    
    final parts = expression.split(' ');
    // Handle "${var}"
    if (parts.length == 1) {
      final key = _extractKey(parts[0]);
      if (key == null) return false;
      final val = controller.getValue(key);
      return val == true || (val != null && val != false && val != 0 && val != '');
    }
    
    // Handle "op" check
    if (parts.length == 3) {
      final key = _extractKey(parts[0]);
      final op = parts[1];
      final target = parts[2];
      
      if (key == null) return false;
      
      dynamic val = controller.getValue(key);
      dynamic targetVal = _parseValue(target);
      
      if (val is num && targetVal is num) {
        switch (op) {
          case '>': return val > targetVal;
          case '<': return val < targetVal;
          case '>=': return val >= targetVal;
          case '<=': return val <= targetVal;
          case '==': return val == targetVal;
          case '!=': return val != targetVal;
        }
      }
      if (op == '==') return val.toString() == targetVal.toString();
      if (op == '!=') return val.toString() != targetVal.toString();
    }
    
    return false;
  }
  
  static String? _extractKey(String token) {
    if (token.startsWith('\${') && token.endsWith('}')) {
      return token.substring(2, token.length - 1);
    }
    return null; // or treat as literal key? Let's generic key if no ${}
  }
  
  static dynamic _parseValue(String val) {
    if (val == 'true') return true;
    if (val == 'false') return false;
    if (int.tryParse(val) != null) return int.parse(val);
    if (double.tryParse(val) != null) return double.parse(val);
    // Remove quotes if present
    if ((val.startsWith('"') && val.endsWith('"')) || (val.startsWith("'") && val.endsWith("'"))) {
      return val.substring(1, val.length - 1);
    }
    return val;
  }
}
