import 'package:bookvers/core/init_hive.dart';
import 'package:bookvers/core/preferences_provider.dart';
import 'package:bookvers/presentation/pages/library_screen.dart';
import 'package:bookvers/presentation/pages/onboarding_screen.dart';
import 'package:bookvers/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _onboardingCompleted = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final shouldShowOnboarding = ref.watch(shouldShowOnboardingProvider);

    return MaterialApp(
      title: 'BookVerse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeMode,
      home: shouldShowOnboarding.maybeWhen(
        data: (shouldShow) {
          if (shouldShow && !_onboardingCompleted) {
            return OnboardingScreen(
              onCompleted: () {
                setState(() {
                  _onboardingCompleted = true;
                });
              },
            );
          }
          return const LibraryScreen();
        },
        orElse: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
