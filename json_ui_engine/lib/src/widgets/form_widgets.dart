import 'package:flutter/material.dart';
import '../core/widget_registry.dart';
import '../model/data_models.dart';
import '../engine/state_controller.dart';

class FormWidgets {
  static void register(WidgetRegistry registry) {
    registry.register('text_input', _buildTextInput);
  }

  static Widget _buildTextInput(BuildContext context, RemoteWidgetData data) {
    final bindKey = data.properties['bind'] as String?;
    final hintText = data.properties['hintText'] as String?;
    final labelText = data.properties['labelText'] as String?;
    final validators = data.properties['validators'] as List<dynamic>?;
    final obscureText = data.properties['obscureText'] == true;

    return _BoundTextInput(
      bindKey: bindKey,
      hintText: hintText,
      labelText: labelText,
      validators: validators,
      obscureText: obscureText,
    );
  }
}

class _BoundTextInput extends StatefulWidget {
  final String? bindKey;
  final String? hintText;
  final String? labelText;
  final List<dynamic>? validators;
  final bool obscureText;

  const _BoundTextInput({
    this.bindKey,
    this.hintText,
    this.labelText,
    this.validators,
    this.obscureText = false,
  });

  @override
  State<_BoundTextInput> createState() => _BoundTextInputState();
}

class _BoundTextInputState extends State<_BoundTextInput> {
  late TextEditingController _controller;
  RemoteStateController? _stateController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stateController = RemoteStateProvider.of(context);
    
    // Initialize value from state if bound
    String initialValue = '';
    if (widget.bindKey != null && _stateController != null) {
      final val = _stateController!.getValue(widget.bindKey!);
      if (val != null) {
        initialValue = val.toString();
      }
    }
    
    _controller = TextEditingController(text: initialValue);
    
    // Note: If external state changes, we might want to update _controller.text.
    // However, allowing two-way binding with typing can cause cursor jumps.
    // For V1, we favor "Input drives State". State driving Input is initialization only.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (widget.validators == null) return null;
    for (final v in widget.validators!) {
      if (v is Map) {
        final rule = v['rule'];
        final message = v['message'] ?? 'Invalid';
        
        switch (rule) {
          case 'required':
             if (value == null || value.isEmpty) return message;
             break;
          case 'regex':
             if (value != null && value.isNotEmpty) {
               final pattern = v['pattern'];
               if (pattern != null && !RegExp(pattern).hasMatch(value)) {
                 return message;
               }
             }
             break;
          case 'minLength':
             final min = v['value'] as int?;
             if (min != null && value != null && value.length < min) return message;
             break;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        errorText: _validate(_controller.text), // Simple immediate validation feedback or null
      ),
      onChanged: (value) {
        // Update state
        if (widget.bindKey != null && _stateController != null) {
          _stateController!.setValue(widget.bindKey!, value);
          // Force rebuild for validation message update if using manual validation display
          setState(() {}); 
        }
      },
      // If we want standard Form integration, we should use TextFormField, but that requires a Form parent.
      // For now, standalone TextField with bound state is sufficient for JSON UI.
    );
  }
}
