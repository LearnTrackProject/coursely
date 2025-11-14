import 'package:coursely/features/course_details/models/lesson.dart';

class Course {
  final String? id;
  final String title;
  final String imageUrl;
  final double? price;
  final String? category;
  final String? instructorId;
  final List<Lesson> lessons;

  Course({
    this.id,
    required this.title,
    required this.imageUrl,
    this.price,
    this.category,
    this.instructorId,
    this.lessons = const [],
  });

  factory Course.fromMap(Map<String, dynamic> map, {String? id}) {
    final lessonsRaw = map['lessons'];
    List<Lesson> parsedLessons = [];
    if (lessonsRaw is List) {
      parsedLessons = lessonsRaw
          .map(
            (e) => e is Map<String, dynamic>
                ? Lesson.fromMap(e)
                : Lesson.fromMap(Map<String, dynamic>.from(e)),
          )
          .toList();
    }

    return Course(
      id: id,
      title: map['title']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      price: map['price'] != null
          ? (map['price'] is num
                ? (map['price'] as num).toDouble()
                : double.tryParse('${map['price']}'))
          : null,
      category: map['category']?.toString(),
      instructorId: map['instructorId']?.toString(),
      lessons: parsedLessons,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'instructorId': instructorId,
      'lessons': lessons.map((e) => e.toMap()).toList(),
    };
  }
}
