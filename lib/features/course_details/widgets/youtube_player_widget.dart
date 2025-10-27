import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String youtubeUrl;
  const YoutubePlayerWidget({super.key, required this.youtubeUrl});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl)!;
    _controller =
        YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        )..addListener(() {
          if (_controller.value.isReady && !_isPlayerReady) {
            setState(() => _isPlayerReady = true);
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).colorScheme.primary,
        onReady: () => debugPrint('YouTube Player Ready ✅'),
      ),
      builder: (context, player) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(aspectRatio: 16 / 9, child: player),
          ),
          const SizedBox(height: 10),
          const Text(
            "Course Preview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "Watch this short preview before you enroll.",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
