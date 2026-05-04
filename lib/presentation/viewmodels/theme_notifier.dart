import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _themeKey = 'themeMode';

  ThemeNotifier(this._prefs) : super(ThemeMode.system);

  final SharedPreferences _prefs;

  /// Загружает сохраненную тему при инициализации
  Future<void> initialize() async {
    final saved = _prefs.getString(_themeKey);
    if (saved != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == 'ThemeMode.$saved',
        orElse: () => ThemeMode.system,
      );
    }
  }

  /// Переключает режим темы (light -> dark -> system -> light)
  Future<void> toggleTheme() async {
    final themes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    final currentIndex = themes.indexOf(state);
    final nextIndex = (currentIndex + 1) % themes.length;
    await setTheme(themes[nextIndex]);
  }

  /// Устанавливает конкретный режим темы
  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final modeString = mode.toString().split('.').last;
    await _prefs.setString(_themeKey, modeString);
  }

  /// Возвращает текстовое описание текущей темы
  String getThemeLabel() {
    switch (state) {
      case ThemeMode.light:
        return 'Светлая';
      case ThemeMode.dark:
        return 'Тёмная';
      case ThemeMode.system:
        return 'Система';
    }
  }
}
