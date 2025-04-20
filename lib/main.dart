import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_scaffold.dart';
import 'screens/onboarding_screen.dart';
import 'screens/quiz_screen.dart';
import 'services/theme_service.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProxyProvider<ThemeService, ThemeProvider>(
          create: (context) => ThemeProvider(context.read<ThemeService>()),
          update: (context, themeService, previous) => ThemeProvider(themeService),
        ),
      ],
      child: QuizmoApp(),
    ),
  );
}

Future<bool> _isOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_complete') ?? false;
}

class QuizmoApp extends StatelessWidget {
  const QuizmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Quizmo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: FutureBuilder<bool>(
        future: _isOnboardingComplete(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final onboardingComplete = snapshot.data!;
          return onboardingComplete
              ? const MainScaffold()
              : OnboardingScreen(
                  onFinish: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('onboarding_complete', true);
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const MainScaffold(),
                        ),
                      );
                    }
                  },
                );
        },
      ),
      routes: {
        '/home': (context) => const MainScaffold(initialIndex: 0),
        '/categories': (context) => const MainScaffold(initialIndex: 1),
        '/profile': (context) => const MainScaffold(initialIndex: 2),
        '/settings': (context) => const MainScaffold(initialIndex: 3),
        '/quiz': (context) => const QuizScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(child: Text('Page Not Found')),
          ),
        );
      },
    );
  }
}


