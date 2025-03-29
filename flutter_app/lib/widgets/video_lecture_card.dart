import 'package:flutter/material.dart';

class VideoLectureCard extends StatefulWidget {
  final String title;
  final String videoUrl;
  final bool isCompleted;
  final VoidCallback onTap;

  const VideoLectureCard({
    required this.title,
    required this.videoUrl,
    required this.isCompleted,
    required this.onTap,
    super.key,
  });

  @override
  VideoLectureCardState createState() => VideoLectureCardState();
}

class VideoLectureCardState extends State<VideoLectureCard> {
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }

  void _toggleCompleted() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.video_library, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: _isCompleted ? Colors.green : Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isCompleted ? 'Completed' : 'Not Completed',
                          style: TextStyle(
                            color: _isCompleted ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _toggleCompleted,
                icon: Icon(
                  _isCompleted
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: _isCompleted ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
