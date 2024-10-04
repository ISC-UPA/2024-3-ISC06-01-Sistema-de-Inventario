// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';
import 'package:frontend/theme/app_theme.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Crear una instancia de AppThemeNotifier
    final themeNotifier = AppThemeNotifier();

    // Build our app and trigger a frame, sin usar const porque se pasa un objeto no constante.
    await tester.pumpWidget(MyApp(themeNotifier: themeNotifier));

    // Verificar que el contador comience en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Simular el tap en el ícono '+' y actualizar la vista.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verificar que el contador haya incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
