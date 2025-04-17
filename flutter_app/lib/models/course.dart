class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final double price;
  final String? thumbnailUrl;
  final double progress;
  final String category;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.price,
    this.thumbnailUrl,
    this.progress = 0,
    required this.category,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'] ?? 'Unknown Instructor',
      price: json['price']?.toDouble() ?? 0.0,
      thumbnailUrl: json['thumbnailUrl'],
      progress: json['progress']?.toDouble() ?? 0.0,
      category: json['category'] ?? 'Uncategorized',
    );
  }
}
