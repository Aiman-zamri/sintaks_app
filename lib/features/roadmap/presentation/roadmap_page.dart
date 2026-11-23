import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../chapters/presentation/chapter_list_page.dart';

class RoadmapModule {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int totalChapters;
  final int completedChapters;
  final bool isLocked;
  final Color accentColor;

  const RoadmapModule({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.totalChapters,
    required this.completedChapters,
    required this.isLocked,
    required this.accentColor,
  });

  double get progress => totalChapters == 0 ? 0 : completedChapters / totalChapters;
}

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({super.key});

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> with TickerProviderStateMixin {
  final List<RoadmapModule> _modules = const [
    RoadmapModule(
      id: 'm1',
      title: 'Dart Basics & Variables',
      description: 'Data types, String interpolation, final vs const, null safety.',
      icon: Icons.code_rounded,
      totalChapters: 4,
      completedChapters: 4,
      isLocked: false,
      accentColor: AppColors.electricCyan,
    ),
    RoadmapModule(
      id: 'm2',
      title: 'Control Flow & Loops',
      description: 'If-else statements, switch-case, for/while loops, enums.',
      icon: Icons.alt_route_rounded,
      totalChapters: 5,
      completedChapters: 3,
      isLocked: false,
      accentColor: AppColors.neonViolet,
    ),
    RoadmapModule(
      id: 'm3',
      title: 'Functions & Closures',
      description: 'Named parameters, arrow functions, anonymous functions & scope.',
      icon: Icons.functions_rounded,
      totalChapters: 4,
      completedChapters: 0,
      isLocked: true,
      accentColor: AppColors.emerald,
    ),
    RoadmapModule(
      id: 'm4',
      title: 'Object-Oriented Dart',
      description: 'Classes, constructors, inheritance, mixins, and abstract classes.',
      icon: Icons.view_in_ar_rounded,
      totalChapters: 6,
      completedChapters: 0,
      isLocked: true,
      accentColor: AppColors.amberWarning,
    ),
    RoadmapModule(
      id: 'm5',
      title: 'Asynchronous Dart',
      description: 'Futures, async/await, Streams, and error handling.',
      icon: Icons.sync_rounded,
      totalChapters: 5,
      completedChapters: 0,
      isLocked: true,
      accentColor: AppColors.electricCyan,
    ),
  ];

  // Map to store per-item shake controllers for locked modules
  late Map<String, AnimationController> _shakeControllers;
  late Map<String, Animation<double>> _shakeAnimations;

  @override
  void initState() {
    super.initState();
    _shakeControllers = {};
    _shakeAnimations = {};

    for (final m in _modules) {
      if (m.isLocked) {
        final controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        );
        final anim = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: -6.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
        ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

        _shakeControllers[m.id] = controller;
        _shakeAnimations[m.id] = anim;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _shakeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onModuleTap(RoadmapModule module) {
    if (module.isLocked) {
      // Trigger shake animation for locked module
      _shakeControllers[module.id]?.forward(from: 0.0);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 2),
          content: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderRadius: BorderRadius.circular(16),
            color: AppColors.roseError.withValues(alpha: 0.2),
            borderGradient: LinearGradient(
              colors: [
                AppColors.roseError.withValues(alpha: 0.5),
                AppColors.roseError.withValues(alpha: 0.1),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_rounded, color: AppColors.roseError, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Complete previous module to unlock "${module.title}"!',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => ChapterListPage(moduleTitle: module.title),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
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
            'Learning Roadmap',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Roadmap Progress Summary Header Card
              _buildProgressSummaryCard().animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

              const SizedBox(height: 30),

              // Vertical Learning Path
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _modules.length,
                itemBuilder: (context, index) {
                  final module = _modules[index];
                  final isLast = index == _modules.length - 1;
                  final shakeAnim = _shakeAnimations[module.id];

                  return _buildPathNodeItem(
                    module: module,
                    isLast: isLast,
                    index: index,
                    shakeAnim: shakeAnim,
                  ).animate().fadeIn(delay: (100 * index).ms, duration: 400.ms).slideY(begin: 0.1, end: 0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSummaryCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(24),
      color: Colors.white.withValues(alpha: 0.07),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.electricCyan.withValues(alpha: 0.3),
                  AppColors.neonViolet.withValues(alpha: 0.3),
                ],
              ),
            ),
            child: const Icon(
              Icons.route_rounded,
              color: AppColors.electricCyan,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dart Programming Track',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '2 of 5 Modules Unlocked • 7 Chapters Done',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 7 / 24,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.electricCyan),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathNodeItem({
    required RoadmapModule module,
    required bool isLast,
    required int index,
    Animation<double>? shakeAnim,
  }) {
    Widget cardChild = GlassContainer(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(22),
      color: module.isLocked
          ? Colors.white.withValues(alpha: 0.03)
          : module.accentColor.withValues(alpha: 0.08),
      borderWidth: module.isLocked ? 0.8 : 1.2,
      borderGradient: LinearGradient(
        colors: module.isLocked
            ? [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.02),
              ]
            : [
                module.accentColor.withValues(alpha: 0.5),
                module.accentColor.withValues(alpha: 0.1),
              ],
      ),
      onTap: () => _onModuleTap(module),
      child: Stack(
        children: [
          Row(
            children: [
              // Hero Icon Badge
              Hero(
                tag: 'module_icon_${module.id}',
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: module.isLocked
                        ? Colors.white.withValues(alpha: 0.05)
                        : module.accentColor.withValues(alpha: 0.2),
                    border: Border.all(
                      color: module.isLocked
                          ? Colors.white.withValues(alpha: 0.1)
                          : module.accentColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(
                    module.isLocked ? Icons.lock_rounded : module.icon,
                    color: module.isLocked
                        ? AppColors.textMuted
                        : module.accentColor,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'module_title_${module.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          module.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: module.isLocked
                                ? AppColors.textMuted
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Module Progress Pill
                    Row(
                      children: [
                        Text(
                          module.isLocked
                              ? 'Locked'
                              : '${module.completedChapters}/${module.totalChapters} Chapters',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: module.isLocked
                                ? AppColors.textMuted
                                : module.accentColor,
                          ),
                        ),
                        if (!module.isLocked && module.progress > 0) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: module.progress,
                                minHeight: 4,
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(module.accentColor),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Frosted Lock Overlay Badge
          if (module.isLocked)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 12, color: AppColors.textMuted),
                    SizedBox(width: 4),
                    Text(
                      'LOCKED',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    // Apply Shake Animation if locked module
    if (shakeAnim != null) {
      cardChild = AnimatedBuilder(
        animation: shakeAnim,
        builder: (context, child) => Transform.translate(
          offset: Offset(shakeAnim.value, 0),
          child: child,
        ),
        child: cardChild,
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Vertical Connecting Line Column
          SizedBox(
            width: 36,
            child: Column(
              children: [
                // Glowing Node Dot
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: module.isLocked
                        ? AppColors.textMuted.withValues(alpha: 0.3)
                        : module.accentColor,
                    boxShadow: module.isLocked
                        ? []
                        : [
                            BoxShadow(
                              color: module.accentColor.withValues(alpha: 0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Animated Connecting Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            module.isLocked
                                ? AppColors.textMuted.withValues(alpha: 0.2)
                                : module.accentColor.withValues(alpha: 0.8),
                            _modules[index + 1].isLocked
                                ? AppColors.textMuted.withValues(alpha: 0.2)
                                : _modules[index + 1].accentColor.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Main Card Container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: cardChild,
            ),
          ),
        ],
      ),
    );
  }
}
