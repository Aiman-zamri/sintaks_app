import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../playground/presentation/playground_page.dart';

class CodeSnippet {
  final String id;
  final String title;
  final String language;
  final String date;
  final String code;

  const CodeSnippet({
    required this.id,
    required this.title,
    required this.language,
    required this.date,
    required this.code,
  });
}

class SnippetsPage extends StatefulWidget {
  const SnippetsPage({super.key});

  @override
  State<SnippetsPage> createState() => _SnippetsPageState();
}

class _SnippetsPageState extends State<SnippetsPage> {
  final List<CodeSnippet> _snippets = [
    const CodeSnippet(
      id: 's1',
      title: 'Dart 3 Switch Expression & Enums',
      language: 'Dart',
      date: '2 hours ago',
      code: '''String getStatusMessage(Status status) {
  return switch (status) {
    Status.initial => 'Ready',
    Status.loading => 'Loading...',
    Status.success => 'Completed!',
    Status.error   => 'Error occurred',
  };
}''',
    ),
    const CodeSnippet(
      id: 's2',
      title: 'Glassmorphism Custom Painter Border',
      language: 'Flutter',
      date: 'Yesterday',
      code: '''class GlassBorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final Gradient gradient;

  GlassBorderPainter({required this.borderRadius, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(borderRadius.toRRect(rect), paint);
  }
}''',
    ),
    const CodeSnippet(
      id: 's3',
      title: 'Asynchronous Stream Generator',
      language: 'Dart',
      date: '3 days ago',
      code: '''Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}''',
    ),
  ];

  void _deleteSnippet(int index) {
    final removed = _snippets[index];
    setState(() {
      _snippets.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.roseError.withValues(alpha: 0.25),
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded, color: AppColors.roseError, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Deleted "${removed.title}"',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnippetPreviewModal(CodeSnippet snippet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          snippet.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.electricCyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          snippet.language,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.electricCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Code Syntax Block Preview
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF0F172A),
                    padding: const EdgeInsets.all(14),
                    child: HighlightView(
                      snippet.code,
                      language: 'dart',
                      theme: atomOneDarkTheme,
                      textStyle: GoogleFonts.jetBrainsMono(fontSize: 12, height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons Row
                  Row(
                    children: [
                      // Copy Code Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: snippet.code));
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied to clipboard!', style: GoogleFonts.plusJakartaSans()),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.emerald,
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 18),
                          label: Text(
                            'Copy',
                            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Load in Playground Button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PlaygroundPage(
                                  initialCode: snippet.code,
                                  snippetTitle: snippet.title,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                          label: Text(
                            'Open in Playground',
                            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.electricCyan,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
            'My Saved Snippets',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: _snippets.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bookmark_border_rounded, size: 56, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text(
                      'No Saved Snippets Yet',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Save your favorite code blocks from the Playground!',
                      style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                itemCount: _snippets.length,
                itemBuilder: (context, index) {
                  final snippet = _snippets[index];

                  return Dismissible(
                    key: Key(snippet.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteSnippet(index),
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.roseError.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.roseError.withValues(alpha: 0.4)),
                      ),
                      alignment: Alignment.centerRight,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(18),
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _showSnippetPreviewModal(snippet),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.electricCyan.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    snippet.language,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.electricCyan,
                                    ),
                                  ),
                                ),
                                Text(
                                  snippet.date,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              snippet.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snippet.code,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: (100 * index).ms, duration: 350.ms).slideY(begin: 0.1, end: 0);
                },
              ),
      ),
    );
  }
}
