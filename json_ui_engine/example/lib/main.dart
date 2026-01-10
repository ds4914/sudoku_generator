import 'package:flutter/material.dart';
import 'package:flutter_remote_ui/flutter_remote_ui.dart';

void main() {
  // 1. Initialize the engine with default widgets
  RemoteUI.init(
    registry: createDefaultRegistry(),
    logger: null, // use default
    actionHandler: MyActionHandler(),
  );

  runApp(const MyApp());
}

class MyActionHandler implements ActionHandler {
  @override
  void onAction(String type, Map<String, dynamic> payload) {
    debugPrint('Native Action: $type -> $payload');
    if (type == 'snack') {
      // Accessing global context in real app, simplified here
      debugPrint('Show Snackbar: ${payload['message']}');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Remote UI Demo')),
        body: const DemoScreen(),
      ),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Define some JSON (simulating remote response)
    const jsonMap = {
      "type": "column",
      "style": {"padding": 16, "backgroundColor": "#F5F5F5"},
      "children": [
        {
          "type": "text",
          "props": {
            "text": "Remote UI Login",
            "style": {"fontSize": 24, "fontWeight": "bold", "color": "#333333"},
            "textAlign": "center"
          },
          "style": {
            "padding": {"bottom": 24}
          }
        },
        {
          "type": "conditional",
          "props": {
            "condition": "\${showError} == true",
            "true": {
              "type": "text",
              "props": {
                "text": "Invalid Credentials!",
                "style": {"color": "#FF0000"}
              }
            }
          }
        },
        {
          "type": "text_input",
          "props": {
            "bind": "email",
            "labelText": "Email Address",
            "hintText": "user@example.com",
            "validators": [
              {"rule": "required", "message": "Email required"},
              {"rule": "regex", "pattern": "^\\S+@\\S+\\.\\S+\$", "message": "Bad format"}
            ]
          },
          "style": {
            "padding": {"bottom": 16}
          }
        },
        {
          "type": "text_input",
          "props": {
            "bind": "password",
            "labelText": "Password",
            "obscureText": true,
            "validators": [
              {"rule": "minLength", "value": 6}
            ]
          },
          "style": {
            "padding": {"bottom": 24}
          }
        },
        {
          "type": "button",
          "props": {"label": "Sign In"},
          "actions": {
            "onTap": {
              "type": "snack",
              "payload": {"message": "Login Clicked!"}
            }
          }
        }
      ]
    };

    // 3. Render it
    return SafeArea(
      child: RemoteUIRenderer.data(
        data: RemoteWidgetData.fromJson(jsonMap),
      ),
    );
  }
}
