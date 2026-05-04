import 'package:bookvers/presentation/viewmodels/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('ThemeNotifier Tests', () {
    late ThemeNotifier themeNotifier;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      themeNotifier = ThemeNotifier(mockPrefs);
    });

    group('Initialization', () {
      test('Инициализируется с системной темой по умолчанию', () {
        expect(themeNotifier.state, ThemeMode.system);
      });

      test('Загружает сохраненную тему при инициализации', () async {
        when(() => mockPrefs.getString('themeMode')).thenReturn('light');

        await themeNotifier.initialize();

        expect(themeNotifier.state, ThemeMode.light);
      });

      test('Использует системную тему если нет сохраненной', () async {
        when(() => mockPrefs.getString('themeMode')).thenReturn(null);

        await themeNotifier.initialize();

        expect(themeNotifier.state, ThemeMode.system);
      });

      test('Обрабатывает некорректное значение темы', () async {
        when(() => mockPrefs.getString('themeMode'))
            .thenReturn('invalid_theme');

        await themeNotifier.initialize();

        // Должно вернуться на системную тему
        expect(themeNotifier.state, ThemeMode.system);
      });
    });

    group('Theme Switching', () {
      test('Переключается между светлой и тёмной темой', () async {
        when(() => mockPrefs.setString('themeMode', any()))
            .thenAnswer((_) async => true);

        await themeNotifier.setTheme(ThemeMode.light);
        expect(themeNotifier.state, ThemeMode.light);

        await themeNotifier.setTheme(ThemeMode.dark);
        expect(themeNotifier.state, ThemeMode.dark);
      });

      test('Устанавливает системную тему', () async {
        when(() => mockPrefs.setString('themeMode', any()))
            .thenAnswer((_) async => true);

        await themeNotifier.setTheme(ThemeMode.system);
        expect(themeNotifier.state, ThemeMode.system);
      });

      test('Сохраняет тему в SharedPreferences', () async {
        when(() => mockPrefs.setString('themeMode', 'light'))
            .thenAnswer((_) async => true);

        await themeNotifier.setTheme(ThemeMode.light);

        verify(() => mockPrefs.setString('themeMode', 'light')).called(1);
      });
    });

    group('Toggle Theme', () {
      test('Переключает тему циклически: light -> dark -> system -> light',
          () async {
        when(() => mockPrefs.setString('themeMode', any()))
            .thenAnswer((_) async => true);

        // Light -> Dark
        await themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.light);

        // Dark
        await themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.dark);

        // System
        await themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.system);

        // Light (снова)
        await themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.light);
      });

      test('Сохраняет переключённую тему', () async {
        when(() => mockPrefs.setString('themeMode', any()))
            .thenAnswer((_) async => true);

        await themeNotifier.toggleTheme();

        verify(() => mockPrefs.setString('themeMode', any())).called(1);
      });
    });

    group('Theme Labels', () {
      test('Возвращает правильный лейбл для светлой темы', () {
        themeNotifier.state = ThemeMode.light;
        expect(themeNotifier.getThemeLabel(), 'Светлая');
      });

      test('Возвращает правильный лейбл для тёмной темы', () {
        themeNotifier.state = ThemeMode.dark;
        expect(themeNotifier.getThemeLabel(), 'Тёмная');
      });

      test('Возвращает правильный лейбл для системной темы', () {
        themeNotifier.state = ThemeMode.system;
        expect(themeNotifier.getThemeLabel(), 'Система');
      });
    });

    group('State Persistence', () {
      test('Тема сохраняется при перезагрузке приложения', () async {
        when(() => mockPrefs.setString('themeMode', 'dark'))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.getString('themeMode')).thenReturn('dark');

        await themeNotifier.setTheme(ThemeMode.dark);

        // Имитируем новый экземпляр notifier
        final newNotifier = ThemeNotifier(mockPrefs);
        await newNotifier.initialize();

        expect(newNotifier.state, ThemeMode.dark);
      });

      test('Сохранённые настройки загружаются корректно', () async {
        final themes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];

        for (final theme in themes) {
          when(() => mockPrefs.setString(
                'themeMode',
                theme.toString().split('.').last,
              )).thenAnswer((_) async => true);

          when(() => mockPrefs.getString('themeMode'))
              .thenReturn(theme.toString().split('.').last);

          await themeNotifier.setTheme(theme);

          final newNotifier = ThemeNotifier(mockPrefs);
          await newNotifier.initialize();

          expect(newNotifier.state, theme);
        }
      });
    });
  });
}
