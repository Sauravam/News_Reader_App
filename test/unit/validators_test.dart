import 'package:flutter_test/flutter_test.dart';
import 'package:newspulse/features/auth/domain/validators.dart';

void main() {
  group('Validators - Email', () {
    test('returns error when email is null or empty', () {
      expect(Validators.validateEmail(null), 'Email is required');
      expect(Validators.validateEmail(''), 'Email is required');
      expect(Validators.validateEmail('   '), 'Email is required');
    });

    test('returns error for invalid email patterns', () {
      final invalidEmails = [
        'plainaddress',
        'invalid#email.com',
        '@example.com',
        'Joe Smith <email@example.com>',
        'email.example.com',
        'email@example@example.com',
        'email@example.a',
      ];

      for (final email in invalidEmails) {
        expect(
          Validators.validateEmail(email),
          'Enter a valid email address',
          reason: 'Failed for email: $email',
        );
      }
    });

    test('returns null for valid email addresses', () {
      final validEmails = [
        'email@example.com',
        'firstname.lastname@example.com',
        'email@subdomain.example.com',
        'firstname+lastname@example.com',
        '1234567890@example.com',
        'email@example.co.uk',
      ];

      for (final email in validEmails) {
        expect(
          Validators.validateEmail(email),
          isNull,
          reason: 'Failed for valid email: $email',
        );
      }
    });
  });

  group('Validators - Password', () {
    test('returns error when password is null or empty', () {
      expect(Validators.validatePassword(null), 'Password is required');
      expect(Validators.validatePassword(''), 'Password is required');
    });

    test('returns error when password is less than 8 characters', () {
      expect(
        Validators.validatePassword('Pass1'),
        'Password must be at least 8 characters',
      );
    });

    test('returns error when password lacks letters', () {
      expect(
        Validators.validatePassword('12345678'),
        'Password must contain at least one letter',
      );
    });

    test('returns error when password lacks digits', () {
      expect(
        Validators.validatePassword('Password'),
        'Password must contain at least one digit',
      );
    });

    test('returns null for valid passwords', () {
      expect(Validators.validatePassword('Secret123'), isNull);
      expect(Validators.validatePassword('P@ssword123'), isNull);
    });
  });
}
