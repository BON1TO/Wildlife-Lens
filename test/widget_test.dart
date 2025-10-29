import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 👇 Use the right import based on your pubspec.yaml name
// Open pubspec.yaml and check the first line:
// name: animallens
// (or name: medilens if you didn't rename it)
import 'package:animallens/main.dart'; // ✅ all lowercase, single slash

void main() {
  testWidgets('AnimalLens builds successfully', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const AnimalLensApp());

    // Verify that the MaterialApp is present
    expect(find.byType(MaterialApp), findsOneWidget);

    // Optional: check if the title or home screen widget exists
    // expect(find.textContaining('AnimalLens'), findsWidgets);
  });
}
