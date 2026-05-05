import 'package:bookvers/domain/entities/app_user.dart';
import 'package:bookvers/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Простая локальная авторизация (in-memory + SharedPreferences)
class LocalAuthRepository implements IAuthRepository {
  static final LocalAuthRepository _instance = LocalAuthRepository._internal();

  late SharedPreferences _prefs;
  AppUser? _currentUser;

  // Временное хранилище пользователей (в реальном приложении это будет БД или API)
  static final Map<String, String> _users = {
    'demo@example.com': 'password123',
    'test@example.com': 'test123456',
  };

  factory LocalAuthRepository() {
    return _instance;
  }

  LocalAuthRepository._internal();

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final userId = _prefs.getString('user_id');
    final userEmail = _prefs.getString('user_email');

    if (userId != null && userEmail != null) {
      _currentUser = AppUser(
        id: userId,
        email: userEmail,
        displayName: userEmail.split('@')[0],
        createdAt: DateTime.now(),
      );
    }
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    await _init();

    // Простая валидация
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email и пароль не должны быть пусты');
    }

    // Проверяем логин/пароль
    if (!_users.containsKey(email)) {
      throw Exception('Пользователь не найден. Зарегистрируйтесь.');
    }

    if (_users[email] != password) {
      throw Exception('Неверный пароль');
    }

    // Создаём пользователя
    final user = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: email.split('@')[0],
      createdAt: DateTime.now(),
    );

    // Сохраняем сессию
    await _prefs.setString('user_id', user.id);
    await _prefs.setString('user_email', user.email);

    _currentUser = user;
    return user;
  }

  @override
  Future<AppUser> signUp(String email, String password) async {
    await _init();

    // Простая валидация
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email и пароль не должны быть пусты');
    }

    if (password.length < 6) {
      throw Exception('Пароль должен быть минимум 6 символов');
    }

    if (!email.contains('@')) {
      throw Exception('Email должен быть валидным');
    }

    // Проверяем что пользователь уже не зарегистрирован
    if (_users.containsKey(email)) {
      throw Exception('Этот email уже зарегистрирован');
    }

    // Добавляем пользователя
    _users[email] = password;

    // Создаём объект пользователя
    final user = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: email.split('@')[0],
      createdAt: DateTime.now(),
    );

    // Сохраняем сессию
    await _prefs.setString('user_id', user.id);
    await _prefs.setString('user_email', user.email);

    _currentUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    await _init();
    await _prefs.remove('user_id');
    await _prefs.remove('user_email');
    _currentUser = null;
  }

  @override
  AppUser? get currentUser {
    return _currentUser;
  }
}
