import 'package:coursely/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AboutCard extends StatelessWidget {
  final String description;
  final String duration;
  final String lessonsCount;

  const AboutCard({
    super.key,
    required this.description,
    required this.duration,
    required this.lessonsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About this Course",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.timer, size: 18, color: AppColors.primaryColor),
              const SizedBox(width: 6),
              Text(duration, style: const TextStyle(color: Colors.black54)),
              const SizedBox(width: 20),
              const Icon(
                Icons.play_circle_outline,
                size: 18,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(lessonsCount, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
