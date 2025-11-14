class InstructorCourse {
  final String courseName;
  final List<String> videoLinks;

  InstructorCourse({required this.courseName, required this.videoLinks});

  factory InstructorCourse.fromJson(Map<String, dynamic> json) {
    return InstructorCourse(
      courseName: json['courseName'] ?? '',
      videoLinks: json['videoLinks'] is List
          ? List<String>.from(
              (json['videoLinks'] as List).map((e) => e.toString()),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'courseName': courseName, 'videoLinks': videoLinks};
  }
}
