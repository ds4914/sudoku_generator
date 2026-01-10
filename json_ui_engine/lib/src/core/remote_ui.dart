import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'widget_registry.dart';

/// Abstract handler for actions (navigation, api calls, etc).
abstract class ActionHandler {
  void onAction(String type, Map<String, dynamic> payload);
}

class DefaultActionHandler implements ActionHandler {
  @override
  void onAction(String type, Map<String, dynamic> payload) {
    debugPrint('Action dispatched: $type with payload: $payload');
  }
}

/// The singleton core of the package.
class RemoteUI {
  static final RemoteUI _instance = RemoteUI._internal();
  
  factory RemoteUI() => _instance;
  
  RemoteUI._internal();
  
  late WidgetRegistry _registry;
  late ActionHandler _actionHandler;
  late Logger _logger;
  
  bool _isInitialized = false;

  /// Initialize the engine with dependencies.
  static void init({
    WidgetRegistry? registry,
    ActionHandler? actionHandler,
    Logger? logger,
  }) {
    _instance._registry = registry ?? WidgetRegistry();
    _instance._actionHandler = actionHandler ?? DefaultActionHandler();
    _instance._logger = logger ?? Logger('RemoteUI');
    _instance._isInitialized = true;
  }
  
  static WidgetRegistry get registry {
    if (!_instance._isInitialized) {
      throw Exception('RemoteUI not initialized. Call RemoteUI.init() first.');
    }
    return _instance._registry;
  }
  
  static ActionHandler get actionHandler {
    if (!_instance._isInitialized) {
      // Return default if not initialized, or throw? Better to be safe.
      return DefaultActionHandler();
    }
    return _instance._actionHandler;
  }

  static Logger get logger => _instance._logger;
}
