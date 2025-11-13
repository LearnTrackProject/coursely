import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/features/course_details/widgets/lesson_title.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../widgets/about_card.dart';
import '../models/lesson.dart';

class CourseDetailScreen extends StatefulWidget {
  final String? title;
  final String? imageUrl;
  final double? price;
  final String? heroTag;

  const CourseDetailScreen({
    super.key,
    this.title,
    this.imageUrl,
    this.price,
    this.heroTag,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final List<Lesson> lessons = [
    Lesson(
      index: 1,
      title: 'Welcome to the Course',
      duration: '6:10',
      sampleUrl: 'https://www.youtube.com/watch?v=MDQkkCkSxWI',
      locked: false,
    ),
    Lesson(
      index: 2,
      title: 'Process Overview',
      duration: '8:15',
      sampleUrl: 'https://www.youtube.com/watch?v=LkX8acAE8_A',
      locked: false,
    ),
    Lesson(
      index: 3,
      title: 'ui ux ',
      duration: '8:15',
      sampleUrl: 'https://www.youtube.com/watch?v=MDQkkCkSxWI',
      locked: true,
    ),
  ];

  bool isFavorite = false;
  YoutubePlayerController? _controller;
  bool _isVideoPlaying = false;
  String? _currentVideoId;

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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
