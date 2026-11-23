import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../auth/presentation/auth_page.dart';

class LeaderboardUser {
  final int rank;
  final String name;
  final int xp;
  final String avatarUrl;
  final bool isCurrentUser;

  const LeaderboardUser({
    required this.rank,
    required this.name,
    required this.xp,
    required this.avatarUrl,
    this.isCurrentUser = false,
  });
}

class ProfilePage extends StatefulWidget {
  final int initialTab;

  const ProfilePage({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int _selectedTab;
  bool _soundEffectsEnabled = true;

  final List<LeaderboardUser> _topLearners = const [
    LeaderboardUser(rank: 1, name: 'DevPro_Sarah', xp: 1420, avatarUrl: '👩‍💻'),
    LeaderboardUser(rank: 2, name: 'Marcus_Dart', xp: 1280, avatarUrl: '👨‍💻'),
    LeaderboardUser(rank: 3, name: 'Elena_Codes', xp: 1150, avatarUrl: '🚀'),
    LeaderboardUser(rank: 4, name: 'Alex Rivera', xp: 450, avatarUrl: '⚡', isCurrentUser: true),
    LeaderboardUser(rank: 5, name: 'Kaelen_Flutter', xp: 420, avatarUrl: '👾'),
    LeaderboardUser(rank: 6, name: 'Zack_Syntax', xp: 390, avatarUrl: '🎯'),
    LeaderboardUser(rank: 7, name: 'Nadia_Dev', xp: 350, avatarUrl: '💡'),
    LeaderboardUser(rank: 8, name: 'Oliver_Code', xp: 310, avatarUrl: '🔥'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedMeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Profile & Leaderboard',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),

            // Frosted Glass Segmented Control
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSegmentedControl(),
            ),

            const SizedBox(height: 20),

            // Tab Content Switcher
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedTab == 0
                    ? _buildProfileTab()
                    : _buildLeaderboardTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return GlassContainer(
      height: 52,
      borderRadius: BorderRadius.circular(26),
      padding: const EdgeInsets.all(4),
      color: Colors.white.withValues(alpha: 0.06),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              // Sliding Glass Pill Indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: _selectedTab * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.electricCyan, AppColors.neonViolet],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricCyan.withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Titles Row
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Text(
                          'My Profile',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.w500,
                            color: _selectedTab == 0 ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Text(
                          'Leaderboard 🏆',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.w500,
                            color: _selectedTab == 1 ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // TAB 1: Profile View
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        children: [
          // Profile Avatar & User Details
          GlassContainer(
            padding: const EdgeInsets.all(22),
            borderRadius: BorderRadius.circular(26),
            child: Column(
              children: [
                // Glowing Avatar Halo
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.electricCyan, AppColors.neonViolet],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricCyan.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xFF1E293B),
                    child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  'Alex Rivera',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'alex.rivera@sintaks.dev',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),

                // Rank Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.electricCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.electricCyan.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Level 4 • Novice Coder (450 XP)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.electricCyan,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),

          const SizedBox(height: 20),

          // Stats Cards Grid
          Row(
            children: [
              _buildStatBox(title: 'Lessons', value: '12', icon: Icons.book_rounded, color: AppColors.electricCyan),
              const SizedBox(width: 12),
              _buildStatBox(title: 'Quizzes', value: '8 Won', icon: Icons.emoji_events_rounded, color: AppColors.emerald),
              const SizedBox(width: 12),
              _buildStatBox(title: 'Streak', value: '5 Days', icon: Icons.local_fire_department_rounded, color: AppColors.amberWarning),
            ],
          ).animate().fadeIn(delay: 150.ms, duration: 350.ms),

          const SizedBox(height: 20),

          // Account Options & Logout Card
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(22),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sound Effects',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.white),
                    ),
                    Switch(
                      value: _soundEffectsEnabled,
                      activeColor: AppColors.electricCyan,
                      onChanged: (v) => setState(() => _soundEffectsEnabled = v),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10),
                const SizedBox(height: 8),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const AuthPage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, color: AppColors.roseError, size: 20),
                    label: Text(
                      'Log Out of Sintaks',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.roseError,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppColors.roseError.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 350.ms),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Leaderboard View with Staggered Podium
  Widget _buildLeaderboardTab() {
    final top3 = _topLearners.take(3).toList();
    final rest = _topLearners.skip(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        children: [
          // Top 3 Podium
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Rank 2 (Silver)
              _buildPodiumTile(user: top3[1], color: const Color(0xFFC0C0C0), height: 110)
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(width: 12),

              // Rank 1 (Gold)
              _buildPodiumTile(user: top3[0], color: const Color(0xFFFFD700), height: 135)
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(width: 12),

              // Rank 3 (Bronze)
              _buildPodiumTile(user: top3[2], color: const Color(0xFFCD7F32), height: 95)
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),

          const SizedBox(height: 28),

          // Ranks 4 to 10 List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rest.length,
            itemBuilder: (context, index) {
              final user = rest[index];
              final isCurrent = user.isCurrentUser;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  borderRadius: BorderRadius.circular(16),
                  color: isCurrent
                      ? AppColors.electricCyan.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  borderWidth: isCurrent ? 1.5 : 0.8,
                  borderGradient: LinearGradient(
                    colors: isCurrent
                        ? [AppColors.electricCyan, AppColors.neonViolet]
                        : [Colors.white10, Colors.white10],
                  ),
                  child: Row(
                    children: [
                      Text(
                        '#${user.rank}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? AppColors.electricCyan : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(user.avatarUrl, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '${user.xp} XP',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? AppColors.electricCyan : AppColors.amberWarning,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (350 + index * 50).ms, duration: 300.ms);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumTile({
    required LeaderboardUser user,
    required Color color,
    required double height,
  }) {
    return Column(
      children: [
        // Avatar Emoji & Rank Pill
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 12),
                ],
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF1E293B),
                child: Text(user.avatarUrl, style: const TextStyle(fontSize: 22)),
              ),
            ),
            Positioned(
              top: -12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${user.rank}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Text(
          user.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          '${user.xp} XP',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        // Glass Podium Pillar
        GlassContainer(
          width: 90,
          height: height,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          color: color.withValues(alpha: 0.15),
          borderWidth: 1.2,
          borderGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color, color.withValues(alpha: 0.1)],
          ),
          child: Center(
            child: Icon(Icons.emoji_events_rounded, color: color, size: 28),
          ),
        ),
      ],
    );
  }
}
