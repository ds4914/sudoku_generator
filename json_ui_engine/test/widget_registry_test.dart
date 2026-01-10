import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_remote_ui_kit/flutter_remote_ui_kit.dart';

void main() {
  test('RemoteWidgetData parses JSON correctly', () {
    final json = {
      'type': 'column',
      'id': 'col1',
      'props': {'mainAxisAlignment': 'center'},
      'children': [
        {'type': 'text'}
      ]
    };
    
    final data = RemoteWidgetData.fromJson(json);
    
    expect(data.type, 'column');
    expect(data.id, 'col1');
    expect(data.properties['mainAxisAlignment'], 'center');
    expect(data.children?.length, 1);
    expect(data.children?.first.type, 'text');
  });

  testWidgets('WidgetRegistry returns fallback for unknown type', (tester) async {
    final registry = WidgetRegistry();
    
    // intentionally not registering anything
    
    const data = RemoteWidgetData(type: 'unknown_widget');
    
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) => registry.build(context, data),
        ),
      ),
    );
    
    // Default fallback is SizedBox.shrink, which has size 0
    // But testing that it doesn't crash is enough.
    expect(find.byType(SizedBox), findsOneWidget);
  });
  
  testWidgets('WidgetRegistry wraps content with padding', (tester) async {
    final registry = WidgetRegistry();
    registry.register('box', (ctx, d) => Container(width: 10, height: 10, color: const Color(0xFF000000)));
    
    const data = RemoteWidgetData(
      type: 'box',
      style: {'padding': 10},
    );
    
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) => registry.build(context, data),
        ),
      ),
    );
    
    expect(find.byType(Padding), findsOneWidget);
  });
}
