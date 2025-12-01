class Lesson {
  final String id;
  final String title;
  final String videoUrl;
  final String duration;
  final bool isFree;

  Lesson({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.duration = '',
    this.isFree = false,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      videoUrl: map['videoUrl']?.toString() ?? '',
      duration: map['duration']?.toString() ?? '',
      isFree: map['isFree'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'videoUrl': videoUrl,
      'duration': duration,
      'isFree': isFree,
    };
  }
}
