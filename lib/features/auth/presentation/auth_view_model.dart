import 'package:flutter/material.dart';

import '../domain/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel({required this.authRepository});

  bool get isLoggedIn => authRepository.isLoggedIn;
  String? get currentUserEmail => authRepository.currentUserEmail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> restoreSession() async {
    await authRepository.restoreSession();
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool keepSignedIn,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await authRepository.login(
      email: email,
      password: password,
      keepSignedIn: keepSignedIn,
    );

    _isLoading = false;

    return result.when(
      success: (_) {
        notifyListeners();
        return true;
      },
      err: (failure) {
        _errorMessage = failure.when(
          noInternet: () => 'No internet connection',
          timeout: () => 'Request timed out',
          invalidResponse: () => 'Invalid credentials format',
          server: (code) => 'Server error',
          unknown: (msg) => msg ?? 'Login failed. Please try again.',
        );
        notifyListeners();
        return false;
      },
    );
  }

  Future<void> logout() async {
    await authRepository.logout();
    notifyListeners();
  }
}
