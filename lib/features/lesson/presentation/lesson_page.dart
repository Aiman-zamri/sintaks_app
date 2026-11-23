import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../quiz/presentation/quiz_page.dart';

class LessonPage extends StatefulWidget {
  final String lessonTitle;
  final String moduleTitle;

  const LessonPage({
    super.key,
    required this.lessonTitle,
    required this.moduleTitle,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final ScrollController _scrollController = ScrollController();
  double _readingProgress = 0.0;
  final Map<int, bool> _copiedState = {};

  final String _codeSnippet1 = '''
// Dart 3 Switch Expression Example
enum Status { initial, loading, success, error }

String getStatusMessage(Status status) {
  return switch (status) {
    Status.initial => 'Ready to start',
    Status.loading => 'Processing request...',
    Status.success => 'Operation completed successfully! 🎉',
    Status.error   => 'An unexpected error occurred. ⚠️',
  };
}

void main() {
  final currentStatus = Status.success;
  print(getStatusMessage(currentStatus));
}''';

  final String _codeSnippet2 = '''
// Pattern Matching with Guards
void handleResponse(dynamic response) {
  switch (response) {
    case int code when code >= 200 && code < 300:
      print('Success response code: \$code');
    case int code when code >= 400:
      print('Client error code: \$code');
    case String message:
      print('Message response: \$message');
    default:
      print('Unknown response payload');
  }
}''';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  void _updateProgress() {
    if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
      final progress = (_scrollController.offset / _scrollController.position.maxScrollExtent)
          .clamp(0.0, 1.0);
      setState(() {
        _readingProgress = progress;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _copyToClipboard(int codeIndex, String code) {
    Clipboard.setData(ClipboardData(text: code));
    setState(() {
      _copiedState[codeIndex] = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copiedState[codeIndex] = false;
        });
      }
    });
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
            widget.lessonTitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border_rounded, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Lesson bookmarked to your saved collection!',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.electricCyan.withValues(alpha: 0.9),
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: _readingProgress,
              minHeight: 3,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.electricCyan),
            ),
          ),
        ),
        body: Stack(
          children: [
            // Scrollable Reading Content
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topic Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.electricCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.moduleTitle.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: AppColors.electricCyan,
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 12),

                  // Lesson Title Heading
                  Text(
                    widget.lessonTitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 16),

                  // Section 1: Intro Card
                  GlassContainer(
                    padding: const EdgeInsets.all(18),
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_outline_rounded, color: AppColors.amberWarning, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Key Concept',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Dart 3 introduced powerful Switch Expressions. Unlike legacy switch statements, switch expressions produce a value, require no break statements, and enforce exhaustive matching when operating on enums or sealed classes.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 24),

                  // Section 2: Code Snippet 1
                  _buildCodeBlockSection(
                    title: '1. Switch Expression Syntax',
                    code: _codeSnippet1,
                    codeIndex: 1,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 24),

                  // Section 3: Explanation Note
                  GlassContainer(
                    padding: const EdgeInsets.all(18),
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.neonViolet.withValues(alpha: 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guards & Pattern Matching',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You can add guard clauses using the "when" keyword to evaluate extra boolean conditions before a case matches.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 24),

                  // Section 4: Code Snippet 2
                  _buildCodeBlockSection(
                    title: '2. Pattern Matching with Guards',
                    code: _codeSnippet2,
                    codeIndex: 2,
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Slide-up Reveal CTA Bar at the Bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GlassContainer(
                blur: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                color: AppColors.background.withValues(alpha: 0.8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizPage(
                            moduleTitle: widget.moduleTitle,
                            lessonTitle: widget.lessonTitle,
                          ),
                        ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Take Quiz Challenge',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ).animate().slideY(begin: 0.5, end: 0, duration: 400.ms, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBlockSection({
    required String title,
    required String code,
    required int codeIndex,
  }) {
    final isCopied = _copiedState[codeIndex] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        GlassContainer(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFF0F172A),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Code Block Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF5F56))),
                        const SizedBox(width: 6),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFBD2E))),
                        const SizedBox(width: 6),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF27C93F))),
                        const SizedBox(width: 12),
                        Text(
                          'example.dart',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),

                    // Copy Code Button with Morphing Animation
                    GestureDetector(
                      onTap: () => _copyToClipboard(codeIndex, code),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCopied
                              ? AppColors.emerald.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCopied
                                ? AppColors.emerald
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Icon(
                                isCopied ? Icons.check_rounded : Icons.copy_rounded,
                                key: ValueKey<bool>(isCopied),
                                size: 14,
                                color: isCopied ? AppColors.emerald : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isCopied ? 'Copied!' : 'Copy',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isCopied ? AppColors.emerald : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Syntax Highlighted View
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(14),
                child: HighlightView(
                  code,
                  language: 'dart',
                  theme: atomOneDarkTheme,
                  textStyle: GoogleFonts.jetBrainsMono(
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
