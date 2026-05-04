import 'package:bookvers/core/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/theme_notifier.dart';

/// Provider для управления ThemeMode
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).maybeWhen(
    data: (prefs) => prefs,
    orElse: () => throw Exception('SharedPreferences not initialized'),
  );
  
  final notifier = ThemeNotifier(prefs);
  // Инициализация асинхронно
  Future.microtask(() => notifier.initialize());
  
  return notifier;
});
