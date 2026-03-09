import 'package:flutter/material.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

/// Reusable slanted category card widget
/// Features: Gradient background, slanted design, border radius, emoji badge
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final String emoji;
  final VoidCallback onTap;
  final double width;
  final double height;

  const CategoryCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.emoji,
    required this.onTap,
    this.width = 110,
    this.height = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(-0.1), // Slant effect
          alignment: Alignment.center,
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emoji badge
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const Spacer(),
                    // Label
                    Text(
                      label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
