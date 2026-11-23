import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'glass_container.dart';

/// Floating Glassmorphic Bottom Navigation Bar with smooth sliding active pill indicator
class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Home'),
    _NavItem(icon: Icons.map_rounded, label: 'Roadmap'),
    _NavItem(icon: Icons.code_rounded, label: 'Playground'),
    _NavItem(icon: Icons.bookmark_rounded, label: 'Snippets'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 68,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(34),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        blur: 20,
        color: AppColors.background.withOpacity(0.65),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / _items.length;
            return Stack(
              children: [
                // Animated Sliding Glass Pill Indicator
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  left: currentIndex * itemWidth + 4,
                  top: 6,
                  bottom: 6,
                  width: itemWidth - 8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.electricCyan.withOpacity(0.35),
                          AppColors.neonViolet.withOpacity(0.35),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.electricCyan.withOpacity(0.25),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),

                // Nav Item Icons & Labels
                Row(
                  children: List.generate(_items.length, (index) {
                    final isSelected = index == currentIndex;
                    final item = _items[index];

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: isSelected ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                item.icon,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textMuted,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 3),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.electricCyan
                                    : AppColors.textMuted,
                              ),
                              child: Text(item.label),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
