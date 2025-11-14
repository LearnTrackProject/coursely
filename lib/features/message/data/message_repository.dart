import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/announcement.dart';

class MessageRepository {
  final FirebaseFirestore _firestore;

  MessageRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> sendAnnouncement({
    required String instructorId,
    required String courseId,
    required String title,
    required String body,
    String? videoUrl,
  }) async {
    final doc = _firestore.collection('announcements').doc();
    final ann = Announcement(
      id: doc.id,
      instructorId: instructorId,
      courseId: courseId,
      title: title,
      body: body,
      videoUrl: videoUrl,
      createdAt: DateTime.now(),
    );
    await doc.set(ann.toMap());

    // Broadcast a copy to enrolled students' personal announcements (student/{id}/announcements)
    try {
      // Query students who have this course in their enrolledCourses array
      final studentsSnap = await _firestore
          .collection('student')
          .where('enrolledCourses', arrayContains: courseId)
          .get();

      if (studentsSnap.docs.isNotEmpty) {
        // Firestore batch limit is 500; use safe chunking
        const int batchSize = 400; // keep under 500 to be safe
        for (var i = 0; i < studentsSnap.docs.length; i += batchSize) {
          final end = (i + batchSize > studentsSnap.docs.length)
              ? studentsSnap.docs.length
              : i + batchSize;
          final batch = _firestore.batch();
          for (var j = i; j < end; j++) {
            final sdoc = studentsSnap.docs[j];
            final inboxRef = _firestore
                .collection('student')
                .doc(sdoc.id)
                .collection('announcements')
                .doc(doc.id);
            final map = ann.toMap();
            // Add a read flag for per-user inbox
            map['read'] = false;
            batch.set(inboxRef, map);
          }
          await batch.commit();
        }
      }
    } catch (e) {
      // Don't fail the main send on broadcast errors — log silently
      // Optionally rethrow or surface error depending on desired behavior
    }
  }

  Future<List<Announcement>> fetchAnnouncementsForUser(String uid) async {
    if (uid.isEmpty) return [];
    // Prefer per-user announcements (student/{uid}/announcements) if they exist
    try {
      final personalSnap = await _firestore
          .collection('student')
          .doc(uid)
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .get();
      if (personalSnap.docs.isNotEmpty) {
        return personalSnap.docs
            .map((d) => Announcement.fromMap(d.data(), d.id))
            .toList();
      }
    } catch (_) {
      // ignore and fallback to global strategy
    }

    // find student doc and its enrolledCourses (fallback to global announcements)
    final studentDoc = await _firestore.collection('student').doc(uid).get();
    List<String> courseIds = [];
    if (studentDoc.exists) {
      final data = studentDoc.data();
      if (data != null && data['enrolledCourses'] is List) {
        for (var v in data['enrolledCourses']) {
          if (v is String) courseIds.add(v);
        }
      }
    }
    // if no enrolled courses return announcements authored by this uid (maybe instructor)
    if (courseIds.isEmpty) {
      final ownSnap = await _firestore
          .collection('announcements')
          .where('instructorId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();
      return ownSnap.docs
          .map((d) => Announcement.fromMap(d.data(), d.id))
          .toList();
    }

    // Firestore doesn't support whereIn on more than 10 items; chunk
    const chunkSize = 10;
    final results = <Announcement>[];
    for (var i = 0; i < courseIds.length; i += chunkSize) {
      final chunk = courseIds.sublist(
        i,
        i + chunkSize > courseIds.length ? courseIds.length : i + chunkSize,
      );
      final snap = await _firestore
          .collection('announcements')
          .where('courseId', whereIn: chunk)
          .orderBy('createdAt', descending: true)
          .get();
      results.addAll(
        snap.docs.map((d) => Announcement.fromMap(d.data(), d.id)).toList(),
      );
    }
    return results;
  }

  Future<bool> isInstructor(String uid) async {
    if (uid.isEmpty) return false;
    final doc = await _firestore.collection('instructor').doc(uid).get();
    return doc.exists;
  }
}
