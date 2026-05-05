import 'package:bookvers/presentation/pages/register_screen.dart';
import 'package:bookvers/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Заголовок
              Text(
                'BookVerse',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Добро пожаловать в вашу библиотеку',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 48),

              // Email поле
              Text(
                'Email',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !authState.maybeWhen(loading: () => true, orElse: () => false),
                decoration: InputDecoration(
                  hintText: 'example@email.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // Пароль поле
              Text(
                'Пароль',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !authState.maybeWhen(loading: () => true, orElse: () => false),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Кнопка входа
              authState.maybeWhen(
                loading: () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: null,
                    icon: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    label: const Text('Вход...'),
                  ),
                ),
                orElse: () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSignIn,
                    child: const Text('Войти'),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Ссылка на регистрацию
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: authState.maybeWhen(
                    loading: () => null,
                    orElse: () => () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                  ),
                  child: const Text('Нет аккаунта? Зарегистрироваться'),
                ),
              ),
              const SizedBox(height: 24),

              // Разделитель
              Row(
                children: [
                  Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'или',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                ],
              ),
              const SizedBox(height: 24),

              // Demo кнопка для тестирования
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: authState.maybeWhen(
                    loading: () => null,
                    orElse: () => () {
                      _emailController.text = 'demo@example.com';
                      _passwordController.text = 'password123';
                      _handleSignIn();
                    },
                  ),
                  child: const Text('Тестовый вход'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: demo@example.com',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Пароль: password123',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
