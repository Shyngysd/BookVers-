import 'package:bookvers/domain/entities/app_user.dart';

abstract class IAuthRepository {
  /// Вход в систему
  Future<AppUser> signIn(String email, String password);

  /// Регистрация нового пользователя
  Future<AppUser> signUp(String email, String password);

  /// Выход из системы
  Future<void> signOut();

  /// Получить текущего пользователя
  AppUser? get currentUser;
}
