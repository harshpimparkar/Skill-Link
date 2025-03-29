import 'package:flutter/material.dart';

class NeumorphicCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;

  const NeumorphicCategoryCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.blue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110, // More height for icons and text
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(6, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(-6, -6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white), // Larger icon
            const SizedBox(width: 12), // Space between icon and text
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
