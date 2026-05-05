import 'package:bookvers/core/exceptions/auth_exceptions.dart';
import 'package:bookvers/domain/repositories/auth_repository.dart';
import 'package:bookvers/presentation/viewmodels/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState.initial());

  /// Вход в систему
  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.signIn(email, password);
      state = AuthState.authenticated(user);
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Ошибка входа: ${e.toString()}');
    }
  }

  /// Регистрация
  Future<void> signUp(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.signUp(email, password);
      state = AuthState.authenticated(user);
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Ошибка регистрации: ${e.toString()}');
    }
  }

  /// Выход из системы
  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await _authRepository.signOut();
      state = const AuthState.initial();
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Ошибка выхода: ${e.toString()}');
    }
  }

  /// Очистить ошибку
  void clearError() {
    state = const AuthState.initial();
  }
}
