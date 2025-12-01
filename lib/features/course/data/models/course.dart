import 'package:coursely/features/course/data/models/lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final String instructorId;
  final List<String> whatToLearn;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.price = 0.0,
    this.category = '',
    required this.instructorId,
    this.whatToLearn = const [],
    this.lessons = const [],
  });

  factory Course.fromMap(Map<String, dynamic> map, {String? id}) {
    return Course(
      id: id ?? map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      category: map['category']?.toString() ?? '',
      instructorId: map['instructorId']?.toString() ?? '',
      whatToLearn: List<String>.from(map['whatToLearn'] ?? []),
      lessons: (map['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'instructorId': instructorId,
      'whatToLearn': whatToLearn,
      'lessons': lessons.map((e) => e.toMap()).toList(),
    };
  }
}
