//screens/category_screen.dart
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<Map<String, String>> categories = const [
    {
      'title': 'Software Development',
      'image': 'assets/software.png',
    },
    {
      'title': 'Hardware Engineering',
      'image': 'assets/hardware.png',
    },
    {
      'title': 'Artificial Intelligence',
      'image': 'assets/ai.png',
    },
    {
      'title': 'Data Science',
      'image': 'assets/data_science.png',
    },
    {
      'title': 'Cybersecurity',
      'image': 'assets/cybersecurity.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryCard(
            title: category['title']!,
            image: category['image']!,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/courses',
                arguments: category['title'],
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const CategoryCard({
    required this.title,
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(image, width: 80, height: 80),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
