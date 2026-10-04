import '../../../core/utils/result.dart';

abstract class AuthRepository {
  bool get isLoggedIn;
  String? get currentUserEmail;

  Future<void> restoreSession();
  Future<Result<void>> login({
    required String email,
    required String password,
    required bool keepSignedIn,
  });
  Future<void> logout();
}
