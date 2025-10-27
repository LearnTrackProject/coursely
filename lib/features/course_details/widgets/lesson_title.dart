import 'package:coursely/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;
  final bool isPlaying;
  final VoidCallback onPlay;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.onPlay,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: lesson.locked
            ? Colors.grey.shade300
            : AppColors.primaryColor,
        child: lesson.locked
            ? Icon(Icons.lock, color: Colors.grey.shade600)
            : Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
      ),
      title: Text(
        '${lesson.index}. ${lesson.title}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: lesson.locked ? Colors.grey.shade600 : Colors.black,
        ),
      ),
      subtitle: Text(lesson.duration),
      onTap: lesson.locked ? null : onPlay,
    );
  }
}
