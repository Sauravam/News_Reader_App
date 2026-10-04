import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newspulse/features/auth/domain/auth_repository.dart';
import 'package:newspulse/features/auth/presentation/auth_view_model.dart';
import 'package:newspulse/features/auth/presentation/login_screen.dart';
import 'package:provider/provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthViewModel authViewModel;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.isLoggedIn).thenReturn(false);
    when(() => mockAuthRepository.currentUserEmail).thenReturn(null);
    authViewModel = AuthViewModel(authRepository: mockAuthRepository);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthViewModel>.value(
        value: authViewModel,
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders News Reader logo, header and sign-in form', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('News Reader'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('shows validation errors when invalid email is entered', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      final submitButton = find.text('Sign In');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });
  });
}
