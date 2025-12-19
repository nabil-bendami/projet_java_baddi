import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:frontend_flutter/main.dart';
import 'package:frontend_flutter/features/auth/providers/auth_provider.dart';

void main() {
  setUpAll(() async {
    // Initialize date formatting for tests
    await initializeDateFormatting('fr_FR', null);
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
        child: const PresenceApp(),
      ),
    );

    // Verify that splash screen or login screen appears
    await tester.pumpAndSettle();

    // The app should start without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
