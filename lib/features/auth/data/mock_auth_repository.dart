import 'package:hive_ce/hive.dart';

import '../../../core/utils/result.dart';
import '../domain/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final Box<dynamic> sessionBox;
  String? _currentUserEmail;
  bool _isLoggedIn = false;

  MockAuthRepository({required this.sessionBox});

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  String? get currentUserEmail => _currentUserEmail;

  @override
  Future<void> restoreSession() async {
    final email = sessionBox.get('email') as String?;
    final token = sessionBox.get('token') as String?;
    if (email != null && token != null && email.isNotEmpty) {
      _currentUserEmail = email;
      _isLoggedIn = true;
    }
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
    required bool keepSignedIn,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final trimmedEmail = email.trim();
    final mockToken = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';

    _currentUserEmail = trimmedEmail;
    _isLoggedIn = true;

    if (keepSignedIn) {
      sessionBox.put('email', trimmedEmail);
      sessionBox.put('token', mockToken);
      sessionBox.put('loggedInAt', DateTime.now().toIso8601String());
    } else {
      sessionBox.clear();
    }

    return Result.success(null);
  }

  @override
  Future<void> logout() async {
    await sessionBox.clear();
    _currentUserEmail = null;
    _isLoggedIn = false;
  }
}
