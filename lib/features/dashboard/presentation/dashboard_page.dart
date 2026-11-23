import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_bottom_nav.dart';
import '../../../core/widgets/glass_container.dart';
import '../../auth/presentation/auth_page.dart';
import '../../chapters/presentation/chapter_list_page.dart';
import '../../lesson/presentation/lesson_page.dart';
import '../../playground/presentation/playground_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../roadmap/presentation/roadmap_page.dart';
import '../../snippets/presentation/snippets_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _currentNavIndex = 0;

  // Pulse Controller for "Continue Learning" Glowing Border
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RoadmapPage()),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PlaygroundPage()),
      );
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SnippetsPage()),
      );
    } else if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else {
      setState(() {
        _currentNavIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedMeshBackground(
      child: Stack(
        children: [
          // Scrollable Dashboard Body
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Greeting & Avatar Row
                _buildHeaderSection().animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

                const SizedBox(height: 20),

                // Animated XP & Level Progress Card
                _buildXpLevelCard().animate().fadeIn(delay: 150.ms, duration: 450.ms).slideY(begin: 0.15, end: 0),

                const SizedBox(height: 24),

                // "Continue Learning" Hero Card with Pulsing Glowing Border
                _buildContinueLearningCard(context).animate().fadeIn(delay: 300.ms, duration: 450.ms).slideY(begin: 0.15, end: 0),

                const SizedBox(height: 28),

                // Quick Access Shortcuts Header
                Text(
                  'Quick Access',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 14),

                // Quick Shortcuts Grid
                _buildQuickShortcutsGrid(context).animate().fadeIn(delay: 450.ms, duration: 450.ms).slideY(begin: 0.15, end: 0),

                const SizedBox(height: 28),

                // Daily Micro-Challenge Banner
                _buildDailyChallengeCard(context).animate().fadeIn(delay: 550.ms, duration: 450.ms).slideY(begin: 0.15, end: 0),
              ],
            ),
          ),

          // Floating Glassmorphic Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassBottomNav(
              currentIndex: _currentNavIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        // Glowing Avatar Ring
        Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.electricCyan, AppColors.neonViolet],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.electricCyan.withOpacity(0.35),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xFF1E293B),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(width: 14),

        // Greeting Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Alex! 👋',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Ready to conquer Dart syntax today?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Notification / Logout Icon
        GlassContainer(
          blur: 12,
          padding: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AuthPage()),
            );
          },
          child: const Icon(
            Icons.logout_rounded,
            color: AppColors.roseError,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildXpLevelCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(24),
      color: Colors.white.withOpacity(0.07),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.electricCyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.electricCyan,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level 4 • Novice Coder',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '450 / 600 XP to Level 5',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Streak Counter Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.amberWarning.withOpacity(0.25),
                      Colors.orange.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.amberWarning.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🔥 ', style: TextStyle(fontSize: 14)),
                    Text(
                      '5 Days',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.amberWarning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // TweenAnimationBuilder for XP Progress Bar
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 0.75),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Container(
                          height: 10,
                          width: double.infinity,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        FractionallySizedBox(
                          widthFactor: value,
                          child: Container(
                            height: 10,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.electricCyan,
                                  AppColors.neonViolet,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(value * 100).toInt()}% completed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.electricCyan,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueLearningCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return GlassContainer(
          padding: const EdgeInsets.all(22),
          borderRadius: BorderRadius.circular(24),
          borderWidth: 1.5,
          borderGradient: LinearGradient(
            colors: [
              AppColors.electricCyan.withOpacity(_pulseAnimation.value),
              AppColors.neonViolet.withOpacity(_pulseAnimation.value * 0.5),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neonViolet.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'CURRENT MODULE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: AppColors.neonViolet,
                      ),
                    ),
                  ),
                  Text(
                    'Module 2 of 6',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Dart Control Flow & Loops',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Lesson 3: Switch Statements & Enums',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LessonPage(
                          lessonTitle: 'Switch Statements & Enums',
                          moduleTitle: 'Dart Control Flow & Loops',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.electricCyan, AppColors.emerald],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Resume Learning',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickShortcutsGrid(BuildContext context) {
    final shortcuts = [
      _ShortcutItem(
        title: 'Roadmap',
        subtitle: 'Visual Path',
        icon: Icons.map_rounded,
        color: AppColors.electricCyan,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RoadmapPage()),
        ),
      ),
      _ShortcutItem(
        title: 'Playground',
        subtitle: 'Live Compiler',
        icon: Icons.code_rounded,
        color: AppColors.neonViolet,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PlaygroundPage()),
        ),
      ),
      _ShortcutItem(
        title: 'My Snippets',
        subtitle: 'Saved Code',
        icon: Icons.bookmark_rounded,
        color: AppColors.emerald,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SnippetsPage()),
        ),
      ),
      _ShortcutItem(
        title: 'Leaderboard',
        subtitle: 'Top Learners',
        icon: Icons.emoji_events_rounded,
        color: AppColors.amberWarning,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfilePage(initialTab: 1)),
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.45,
      ),
      itemCount: shortcuts.length,
      itemBuilder: (context, index) {
        final item = shortcuts[index];
        return GlassContainer(
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(16),
          onTap: item.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyChallengeCard(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(22),
      color: AppColors.emerald.withOpacity(0.08),
      borderGradient: LinearGradient(
        colors: [
          AppColors.emerald.withOpacity(0.4),
          AppColors.emerald.withOpacity(0.1),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.emerald.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: AppColors.emerald,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Syntax Challenge',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Complete today\'s challenge for +50 XP!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChapterListPage(
                    moduleTitle: 'Dart Control Flow & Loops',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              backgroundColor: AppColors.emerald,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Start',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ShortcutItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
