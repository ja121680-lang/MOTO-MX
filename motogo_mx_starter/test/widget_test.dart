import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:motogo_mx/main.dart';

void main() {
  testWidgets('App boots to the gate screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MotoGoApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
