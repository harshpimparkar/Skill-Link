import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/auth_services.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  double _gradientShift = 0.0;
  String? _userEmail;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _gradientShift += 0.01;
      });
    });
  }

  Future<void> _loadUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userData = await authService.getCurrentUser();
    if (userData != null) {
      setState(() {
        _userEmail = userData['email'];
        _userName = userData['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _userEmail != null;
    final username = _userName ?? _userEmail?.split('@').first ?? 'Learner';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900, Colors.blue.shade700],
                  begin: Alignment(_gradientShift, -1.0),
                  end: Alignment(-_gradientShift, 1.0),
                ),
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 50,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Image.asset('assets/logo.png',
                              width: 80, height: 80),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        child: Text(
                          isLoggedIn
                              ? 'Welcome, $username!'
                              : 'Welcome! Get Started',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildFeatureCard(Icons.code, 'Tech Courses',
                          'Master in-demand skills', Colors.blue.shade100),
                      _buildFeatureCard(Icons.auto_graph, 'Progress Tracking',
                          'Watch your skills grow', Colors.green.shade100),
                      _buildFeatureCard(
                          Icons.verified_user,
                          'Certifications',
                          'Earn industry-recognized certs',
                          Colors.orange.shade100),
                      _buildFeatureCard(
                          Icons.people,
                          'Community',
                          'Connect with fellow learners',
                          Colors.purple.shade100),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, isLoggedIn ? '/home' : '/auth'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 196, 224, 246),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isLoggedIn ? 'Browse Courses' : 'Get Started',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 17, 66, 141)),
                            ),
                            const SizedBox(width: 10),
                            Icon(isLoggedIn ? Icons.explore : Icons.login,
                                size: 22,
                                color: Color.fromARGB(255, 17, 66, 141)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            title: Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text(description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
          ),
        ),
      ),
    );
  }
}
