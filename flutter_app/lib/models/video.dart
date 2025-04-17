// models/video.dart
class Video {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  bool isCompleted;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.isCompleted = false,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'isCompleted': isCompleted,
    };
  }
}
