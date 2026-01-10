import 'package:equatable/equatable.dart';

/// The core configuration object for any widget in the Remote UI system.
/// This matches the strict JSON schema defined in the architecture.
class RemoteWidgetData extends Equatable {
  /// Unique identifier for this node (optional, used for state/testing).
  final String? id;

  /// The widget type (e.g., 'column', 'text', 'button').
  final String type;

  /// Widget-specific properties (e.g., text content, url).
  final Map<String, dynamic> properties;

  /// Layout and decorative styles.
  final Map<String, dynamic>? style;

  /// Event handlers mapped by event name (e.g., 'onTap': Action(...)).
  final Map<String, RemoteAction>? actions;

  /// Child widgets, if any.
  final List<RemoteWidgetData>? children;

  const RemoteWidgetData({
    this.id,
    required this.type,
    this.properties = const {},
    this.style,
    this.actions,
    this.children,
  });

  factory RemoteWidgetData.fromJson(Map<String, dynamic> json) {
    return RemoteWidgetData(
      id: json['id'] as String?,
      type: json['type'] as String? ?? 'unknown',
      properties: json['props'] as Map<String, dynamic>? ?? const {},
      style: json['style'] as Map<String, dynamic>?,
      actions: (json['actions'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, RemoteAction.fromJson(value)),
      ),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => RemoteWidgetData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'props': properties,
      if (style != null) 'style': style,
      if (actions != null)
        'actions': actions!.map((k, v) => MapEntry(k, v.toJson())),
      if (children != null)
        'children': children!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, type, properties, style, actions, children];
}

/// Represents an action to be dispatched (e.g., navigation, api call).
class RemoteAction extends Equatable {
  final String type;
  final Map<String, dynamic> payload;

  const RemoteAction({
    required this.type,
    this.payload = const {},
  });

  factory RemoteAction.fromJson(Map<String, dynamic> json) {
    return RemoteAction(
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>? ?? json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': payload,
    };
  }

  @override
  List<Object?> get props => [type, payload];
}
