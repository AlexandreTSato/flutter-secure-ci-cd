import 'package:flutter/material.dart';

class PixHeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const PixHeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'pix_icon',
          child: CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white24,
            child: Icon(icon, size: 36, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
