//screen/course_detail_screen.dart
import 'package:flutter/material.dart';
import '../widgets/video_lecture_card.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  // Helper method to truncate text
  String _truncateDescription(String text, [int length = 50]) {
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }

  @override
  Widget build(BuildContext context) {
    // Get the course data from arguments with error handling
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments == null || arguments is! Map<String, String>) {
      Navigator.maybePop(context);
      return const SizedBox.shrink();
    }

    final Map<String, String> course = arguments;

    // Moved video lectures data to a separate method for better organization
    final List<Map<String, dynamic>> videoLectures = _getVideoLectures();

    return Scaffold(
      appBar: AppBar(
        title: Text(course['title'] ?? 'Course Details'),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Description
            Text(
              course['description'] ?? 'No description available',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),

            // Video Lectures Section
            const Text(
              'Video Lectures',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: videoLectures.length,
              itemBuilder: (context, index) {
                final lecture = videoLectures[index];
                return VideoLectureCard(
                  title: lecture['title'],
                  videoUrl: lecture['videoUrl'],
                  isCompleted: lecture['isCompleted'],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/video_player',
                      arguments: {
                        'title': lecture['title'],
                        'description':
                            _truncateDescription(lecture['description']),
                        'instructor': 'Expert Instructor',
                        'duration': '45 min',
                        'uploadDate': '2023-11-15',
                        'videoUrl': lecture['videoUrl'],
                      },
                    );
                  },
                );
              },
            ),

            // Certification Exam Button
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Take Certification Exam - ₹499',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getVideoLectures() {
    return [
      {
        'title': 'Fundamentals of the Topic',
        'description':
            'A basic introduction covering the core concepts and importance of this field. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Enim modi pariatur, reiciendis neque, veritatis sapiente fugit saepe perspiciatis vel quidem corrupti reprehenderit asperiores hic nulla inventore ex officiis laborum esse?',
        'videoUrl':
            'https://videos.pexels.com/video-files/29908723/12838080_640_360_30fps.mp4',
        'isCompleted': false,
      },
      {
        'title': 'Key Principles and Techniques',
        'description':
            'An overview of the essential methodologies and techniques used in this domain.Lorem ipsum, dolor sit amet consectetur adipisicing elit. Enim modi pariatur, reiciendis neque, veritatis sapiente fugit saepe perspiciatis vel quidem corrupti reprehenderit asperiores hic nulla inventore ex officiis laborum esse?',
        'videoUrl':
            'https://videos.pexels.com/video-files/29908723/12838080_640_360_30fps.mp4',
        'isCompleted': false,
      },
      {
        'title': 'Advanced Applications and Case Studies',
        'description':
            'Real-world applications and case studies to better understand practical usage. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Enim modi pariatur, reiciendis neque, veritatis sapiente fugit saepe perspiciatis vel quidem corrupti reprehenderit asperiores hic nulla inventore ex officiis laborum esse?',
        'videoUrl':
            'https://videos.pexels.com/video-files/29908723/12838080_640_360_30fps.mp4',
        'isCompleted': false,
      },
      {
        'title': 'Common Mistakes and Best Practices',
        'description':
            'Discussion on common pitfalls and how to avoid them while implementing solutions. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Enim modi pariatur, reiciendis neque, veritatis sapiente fugit saepe perspiciatis vel quidem corrupti reprehenderit asperiores hic nulla inventore ex officiis laborum esse?',
        'videoUrl':
            'https://videos.pexels.com/video-files/29908723/12838080_640_360_30fps.mp4',
        'isCompleted': false,
      },
      {
        'title': 'Final Review and Next Steps',
        'description':
            'A recap of the key takeaways and guidance on what to learn next. Lorem ipsum, dolor sit amet consectetur adipisicing elit. Enim modi pariatur, reiciendis neque, veritatis sapiente fugit saepe perspiciatis vel quidem corrupti reprehenderit asperiores hic nulla inventore ex officiis laborum esse?',
        'videoUrl':
            'https://videos.pexels.com/video-files/29908723/12838080_640_360_30fps.mp4',
        'isCompleted': false,
      },
    ];
  }
}
