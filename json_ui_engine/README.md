# Flutter Remote UI
[![pub package](https://img.shields.io/pub/v/flutter_remote_ui.svg)](https://pub.dev/packages/flutter_remote_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A production-ready Flutter package that enables fully JSON-driven, remote-configurable UIs.
Designed for server-driven UI (SDUI) in apps that require instant updates, A/B testing, and dynamic content without app store releases.

## Features

- **Strict JSON Schema**: Type-safe rendering with fail-soft error handling.
- **Native Performance**: Maps JSON directly to Flutter widgets (no WebViews).
- **Core Widget Set**: Column, Row, Stack, Text, Image, Button.
- **Form System**: Input binding, validation rules, and state management.
- **Logic Engine**: Conditional rendering and expressions (`${variable} > 0`).
- **Extensible Registry**: Register your own custom widgets easily.
- **Aesthetics**: Support for style properties like padding, margins, colors, and layouts.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_remote_ui: ^1.0.0
```

## Quick Start

### 1. Initialize the Engine
In your `main.dart`, initialize the `RemoteUI` singleton with a registry. You can use `createDefaultRegistry()` to get the standard set of widgets.

```dart
import 'package:flutter_remote_ui/flutter_remote_ui.dart';

void main() {
  RemoteUI.init(
    registry: createDefaultRegistry(),
    // Optional: Add custom action handlers or logger
    actionHandler: MyActionHandler(),
  );
  runApp(const MyApp());
}
```

### 2. Render a UI
Use `RemoteUIRenderer` to fetch and render the JSON. You can load from a network URL or provide the data directly.

**From Network:**
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RemoteUIRenderer.network(
        url: 'https://api.myapp.com/screens/home.json',
        placeholder: const Center(child: CircularProgressIndicator()),
        errorBuilder: (e) => Center(child: Text('Failed to load: $e')),
      ),
    );
  }
}
```

**From Data (Direct):**
```dart
RemoteUIRenderer.data(
  data: RemoteWidgetData.fromJson(myJsonMap),
  initialData: { "username": "JohnDoe" }, // Initial state variables
)
```

## JSON Schema Example

A simple screen with a column, text, and a conditional button.

```json
{
  "type": "column",
  "style": { "padding": 16, "backgroundColor": "#FFFFFF" },
  "children": [
    {
      "type": "text",
      "props": {
        "text": "Welcome, ${username}!",
        "style": { "fontSize": 24, "fontWeight": "bold" }
      }
    },
    {
      "type": "conditional",
      "props": {
        "condition": "${cartCount} > 0",
        "true": {
           "type": "button",
           "props": { "label": "Checkout Now" },
           "actions": {
             "onTap": { "type": "navigate", "payload": { "route": "/cart" } }
           }
        }
      }
    }
  ]
}
```

## Supported Widgets

The default registry includes:

| Type          | Description                               |
|---------------|-------------------------------------------|
| `column`      | Vertical layout (Flex)                    |
| `row`         | Horizontal layout (Flex)                  |
| `stack`       | Z-axis layout                             |
| `text`        | Renders text with style properties        |
| `image`       | Renders network images                    |
| `button`      | Native clickable button                   |
| `sized_box`   | Spacer with width/height                  |
| `text_input`  | Form input bound to state variables       |
| `conditional` | Logic widget for rendering based on state |

## Forms & State Binding

Widgets can bind to the local state controller using the `bind` property. 

```json
{
  "type": "text_input",
  "props": {
    "bind": "email", 
    "labelText": "Email Address",
    "validators": [
      { "rule": "required", "message": "Required" },
      { "rule": "regex", "pattern": "^\\S+@\\S+\\.\\S+$", "message": "Invalid Email" }
    ]
  }
}
```
Use `${variableName}` syntax in text or condition strings to access these values.

## Extensibility

You can register custom widgets to handle valid Flutter widgets that aren't in the core set.

```dart
// 1. Define the builder
Widget buildMyCustomWidget(BuildContext context, RemoteWidgetData data) {
  return MyFancyWidget(
    title: data.props['title'],
    color: StyleUtils.parseColor(data.props['color']),
  );
}

// 2. Register it
RemoteUI.registry.register('my_fancy_widget', buildMyCustomWidget);
```

Then use it in JSON:
```json
{
  "type": "my_fancy_widget",
  "props": { "title": "Hello", "color": "#FF0000" }
}
```

## Contributing

Contributions are welcome! Please check out the [example](example) directory for a functional demo.

## License

MIT
