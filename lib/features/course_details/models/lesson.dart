class Lesson {
  final int index;
  final String title;
  final String duration;
  final String sampleUrl;
  final bool locked;

  Lesson({
    required this.index,
    required this.title,
    required this.duration,
    required this.sampleUrl,
    required this.locked,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      index: (map['index'] is int)
          ? map['index']
          : int.tryParse('${map['index']}') ?? 0,
      title: map['title']?.toString() ?? '',
      duration: map['duration']?.toString() ?? '',
      sampleUrl: map['videoUrl'] ?? map['sampleUrl'] ?? '',
      locked: map['locked'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'title': title,
      'duration': duration,
      'videoUrl': sampleUrl,
      'locked': locked,
    };
  }
}
