import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String instructorId;
  final String courseId;
  final String title;
  final String body;
  final String? videoUrl;
  final DateTime createdAt;

  Announcement({
    required this.id,
    required this.instructorId,
    required this.courseId,
    required this.title,
    required this.body,
    this.videoUrl,
    required this.createdAt,
  });

  factory Announcement.fromMap(Map<String, dynamic> m, String id) {
    return Announcement(
      id: id,
      instructorId: m['instructorId'] as String? ?? '',
      courseId: m['courseId'] as String? ?? '',
      title: m['title'] as String? ?? '',
      body: m['body'] as String? ?? '',
      videoUrl: m['videoUrl'] as String?,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instructorId': instructorId,
      'courseId': courseId,
      'title': title,
      'body': body,
      'videoUrl': videoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
