//screens/course_list_screen.dart
import 'package:flutter/material.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  List<Map<String, String>> _getCoursesForCategory(String categoryTitle) {
    switch (categoryTitle) {
      case 'Software Development':
        return [
          {
            'title': 'Flutter Development',
            'description': 'Learn to build cross-platform apps with Flutter.',
            'image': 'assets/flutter.png',
          },
          {
            'title': 'Python Programming',
            'description': 'Master Python programming from scratch.',
            'image': 'assets/python.png',
          },
          {
            'title': 'Web Development',
            'description':
                'Build modern websites using HTML, CSS, and JavaScript.',
            'image': 'assets/web_dev.png',
          },
        ];
      case 'Hardware Engineering':
        return [
          {
            'title': 'Embedded Systems',
            'description':
                'Learn to program microcontrollers and build IoT devices.',
            'image': 'assets/embedded.png',
          },
          {
            'title': 'Circuit Design',
            'description': 'Master electronic circuit design and PCB layout.',
            'image': 'assets/embedded.png',
          },
        ];
      case 'Artificial Intelligence':
        return [
          {
            'title': 'Machine Learning',
            'description': 'Fundamentals of ML algorithms and applications.',
            'image': 'assets/embedded.png',
          },
          {
            'title': 'Deep Learning',
            'description': 'Neural networks and advanced AI techniques.',
            'image': 'assets/embedded.png',
          },
          {
            'title': 'Computer Vision',
            'description': 'Image processing and pattern recognition.',
            'image': 'assets/embedded.png',
          },
        ];
      case 'Data Science':
        return [
          {
            'title': 'Data Analysis',
            'description': 'Analyze and visualize data with Python and R.',
            'image': 'assets/embedded.png',
          },
          {
            'title': 'Big Data',
            'description':
                'Working with large datasets using Hadoop and Spark.',
            'image': 'assets/embedded.png',
          },
        ];
      case 'Cybersecurity':
        return [
          {
            'title': 'Ethical Hacking',
            'description': 'Learn penetration testing and security assessment.',
            'image': 'assets/cybersecurity.png',
          },
          {
            'title': 'Network Security',
            'description': 'Secure networks and prevent cyber attacks.',
            'image': 'assets/cybersecurity.png',
          },
          {
            'title': 'Cryptography',
            'description': 'Encryption algorithms and secure communication.',
            'image': 'assets/cybersecurity.png',
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final String categoryTitle =
        ModalRoute.of(context)!.settings.arguments as String;
    final List<Map<String, String>> courses =
        _getCoursesForCategory(categoryTitle);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        backgroundColor: Colors.blue.shade900,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            title: course['title']!,
            description: course['description']!,
            image: course['image']!,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/course_detail',
                arguments: course,
              );
            },
          );
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  const CourseCard({
    required this.title,
    required this.description,
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
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey.shade600),
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
