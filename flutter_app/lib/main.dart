import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/course_list_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/video_player_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/auth_screen.dart';

// Services & Utilities
import 'services/auth_services.dart';
import 'services/api_service.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences for token storage
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>(create: (_) => sharedPrefs),
        Provider<ApiService>(
          create: (context) => ApiService(sharedPrefs: sharedPrefs),
        ),
        Provider<AuthService>(
          create: (context) => AuthService(
            apiService: context.read<ApiService>(),
            sharedPrefs: sharedPrefs,
          ),
        ),
      ],
      child: const SkillLinkApp(),
    ),
  );
}

class SkillLinkApp extends StatelessWidget {
  const SkillLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Link',
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/landing': (context) => const LandingScreen(),
        '/categories': (context) => const CategoryScreen(),
        '/course_detail': (context) => const CourseDetailScreen(),
        '/payment': (context) => const PaymentScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/courses':
            final categoryTitle =
                settings.arguments as String? ?? 'All Courses';
            return MaterialPageRoute(
              builder: (context) => CourseListScreen(),
              settings: RouteSettings(arguments: categoryTitle),
            );
          case '/video_player':
            return MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                arguments: settings.arguments as Map<String, dynamic>,
              ),
            );
        }
        return null;
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<bool>(
      future: authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isAuthenticated = snapshot.data == true;
        debugPrint('AuthWrapper auth state: $isAuthenticated');

        return isAuthenticated ? const HomeScreen() : const LandingScreen();
      },
    );
  }
}
