import 'package:flutter/widgets.dart';

/// Manages the runtime state (variables, form data) for a Remote UI tree.
class RemoteStateController extends ChangeNotifier {
  final Map<String, dynamic> _values = {};

  RemoteStateController(Map<String, dynamic>? initialValues) {
    if (initialValues != null) {
      _values.addAll(initialValues);
    }
  }

  dynamic getValue(String path) {
    // Basic support for "key" (nested dot notation later if needed)
    return _values[path];
  }

  void setValue(String path, dynamic value) {
    if (_values[path] != value) {
      _values[path] = value;
      notifyListeners();
    }
  }
  
  Map<String, dynamic> getAll() => Map.unmodifiable(_values);
}

class RemoteStateProvider extends InheritedNotifier<RemoteStateController> {
  const RemoteStateProvider({
    super.key,
    required RemoteStateController controller,
    required super.child,
  }) : super(notifier: controller);

  static RemoteStateController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RemoteStateProvider>()
        ?.notifier;
  }
}
