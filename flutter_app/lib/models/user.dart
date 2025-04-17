class User {
  final String id;
  final String email;
  final List<String> coursesEnrolled;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.coursesEnrolled,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      coursesEnrolled: List<String>.from(json['coursesEnrolled'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'coursesEnrolled': coursesEnrolled,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
