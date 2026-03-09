import 'package:flutter/material.dart';
import 'package:nestify/config/theme/app_colors.dart';
import 'package:nestify/config/theme/app_text_styles.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onCenterTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.onCenterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom navigation items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  index: 0,
                  isActive: currentIndex == 0,
                ),
                _buildNavItem(
                  icon: Icons.search,
                  label: 'Search',
                  index: 1,
                  isActive: currentIndex == 1,
                ),
                // Spacer for center button
                const SizedBox(width: 60),
                _buildNavItem(
                  icon: Icons.headset_mic_outlined,
                  label: 'Support',
                  index: 2,
                  isActive: currentIndex == 2,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  index: 3,
                  isActive: currentIndex == 3,
                ),
              ],
            ),
          ),
          
          // Elevated center button (Favourite)
          Positioned(
            top: -25,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: GestureDetector(
              onTap: onCenterTap,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE53935),
                      Color(0xFFD32F2F),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53935).withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          
          // Label for center button
          Positioned(
            bottom: 8,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: SizedBox(
              width: 70,
              child: Text(
                'Favourite',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF2196F3) : Colors.grey[600],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? const Color(0xFF2196F3) : Colors.grey[600],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
