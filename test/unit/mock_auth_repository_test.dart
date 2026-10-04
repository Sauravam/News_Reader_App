import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:newspulse/features/auth/data/mock_auth_repository.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> sessionBox;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('hive_auth_test_');
    Hive.init(tempDir.path);
    sessionBox = await Hive.openBox<dynamic>('test_session');
  });

  tearDown(() async {
    await sessionBox.close();
    await Hive.deleteBoxFromDisk('test_session');
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('MockAuthRepository', () {
    test('login with keepSignedIn=true persists session to Hive', () async {
      final repository = MockAuthRepository(sessionBox: sessionBox);

      await repository.login(
        email: 'user@example.com',
        password: 'Password123',
        keepSignedIn: true,
      );

      expect(repository.isLoggedIn, isTrue);
      expect(repository.currentUserEmail, 'user@example.com');
      expect(sessionBox.get('email'), 'user@example.com');
    });

    test('login with keepSignedIn=false does not persist session to Hive box', () async {
      final repository = MockAuthRepository(sessionBox: sessionBox);

      await repository.login(
        email: 'user@example.com',
        password: 'Password123',
        keepSignedIn: false,
      );

      expect(repository.isLoggedIn, isTrue);
      expect(sessionBox.get('email'), isNull);
    });

    test('logout clears session box and resets auth state', () async {
      final repository = MockAuthRepository(sessionBox: sessionBox);

      await repository.login(
        email: 'user@example.com',
        password: 'Password123',
        keepSignedIn: true,
      );

      await repository.logout();

      expect(repository.isLoggedIn, isFalse);
      expect(repository.currentUserEmail, isNull);
      expect(sessionBox.isEmpty, isTrue);
    });
  });
}
