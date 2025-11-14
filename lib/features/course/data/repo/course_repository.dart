import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class CourseRepository {
  final FirebaseFirestore _firestore;

  CourseRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Course>> fetchAllCourses() async {
    final snap = await _firestore.collection('courses').get();
    return snap.docs.map((d) => Course.fromMap(d.data(), id: d.id)).toList();
  }

  Future<List<Course>> fetchCoursesByInstructor(String instructorId) async {
    if (instructorId.isEmpty) return [];
    final snap = await _firestore
        .collection('courses')
        .where('instructorId', isEqualTo: instructorId)
        .get();
    return snap.docs.map((d) => Course.fromMap(d.data(), id: d.id)).toList();
  }

  Future<List<Course>> fetchFeatured({int limit = 4}) async {
    final snap = await _firestore.collection('courses').limit(limit).get();
    return snap.docs.map((d) => Course.fromMap(d.data(), id: d.id)).toList();
  }

  Future<Course?> fetchCourseById(String id) async {
    final doc = await _firestore.collection('courses').doc(id).get();
    if (!doc.exists) return null;
    return Course.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
  }

  Future<List<Course>> fetchCoursesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    // Firestore doesn't support 'in' for >10; handle in chunks of 10
    final List<Course> results = [];
    const chunkSize = 10;
    for (var i = 0; i < ids.length; i += chunkSize) {
      final chunk = ids.sublist(
        i,
        i + chunkSize > ids.length ? ids.length : i + chunkSize,
      );
      final snap = await _firestore
          .collection('courses')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(
        snap.docs.map((d) => Course.fromMap(d.data(), id: d.id)).toList(),
      );
    }
    return results;
  }

  Future<List<Course>> fetchEnrolledCoursesForUser(String uid) async {
    if (uid.isEmpty) return [];
    // try student collection first
    DocumentSnapshot<Map<String, dynamic>> doc;
    doc = await _firestore.collection('student').doc(uid).get();
    if (!doc.exists) {
      doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return [];
    }
    final data = doc.data();
    final ids = <String>[];
    if (data != null && data['enrolledCourses'] is List) {
      for (var v in data['enrolledCourses']) {
        if (v is String) ids.add(v);
      }
    }
    if (ids.isEmpty) return [];
    return fetchCoursesByIds(ids);
  }

  /// Simple prefix search on course title.
  /// Uses range query with '\uf8ff' to emulate starts-with search.
  Future<List<Course>> searchCourses(String query, {int limit = 50}) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final end = '$q\uf8ff';
    final snap = await _firestore
        .collection('courses')
        .where('title', isGreaterThanOrEqualTo: q)
        .where('title', isLessThanOrEqualTo: end)
        .limit(limit)
        .get();
    return snap.docs.map((d) => Course.fromMap(d.data(), id: d.id)).toList();
  }
}
