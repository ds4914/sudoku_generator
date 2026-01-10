import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/data_models.dart';
import '../core/remote_ui.dart';
import 'state_controller.dart';

/// The main entry point for rendering Remote UI trees.
class RemoteUIRenderer extends StatefulWidget {
  final RemoteWidgetData? data;
  final String? url;
  final Map<String, dynamic>? initialData;
  final Widget? placeholder;
  final Widget Function(dynamic error)? errorBuilder;
  final Map<String, String>? headers;

  const RemoteUIRenderer.data({
    super.key,
    required this.data,
    this.placeholder,
    this.errorBuilder,
  })  : url = null,
        initialData = null,
        headers = null;

  const RemoteUIRenderer.network({
    super.key,
    required String this.url,
    this.placeholder,
    this.errorBuilder,
    this.headers,
    this.initialData,
  })  : data = null;

  @override
  State<RemoteUIRenderer> createState() => _RemoteUIRendererState();
}

class _RemoteUIRendererState extends State<RemoteUIRenderer> {
  RemoteWidgetData? _data;
  bool _isLoading = false;
  dynamic _error;
  late RemoteStateController _stateController;

  @override
  void initState() {
    super.initState();
    _stateController = RemoteStateController(widget.initialData);
    if (widget.data != null) {
      _data = widget.data;
    } else if (widget.url != null) {
      _fetchData();
    }
  }

  @override
  void didUpdateWidget(RemoteUIRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      setState(() => _data = widget.data);
    }
    if (widget.url != oldWidget.url) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse(widget.url!),
        headers: widget.headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        // Validating structure
        if (json.containsKey('type')) {
           final validData = RemoteWidgetData.fromJson(json);
           if (mounted) {
             setState(() {
               _data = validData;
               _isLoading = false;
             });
           }
        } else {
           throw Exception('Invalid JSON structure: missing root "type"');
        }
      } else {
        throw Exception('Failed to load remote UI: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return widget.errorBuilder?.call(_error) ??
          Center(child: Text('Error loading UI: $_error'));
    }

    if (_data == null) {
      return const SizedBox.shrink();
    }

    // Delegate to registry for recursive building
    return RemoteStateProvider(
      controller: _stateController,
      child: RemoteUI.registry.build(context, _data!),
    );
  }
}
