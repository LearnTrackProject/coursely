import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/features/course/data/models/lesson.dart';
import 'package:coursely/features/course/data/repo/course_repository.dart';
import 'package:coursely/features/course_details/cubit/course_details_cubit.dart';
import 'package:coursely/features/course_details/widgets/lesson_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../widgets/about_card.dart';

class CourseDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseDetailsCubit(
        courseRepository: CourseRepository(),
      )..loadCourseDetails(courseId ?? ''),
      child: const _CourseDetailView(),
    );
  }
}

class _CourseDetailView extends StatefulWidget {
  const _CourseDetailView();

  @override
  State<_CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<_CourseDetailView> {
  YoutubePlayerController? _controller;
  bool _isVideoPlaying = false;
  String? _currentVideoId;

  void _toggleVideo(String url) {
    if (_currentVideoId == url && _isVideoPlaying) {
      setState(() {
        _isVideoPlaying = false;
        _currentVideoId = null;
      });
      _controller?.pause();
    } else {
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null) {
        final newController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
        );

        final oldController = _controller;
        setState(() {
          _isVideoPlaying = true;
          _currentVideoId = url;
          _controller = newController;
        });
        oldController?.dispose();
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
      body: BlocConsumer<CourseDetailsCubit, CourseDetailsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final course = state.course;
          if (course == null) {
            return const Center(child: Text('Course not found'));
          }

          return Stack(
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
                            tag: course.id,
                            child: (course.imageUrl.startsWith('http'))
                                ? Image.network(
                                    course.imageUrl,
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/placeholder.png',
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 14)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (course.whatToLearn.isNotEmpty) ...[
                            const Text(
                              'What you will learn',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...course.whatToLearn.map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(e)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) {
                          final lesson = course.lessons[i];
                          final isLocked = !state.isEnrolled && !lesson.isFree;
                          return LessonTile(
                            lesson: lesson,
                            isLocked: isLocked,
                            isPlaying: _isVideoPlaying &&
                                _currentVideoId == lesson.videoUrl,
                            onPlay: () => _toggleVideo(lesson.videoUrl),
                          );
                        },
                        childCount: course.lessons.length,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state.enrolling || state.isEnrolled
                              ? null
                              : () {
                                  context
                                      .read<CourseDetailsCubit>()
                                      .enrollInCourse();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isEnrolled
                                ? Colors.green
                                : AppColors.primaryColor,
                            disabledBackgroundColor: state.isEnrolled
                                ? Colors.green.withValues(alpha: 0.8)
                                : AppColors.primaryColor
                                    .withValues(alpha: 0.6),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.enrolling
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
                                    if (state.isEnrolled) ...[
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      state.isEnrolled
                                          ? 'Enrolled'
                                          : 'Enroll Now',
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
          );
        },
      ),
    );
  }
}
