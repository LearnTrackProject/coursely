import 'package:flutter/material.dart';

class CourseHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const CourseHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: Image.asset(
            imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade200,
              height: 250,
              alignment: Alignment.center,
              child: const Icon(
                Icons.broken_image,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 20,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
