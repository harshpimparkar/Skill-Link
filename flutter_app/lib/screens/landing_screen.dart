import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';
// Import the auth screen

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final username = user?.email?.split('@').first ?? 'Learner';
    final isLoggedIn = user != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(
                          isLoggedIn ? Icons.person : Icons.login,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isLoggedIn ? 'Welcome, $username!' : 'Welcome!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(isLoggedIn
                      ? 'Continue Your Learning Journey'
                      : 'Your Learning Journey Starts Here'),
                  const SizedBox(height: 15),
                  _buildFeatureCard(
                    icon: Icons.code,
                    title: 'Cutting-Edge Tech Courses',
                    description:
                        'Master in-demand skills with our curated collection of tech courses',
                    color: Colors.blue.shade100,
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureCard(
                    icon: Icons.auto_graph,
                    title: 'Personalized Progress Tracking',
                    description:
                        'Watch your skills grow with our intelligent progress dashboard',
                    color: Colors.green.shade100,
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureCard(
                    icon: Icons.verified_user,
                    title: 'Industry-Recognized Certs',
                    description:
                        'Earn certificates that boost your professional credibility',
                    color: Colors.orange.shade100,
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureCard(
                    icon: Icons.people,
                    title: 'Vibrant Community',
                    description:
                        'Connect with fellow learners and industry experts',
                    color: Colors.purple.shade100,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (isLoggedIn) {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          Navigator.pushNamed(context, '/auth');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        shadowColor: const Color.fromARGB(255, 146, 176, 221)
                            .withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isLoggedIn ? 'Browse Categories' : 'Get Started',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            isLoggedIn ? Icons.explore : Icons.login,
                            size: 22,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLoggedIn) const SizedBox(height: 20),
                  if (!isLoggedIn)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          if (isLoggedIn) {
                            // Navigate to home/categories if logged in
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            // Navigate to auth screen if not logged in
                            Navigator.pushNamed(context, '/auth');
                          }
                        },
                        child: const Text(
                          'Continue as Guest',
                          style: TextStyle(
                            color: Color.fromARGB(255, 69, 83, 143),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade900,
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blue.shade900, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
