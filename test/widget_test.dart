import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:first_app/main.dart';
import 'package:first_app/providers/skill_provider.dart';

void main() {
  testWidgets('SkillSprint app loads successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => SkillProvider(),
        child: const SkillSprintApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('SkillSprint'), findsWidgets);
  });
}