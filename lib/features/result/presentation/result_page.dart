import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../dashboard/presentation/dashboard_page.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int xpEarned;
  final String moduleTitle;

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.xpEarned,
    required this.moduleTitle,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));

    // Play confetti if score is at least 50%
    if (widget.score > 0 && (widget.score / widget.totalQuestions) >= 0.5) {
      _confettiController.play();
    }

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = (widget.score / widget.totalQuestions * 100).toInt();
    final isPassed = accuracy >= 60;

    return AnimatedMeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Confetti Burst Overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  AppColors.electricCyan,
                  AppColors.neonViolet,
                  AppColors.emerald,
                  AppColors.amberWarning,
                ],
              ),
            ),

            // Scrollable Content Body
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Pulsing Radial Glow Badge Container
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glowing Radial Blur Behind Badge
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPassed
                                  ? AppColors.electricCyan.withValues(alpha: _glowAnimation.value * 0.5)
                                  : AppColors.amberWarning.withValues(alpha: _glowAnimation.value * 0.4),
                              boxShadow: [
                                BoxShadow(
                                  color: isPassed
                                      ? AppColors.electricCyan.withValues(alpha: _glowAnimation.value * 0.6)
                                      : AppColors.amberWarning.withValues(alpha: _glowAnimation.value * 0.5),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),

                          // Glass Achievement Badge Circle
                          GlassContainer(
                            width: 110,
                            height: 110,
                            shape: BoxShape.circle,
                            blur: 20,
                            borderWidth: 2,
                            borderGradient: LinearGradient(
                              colors: isPassed
                                  ? [AppColors.electricCyan, AppColors.neonViolet]
                                  : [AppColors.amberWarning, Colors.orange],
                            ),
                            child: Icon(
                              isPassed ? Icons.emoji_events_rounded : Icons.star_half_rounded,
                              size: 56,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 24),

                  // Outcome Title
                  Text(
                    isPassed ? 'Quiz Mastered! 🎉' : 'Keep Practicing! 💪',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 6),

                  Text(
                    widget.moduleTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 250.ms),

                  const SizedBox(height: 30),

                  // Animated Count-Up Score & XP Cards Row
                  Row(
                    children: [
                      // Score Count-Up Ticker Card
                      Expanded(
                        child: GlassContainer(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          borderRadius: BorderRadius.circular(22),
                          child: Column(
                            children: [
                              Text(
                                'SCORE',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // TweenAnimationBuilder for Score Ticker
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: widget.score),
                                duration: const Duration(milliseconds: 1200),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) {
                                  return Text(
                                    '$value / ${widget.totalQuestions}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.electricCyan,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // XP Earned Count-Up Ticker Card
                      Expanded(
                        child: GlassContainer(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          borderRadius: BorderRadius.circular(22),
                          child: Column(
                            children: [
                              Text(
                                'XP EARNED',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // TweenAnimationBuilder for XP Ticker
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: widget.xpEarned),
                                duration: const Duration(milliseconds: 1400),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) {
                                  return Text(
                                    '+$value XP',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.amberWarning,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 20),

                  // Breakdown Details Card
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        _buildStatRow(
                          icon: Icons.percent_rounded,
                          label: 'Accuracy',
                          value: '$accuracy%',
                          color: AppColors.emerald,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Colors.white10),
                        ),
                        _buildStatRow(
                          icon: Icons.local_fire_department_rounded,
                          label: 'Streak Bonus',
                          value: '+5 XP',
                          color: AppColors.amberWarning,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Colors.white10),
                        ),
                        _buildStatRow(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'Supabase Sync',
                          value: 'Synced ✓',
                          color: AppColors.electricCyan,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 36),

                  // Return to Dashboard CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const DashboardPage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.electricCyan, AppColors.neonViolet],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.electricCyan.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          child: Text(
                            'Continue Dashboard',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 550.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
