import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
import 'utils/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
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
      // Remove initialRoute and use home with AuthWrapper instead
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
              settings: RouteSettings(
                arguments: categoryTitle,
              ),
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
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Authentication error occurred'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => authService.clearAuthCache(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data;
        debugPrint('AuthWrapper user state: ${user?.uid}');

        if (user == null) {
          return const LandingScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
