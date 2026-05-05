import 'package:bookvers/presentation/pages/add_edit_book_screen.dart';
import 'package:bookvers/presentation/pages/analytics_screen.dart';
import 'package:bookvers/presentation/pages/library_screen.dart';
import 'package:bookvers/presentation/pages/login_screen.dart';
import 'package:bookvers/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Ключи маршрутов
const String loginRoute = '/login';
const String libraryRoute = '/library';
const String addBookRoute = '/add-book';
const String analyticsRoute = '/analytics';

/// Provider для GoRouter с аутентификацией
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: isAuthenticated ? libraryRoute : loginRoute,
    routes: [
      // Маршрут логина
      GoRoute(
        path: loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Защищённые маршруты (требуют авторизации)
      GoRoute(
        path: libraryRoute,
        name: 'library',
        builder: (context, state) {
          // Если не авторизован, редиректим на логин
          if (!isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(loginRoute);
            });
          }
          return const LibraryScreen();
        },
        routes: [
          GoRoute(
            path: 'add',
            name: 'add-book',
            builder: (context, state) => const AddEditBookScreen(),
          ),
          GoRoute(
            path: 'analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Ошибка: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(loginRoute),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    ),
  );
});

