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
      Colors.orange.shade700,
      Colors.purple.shade700,
      const Color.fromARGB(255, 198, 0, 0),
      Colors.green.shade700,
      const Color.fromARGB(255, 2, 107, 255),
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
        title: const Text(
          'Skill Link',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 4,
        shadowColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/landing');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final auth = Provider.of<AuthService>(context, listen: false);
              try {
                await auth.logout(); // Changed from signOut to logout
                Navigator.pushNamedAndRemoveUntil(
                    context, '/landing', (route) => false);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 85, 167, 239),
              const Color.fromARGB(255, 177, 201, 238),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Explore Skills',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select a category to start learning',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
