import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';
import '../widgets/neumorphic_category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Software Development',
      'Hardware Engineering',
      'Artificial Intelligence',
      'Data Science',
      'Cybersecurity',
    ];

    final categoryColors = [
      Colors.blue.shade800,
      Colors.red.shade800,
      Colors.green.shade800,
      Colors.orange.shade800,
      Colors.purple.shade800,
    ];

    final categoryIcons = [
      Icons.code,
      Icons.memory,
      Icons.smart_toy,
      Icons.analytics,
      Icons.security,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Link'),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigate back to LandingScreen
            Navigator.pushReplacementNamed(context, '/landing');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              final auth = Provider.of<AuthService>(context, listen: false);
              try {
                await auth.signOut();
                // Clear any navigation stack and go to landing
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/landing',
                  (route) => false,
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(categories.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: NeumorphicCategoryCard(
                title: categories[index],
                icon: categoryIcons[index],
                backgroundColor: categoryColors[index],
                onTap: () {
                  Navigator.pushNamed(context, '/courses',
                      arguments: categories[index]);
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
