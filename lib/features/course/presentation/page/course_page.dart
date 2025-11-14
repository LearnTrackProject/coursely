import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../presentation/cubit/courses_cubit.dart';
import '../../data/models/course.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  List<String> _enrolledCourses = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _loadEnrolledCourses();
    _setupEnrolledCoursesListener();
  }

  void _setupEnrolledCoursesListener() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('student')
          .doc(uid)
          .snapshots()
          .listen((doc) {
            if (doc.exists && doc.data()?['enrolledCourses'] is List) {
              setState(() {
                _enrolledCourses = List<String>.from(
                  doc.data()!['enrolledCourses'] as List,
                );
              });
            }
          });
    }
  }

  Future<void> _loadEnrolledCourses() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('student')
            .doc(uid)
            .get();
        if (doc.exists && doc.data()?['enrolledCourses'] is List) {
          setState(() {
            _enrolledCourses = List<String>.from(
              doc.data()!['enrolledCourses'] as List,
            );
          });
        }
      }
    } catch (e) {
      print('Error loading enrolled courses: $e');
    }
  }

  Future<void> _enrollCourse(String courseId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('student').doc(uid).update({
        'enrolledCourses': FieldValue.arrayUnion([courseId]),
      });

      setState(() {
        _enrolledCourses.add(courseId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully enrolled in course!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error enrolling: $e')));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Course",
                      style: TextStyles.textStyle24.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Image.asset(AppImages.avatarImage),
                  ],
                ),
                Gap(17),
                CustomTextFormField(
                  suffixIcon: Icon(Icons.toggle_on_sharp),
                  preffixIcon: Icon(Icons.search),
                  hintText: "Find Course",
                  controller: _searchController,
                ),
                Gap(40),
                Container(
                  clipBehavior: Clip.none,
                  width: double.infinity,
                  height: media.height * 0.09,
                  child: ListView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    children: [
                      CourseTypeWidget(
                        media: media,
                        image1: AppImages.image4,
                        image2: AppImages.name5,
                        color: AppColors.lightBlue,
                      ),
                      Gap(20),
                      CourseTypeWidget(
                        media: media,
                        image1: AppImages.image5,
                        image2: AppImages.name4,
                        color: AppColors.softPink,
                      ),
                    ],
                  ),
                ),
                Gap(30),
                Text("Choice Your course", style: TextStyles.textStyle18),
                TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 0,
                    right: 40,
                    bottom: 10,
                  ),
                  automaticIndicatorColorAdjustment: false,
                  dividerHeight: 0,
                  indicatorPadding: EdgeInsets.all(8),
                  labelColor: AppColors.backGroundColor,
                  unselectedLabelColor: AppColors.gryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.primaryColor,
                  ),
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("All"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Popular"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Enrolled"),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // All Courses Tab
                      BlocBuilder<CoursesCubit, CoursesState>(
                        builder: (context, state) {
                          if (state.status == CoursesStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state.status == CoursesStatus.failure) {
                            return Center(
                              child: Text('Error: ${state.errorMessage}'),
                            );
                          }

                          var items = state.courses;
                          if (_searchQuery.isNotEmpty) {
                            items = items
                                .where(
                                  (course) => course.title
                                      .toLowerCase()
                                      .contains(_searchQuery),
                                )
                                .toList();
                          }

                          if (items.isEmpty) {
                            return Center(
                              child: Text(
                                _searchQuery.isNotEmpty
                                    ? 'No courses found'
                                    : 'No courses available',
                                style: TextStyles.textStyle14,
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final Course c = items[index];
                              final isEnrolled = _enrolledCourses.contains(
                                c.id,
                              );
                              return _buildCourseCard(
                                course: c,
                                isEnrolled: isEnrolled,
                                onEnroll: () => _enrollCourse(c.id ?? ''),
                              );
                            },
                          );
                        },
                      ),
                      // Popular Courses Tab
                      BlocBuilder<CoursesCubit, CoursesState>(
                        builder: (context, state) {
                          if (state.status == CoursesStatus.loading)
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          final items = state.courses;
                          if (items.isEmpty) {
                            return Center(
                              child: Text(
                                'No courses available',
                                style: TextStyles.textStyle14,
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final Course c = items[index];
                              final isEnrolled = _enrolledCourses.contains(
                                c.id,
                              );
                              return _buildCourseCard(
                                course: c,
                                isEnrolled: isEnrolled,
                                onEnroll: () => _enrollCourse(c.id ?? ''),
                              );
                            },
                          );
                        },
                      ),
                      // Enrolled Courses Tab
                      BlocBuilder<CoursesCubit, CoursesState>(
                        builder: (context, state) {
                          if (state.status == CoursesStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          var enrolledCourses = state.courses
                              .where(
                                (course) =>
                                    _enrolledCourses.contains(course.id),
                              )
                              .toList();

                          if (enrolledCourses.isEmpty) {
                            return Center(
                              child: Text(
                                'No enrolled courses yet',
                                style: TextStyles.textStyle14,
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: enrolledCourses.length,
                            itemBuilder: (context, index) {
                              final Course c = enrolledCourses[index];
                              return _buildCourseCard(
                                course: c,
                                isEnrolled: true,
                                onEnroll: () {},
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard({
    required Course course,
    required bool isEnrolled,
    required VoidCallback onEnroll,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 5, left: 5),
          child: Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),

              color: AppColors.lightSkyBlue,
            ),
            child: ListTile(
              onTap: isEnrolled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseVideoPlayer(
                            courseId: course.id ?? '',
                            courseTitle: course.title,
                          ),
                        ),
                      );
                    }
                  : null,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:
                    (course.imageUrl.isNotEmpty &&
                        course.imageUrl.startsWith('http'))
                    ? Image.network(
                        course.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        AppImages.image6,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: TextStyles.textStyle14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(4),
                    if (isEnrolled)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            Gap(4),
                            Text(
                              'Enrolled',
                              style: TextStyles.textStyle12.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: onEnroll,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Enroll Now',
                            style: TextStyles.textStyle12.copyWith(
                              color: AppColors.backGroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CourseTypeWidget extends StatelessWidget {
  final String image1;
  final String image2;
  final Color color;
  final Size media;

  const CourseTypeWidget({
    super.key,
    required this.media,
    required this.image1,
    required this.image2,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkgrey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 9),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(bottom: 0, left: -5, child: Image.asset(image1)),
          Positioned(right: 0, bottom: 5, child: Image.asset(image2)),
        ],
      ),
    );
  }
}

class CourseVideoPlayer extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CourseVideoPlayer({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  late Future<Map<String, dynamic>> _courseFuture;
  int _selectedVideoIndex = 0;
  YoutubePlayerController? _youtubeController;
  bool _isVideoPlaying = false;
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    _courseFuture = _fetchCourseWithVideos();
  }

  Future<Map<String, dynamic>> _fetchCourseWithVideos() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .get();

      if (doc.exists) {
        return doc.data() ?? {};
      }
      return {};
    } catch (e) {
      print('Error fetching course: $e');
      rethrow;
    }
  }

  void _playVideo(String videoUrl) {
    if (_currentVideoUrl == videoUrl && _isVideoPlaying) {
      // If clicking the same video, close it
      setState(() {
        _isVideoPlaying = false;
        _currentVideoUrl = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _youtubeController?.dispose();
        _youtubeController = null;
      });
    } else {
      // Start new video
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId != null) {
        // Create new controller
        final newController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
        );

        // Store old controller for disposal
        final oldController = _youtubeController;

        setState(() {
          _isVideoPlaying = true;
          _currentVideoUrl = videoUrl;
          _youtubeController = newController;
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
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseTitle,
          style: TextStyles.textStyle18.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.primaryColor,
                    size: 60,
                  ),
                  Gap(16),
                  Text('Error loading course', style: TextStyles.textStyle16),
                ],
              ),
            );
          }

          final courseData = snapshot.data ?? {};
          final videoLinks =
              (courseData['videoLinks'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];

          if (videoLinks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    color: AppColors.gryColor,
                    size: 80,
                  ),
                  Gap(16),
                  Text(
                    'No videos available',
                    style: TextStyles.textStyle16.copyWith(
                      color: AppColors.gryColor,
                    ),
                  ),
                  Gap(8),
                  Text(
                    'Come back later for updates',
                    style: TextStyles.textStyle12.copyWith(
                      color: AppColors.gryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          final currentVideoUrl = videoLinks[_selectedVideoIndex];

          return Column(
            children: [
              // Video Player Container - YouTube Player or Placeholder
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, Colors.black87],
                  ),
                ),
                child: _isVideoPlaying && _youtubeController != null
                    ? YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: AppColors.primaryColor,
                        progressColors: const ProgressBarColors(
                          playedColor: AppColors.primaryColor,
                          handleColor: AppColors.primaryColor,
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              color: AppColors.primaryColor,
                              size: 80,
                            ),
                            Gap(16),
                            Text(
                              'Lesson ${_selectedVideoIndex + 1}',
                              style: TextStyles.textStyle18.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                currentVideoUrl,
                                style: TextStyles.textStyle12.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Gap(16),
                            ElevatedButton.icon(
                              onPressed: () {
                                _playVideo(videoLinks[_selectedVideoIndex]);
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Play Video'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Gap(24),
              // Course Lessons Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.playlist_play,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),
                    Gap(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Course Lessons',
                          style: TextStyles.textStyle16.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        Text(
                          '${videoLinks.length} videos in total',
                          style: TextStyles.textStyle12.copyWith(
                            color: AppColors.gryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(16),
              // Videos List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: videoLinks.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedVideoIndex == index;
                    final isPlaying =
                        _isVideoPlaying &&
                        YoutubePlayer.convertUrlToId(videoLinks[index]) ==
                            _youtubeController?.metadata.videoId;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedVideoIndex = index;
                        });
                        _playVideo(videoLinks[index]);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? AppColors.primaryColor.withValues(alpha: 0.1)
                              : AppColors.backGroundColor,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.gryColor.withValues(alpha: 0.15),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            // Play Button Circle
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.gryColor.withValues(
                                        alpha: 0.15,
                                      ),
                              ),
                              child: Center(
                                child: Icon(
                                  isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_arrow_rounded,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primaryColor,
                                  size: 28,
                                ),
                              ),
                            ),
                            Gap(16),
                            // Lesson Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lesson ${index + 1}',
                                    style: TextStyles.textStyle14.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : AppColors.secondaryColor,
                                    ),
                                  ),
                                  Gap(6),
                                  Text(
                                    videoLinks[index],
                                    style: TextStyles.textStyle12.copyWith(
                                      color: AppColors.gryColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Status Indicator
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.arrow_forward_ios,
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.gryColor.withValues(alpha: 0.5),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Gap(20),
            ],
          );
        },
      ),
    );
  }
}
