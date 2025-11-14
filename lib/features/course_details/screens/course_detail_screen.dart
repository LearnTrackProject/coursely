import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/features/course_details/widgets/lesson_title.dart';
import 'package:coursely/features/course/presentation/page/course_page.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/about_card.dart';
import '../models/lesson.dart';

class CourseDetailScreen extends StatefulWidget {
  final String? title;
  final String? imageUrl;
  final double? price;
  final String? heroTag;
  final String? courseId;

  const CourseDetailScreen({
    super.key,
    this.title,
    this.imageUrl,
    this.price,
    this.heroTag,
    this.courseId,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  List<Lesson> lessons = [];

  bool isFavorite = false;
  YoutubePlayerController? _controller;
  bool _isVideoPlaying = false;
  String? _currentVideoId;
  bool _isEnrolled = false;
  bool _isEnrolling = false;

  @override
  void initState() {
    super.initState();
    _checkEnrollmentStatus();
    _setupEnrollmentListener();
  }

  void _setupEnrollmentListener() {
    if (widget.courseId == null) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('student')
          .doc(uid)
          .snapshots()
          .listen((doc) {
            if (doc.exists && doc.data()?['enrolledCourses'] is List) {
              final enrolledCourses = doc.data()!['enrolledCourses'] as List;
              if (mounted) {
                setState(() {
                  _isEnrolled = enrolledCourses.contains(widget.courseId);
                });
              }
            }
          });
    }
  }

  Future<void> _checkEnrollmentStatus() async {
    if (widget.courseId == null) return;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('student')
            .doc(uid)
            .get();
        if (doc.exists && doc.data()?['enrolledCourses'] is List) {
          final enrolledCourses = doc.data()!['enrolledCourses'] as List;
          if (mounted) {
            setState(() {
              _isEnrolled = enrolledCourses.contains(widget.courseId);
            });
          }
        }
      }
    } catch (e) {
      print('Error checking enrollment: $e');
    }
  }

  Future<void> _enrollCourse() async {
    if (widget.courseId == null) return;
    setState(() {
      _isEnrolling = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Please login first')));
        }
        return;
      }

      await FirebaseFirestore.instance.collection('student').doc(uid).update({
        'enrolledCourses': FieldValue.arrayUnion([widget.courseId]),
      });

      if (mounted) {
        setState(() {
          _isEnrolled = true;
          _isEnrolling = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully enrolled in course!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isEnrolling = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error enrolling: $e')));
      }
    }
  }

  void _toggleVideo(String url) {
    if (_currentVideoId == url && _isVideoPlaying) {
      // If clicking the same video that's playing, close it
      setState(() {
        _isVideoPlaying = false;
        _currentVideoId = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller?.dispose();
        _controller = null;
      });
    } else {
      // Start new video
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null) {
        // Create new controller
        final newController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
        );

        // Store old controller for disposal
        final oldController = _controller;

        setState(() {
          _isVideoPlaying = true;
          _currentVideoId = url;
          _controller = newController;
        });

        // Dispose old controller after state update
        WidgetsBinding.instance.addPostFrameCallback((_) {
          oldController?.dispose();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _isVideoPlaying && _controller != null
                    ? YoutubePlayer(
                        controller: _controller!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: AppColors.primaryColor,
                        progressColors: const ProgressBarColors(
                          playedColor: AppColors.primaryColor,
                          handleColor: AppColors.primaryColor,
                        ),
                      )
                    : Hero(
                        tag: widget.heroTag ?? '',
                        child:
                            (widget.imageUrl != null &&
                                widget.imageUrl!.startsWith('http'))
                            ? Image.network(
                                widget.imageUrl!,
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                widget.imageUrl ??
                                    'assets/images/placeholder.png',
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverToBoxAdapter(
                child: AboutCard(
                  description:
                      'This course covers fundamentals and real-world case studies.',
                  duration: '6h 14min',
                  lessonsCount: '24 Lessons',
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => LessonTile(
                      lesson: lessons[i],
                      isPlaying:
                          _isVideoPlaying &&
                          YoutubePlayer.convertUrlToId(lessons[i].sampleUrl) ==
                              _controller?.metadata.videoId,
                      onPlay: () => _toggleVideo(lessons[i].sampleUrl),
                    ),
                    childCount: lessons.length,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () => setState(() => isFavorite = !isFavorite),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isEnrolling || _isEnrolled
                          ? null
                          : _enrollCourse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEnrolled
                            ? Colors.green
                            : AppColors.primaryColor,
                        disabledBackgroundColor: _isEnrolled
                            ? Colors.green.withValues(alpha: 0.8)
                            : AppColors.primaryColor.withValues(alpha: 0.6),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isEnrolling
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isEnrolled) ...[
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  _isEnrolled ? 'Enrolled' : 'Enroll Now',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
