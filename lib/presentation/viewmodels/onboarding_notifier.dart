import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingNotifier extends StateNotifier<int> {
  static const _onboardingKey = 'onboarding_completed';

  OnboardingNotifier(this._prefs) : super(0);

  final SharedPreferences _prefs;

  /// Возвращает true если онбординг уже пройден
  bool get isCompleted => _prefs.getBool(_onboardingKey) ?? false;

  /// Переходит на следующий слайд
  void nextPage(PageController pageController) {
    if (state < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Помечает онбординг как завершённый
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingKey, true);
    state = 4; // Сигнал что завершено
  }

  /// Обновляет текущий индекс страницы
  void updatePage(int index) {
    state = index;
  }

  /// Пропускает онбординг
  Future<void> skipOnboarding() async {
    await completeOnboarding();
  }
}

/// Provider для OnboardingNotifier
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, int>((ref) {
  return OnboardingNotifier(
    throw Exception('SharedPreferences not initialized'),
  );
});

/// Provider для проверки нужен ли онбординг
final shouldShowOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final isCompleted = prefs.getBool('onboarding_completed') ?? false;
  return !isCompleted;
});
