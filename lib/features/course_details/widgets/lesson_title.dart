import 'package:coursely/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:coursely/features/course/data/models/lesson.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;
  final bool isPlaying;
  final bool isLocked;
  final VoidCallback onPlay;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.onPlay,
    this.isPlaying = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: isLocked
            ? Colors.grey.shade300
            : AppColors.primaryColor,
        child: isLocked
            ? Icon(Icons.lock, color: Colors.grey.shade600)
            : Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
      ),
      title: Text(
        lesson.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isLocked ? Colors.grey.shade600 : Colors.black,
        ),
      ),
      subtitle: Text(lesson.duration),
      onTap: isLocked ? null : onPlay,
    );
  }
}
