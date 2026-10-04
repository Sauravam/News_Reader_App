import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newspulse/core/error/failures.dart';
import 'package:newspulse/core/widgets/error_view.dart';

void main() {
  group('ErrorView Widget Tests', () {
    testWidgets('renders No Internet title and message for noInternet failure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(failure: Failure.noInternet()),
          ),
        ),
      );

      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.text('Please check your internet connection and try again.'), findsOneWidget);
    });

    testWidgets('renders retry button when onRetry callback is provided', (tester) async {
      var retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              failure: const Failure.timeout(),
              onRetry: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(retried, isTrue);
    });
  });
}
