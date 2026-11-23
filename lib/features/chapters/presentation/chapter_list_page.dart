import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../lesson/presentation/lesson_page.dart';

class ChapterItem {
  final String id;
  final String title;
  final String duration;
  final int xp;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;

  const ChapterItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.xp,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
  });
}

class ChapterListPage extends StatefulWidget {
  final String moduleTitle;

  const ChapterListPage({
    super.key,
    required this.moduleTitle,
  });

  @override
  State<ChapterListPage> createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  final List<ChapterItem> _chapters = const [
    ChapterItem(
      id: 'c1',
      title: 'If-Else Conditions & Ternary Expressions',
      duration: '10 min',
      xp: 20,
      isCompleted: true,
      isCurrent: false,
      isLocked: false,
    ),
    ChapterItem(
      id: 'c2',
      title: 'For, While & Do-While Loops in Dart',
      duration: '12 min',
      xp: 25,
      isCompleted: true,
      isCurrent: false,
      isLocked: false,
    ),
    ChapterItem(
      id: 'c3',
      title: 'Switch Statements & Exhaustive Enums',
      duration: '15 min',
      xp: 30,
      isCompleted: false,
      isCurrent: true,
      isLocked: false,
    ),
    ChapterItem(
      id: 'c4',
      title: 'Break, Continue & Loop Labels',
      duration: '10 min',
      xp: 20,
      isCompleted: false,
      isCurrent: false,
      isLocked: true,
    ),
    ChapterItem(
      id: 'c5',
      title: 'Mini Challenge: Logic & Control Flow Mastery',
      duration: '15 min',
      xp: 50,
      isCompleted: false,
      isCurrent: false,
      isLocked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final completedCount = _chapters.where((c) => c.isCompleted).length;
    final progress = completedCount / _chapters.length;

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
            'Module Chapters',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Header Card for Selected Module
              _buildModuleHeroHeader(completedCount, progress)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, end: 0),

              const SizedBox(height: 24),

              Text(
                'CHAPTERS & TOPICS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.textMuted,
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 14),

              // Staggered Chapter Items List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _chapters.length,
                itemBuilder: (context, index) {
                  final chapter = _chapters[index];
                  return _TactileGlassTile(
                    chapter: chapter,
                    index: index + 1,
                    onTap: () {
                      if (chapter.isLocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Complete Chapter $index to unlock this chapter!',
                              style: GoogleFonts.plusJakartaSans(),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.roseError.withValues(alpha: 0.9),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonPage(
                              lessonTitle: chapter.title,
                              moduleTitle: widget.moduleTitle,
                            ),
                          ),
                        );
                      }
                    },
                  )
                      .animate()
                      .fadeIn(delay: (120 * index).ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleHeroHeader(int completedCount, double progress) {
    return GlassContainer(
      padding: const EdgeInsets.all(22),
      borderRadius: BorderRadius.circular(26),
      borderWidth: 1.2,
      borderGradient: const LinearGradient(
        colors: [AppColors.electricCyan, AppColors.neonViolet],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: 'module_icon_m2',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.neonViolet.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.alt_route_rounded,
                    color: AppColors.neonViolet,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'module_title_m2',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.moduleTitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completedCount of ${_chapters.length} Chapters Completed',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Completion',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.electricCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.electricCyan),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tactile Glass Tile with scale-down press effect and bounce checkmark animation
class _TactileGlassTile extends StatefulWidget {
  final ChapterItem chapter;
  final int index;
  final VoidCallback onTap;

  const _TactileGlassTile({
    required this.chapter,
    required this.index,
    required this.onTap,
  });

  @override
  State<_TactileGlassTile> createState() => _TactileGlassTileState();
}

class _TactileGlassTileState extends State<_TactileGlassTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: GlassContainer(
            padding: const EdgeInsets.all(18),
            borderRadius: BorderRadius.circular(20),
            color: chapter.isCurrent
                ? AppColors.electricCyan.withValues(alpha: 0.12)
                : (chapter.isLocked
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.07)),
            borderWidth: chapter.isCurrent ? 1.5 : 1.0,
            borderGradient: LinearGradient(
              colors: chapter.isCurrent
                  ? [AppColors.electricCyan, AppColors.neonViolet]
                  : [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.05),
                    ],
            ),
            child: Row(
              children: [
                // Chapter Index Badge or Status Icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: chapter.isCompleted
                        ? AppColors.emerald.withValues(alpha: 0.2)
                        : (chapter.isCurrent
                            ? AppColors.electricCyan.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.05)),
                    border: Border.all(
                      color: chapter.isCompleted
                          ? AppColors.emerald
                          : (chapter.isCurrent
                              ? AppColors.electricCyan
                              : Colors.white.withValues(alpha: 0.1)),
                    ),
                  ),
                  child: Center(
                    child: chapter.isCompleted
                        ? const AnimatedScale(
                            scale: 1.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.elasticOut,
                            child: Icon(
                              Icons.check_rounded,
                              color: AppColors.emerald,
                              size: 22,
                            ),
                          )
                        : (chapter.isCurrent
                            ? const Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.electricCyan,
                                size: 22,
                              )
                            : Text(
                                '${widget.index}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  color: chapter.isLocked
                                      ? AppColors.textMuted
                                      : Colors.white,
                                ),
                              )),
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: chapter.isLocked
                              ? AppColors.textMuted
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            chapter.duration,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.bolt_rounded,
                            size: 14,
                            color: AppColors.amberWarning,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '+${chapter.xp} XP',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.amberWarning,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trailing Action Icon
                Icon(
                  chapter.isLocked
                      ? Icons.lock_rounded
                      : Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: chapter.isLocked
                      ? AppColors.textMuted
                      : (chapter.isCurrent
                          ? AppColors.electricCyan
                          : Colors.white.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
