import 'package:bookvers/data/repositories/firebase_auth_repository.dart';
import 'package:bookvers/domain/entities/app_user.dart';
import 'package:bookvers/domain/repositories/auth_repository.dart';
import 'package:bookvers/presentation/viewmodels/auth_notifier.dart';
import 'package:bookvers/presentation/viewmodels/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider для AuthRepository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return LocalAuthRepository();
});

/// Provider для AuthNotifier (управление состоянием входа/регистрации)
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Provider для проверки, авторизован ли пользователь
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.whenOrNull(authenticated: (_) => true) ?? false;
});

/// Provider для получения текущего пользователя
final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authNotifierProvider).whenOrNull(authenticated: (user) => user);
});

