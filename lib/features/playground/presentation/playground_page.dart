import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/piston_api_service.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_container.dart';

class PlaygroundPage extends StatefulWidget {
  final String? initialCode;
  final String? snippetTitle;

  const PlaygroundPage({
    super.key,
    this.initialCode,
    this.snippetTitle,
  });

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  late TextEditingController _codeController;
  final ScrollController _scrollController = ScrollController();

  bool _isExecuting = false;
  String? _terminalOutput;
  String? _terminalError;
  int? _exitCode;
  bool _isTerminalVisible = false;

  final String _defaultCode = '''void main() {
  print('🚀 Welcome to Sintaks Live Playground!');

  final scores = [85, 92, 78, 95, 88];
  final average = scores.reduce((a, b) => a + b) / scores.length;

  print('Student Scores: \$scores');
  print('Average Score: \${average.toStringAsFixed(1)} XP');
}''';

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: widget.initialCode ?? _defaultCode,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _runCode() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isExecuting = true;
      _isTerminalVisible = true;
      _terminalOutput = 'Running Dart compiler on Piston API...';
      _terminalError = null;
      _exitCode = null;
    });

    final result = await PistonApiService.executeDartCode(_codeController.text);

    if (mounted) {
      setState(() {
        _isExecuting = false;
        _terminalOutput = result.output;
        _terminalError = result.stderr.isNotEmpty ? result.stderr : null;
        _exitCode = result.exitCode;
      });
    }
  }

  void _saveSnippet() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.emerald.withValues(alpha: 0.2),
          borderGradient: LinearGradient(
            colors: [
              AppColors.emerald.withValues(alpha: 0.6),
              AppColors.emerald.withValues(alpha: 0.1),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.bookmark_added_rounded, color: AppColors.emerald, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Snippet saved to "My Saved Snippets"!',
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
  }

  @override
  Widget build(BuildContext context) {
    final lineCount = '\n'.allMatches(_codeController.text).length + 1;

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
            widget.snippetTitle ?? 'Code Playground',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_outline_rounded, color: Colors.white),
              tooltip: 'Save Code',
              onPressed: _saveSnippet,
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              tooltip: 'Reset Code',
              onPressed: () {
                setState(() {
                  _codeController.text = _defaultCode;
                  _terminalOutput = null;
                  _isTerminalVisible = false;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Code Editor Panel
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: GlassContainer(
                  borderRadius: BorderRadius.circular(22),
                  color: const Color(0xFF0F172A),
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Editor Header Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
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
                                  'main.dart',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    color: AppColors.electricCyan,
                                  ),
                                ),
                              ],
                            ),

                            // Piston API Engine Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.electricCyan.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'PISTON API v2',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.electricCyan,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Code Text Area with Line Numbers
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Line Numbers Column
                            Container(
                              width: 36,
                              padding: const EdgeInsets.only(top: 14),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.02),
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.06),
                                  ),
                                ),
                              ),
                              child: Column(
                                children: List.generate(
                                  math.max(lineCount, 15),
                                  (index) => Text(
                                    '${index + 1}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 12,
                                      height: 1.5,
                                      color: AppColors.textMuted.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Main Code Text Field
                            Expanded(
                              child: TextField(
                                controller: _codeController,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                onChanged: (_) => setState(() {}),
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Bar (Run Button & Console Toggle)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  if (_terminalOutput != null)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isTerminalVisible = !_isTerminalVisible;
                        });
                      },
                      icon: Icon(
                        _isTerminalVisible
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.terminal_rounded,
                        color: AppColors.electricCyan,
                      ),
                      label: Text(
                        _isTerminalVisible ? 'Hide Console' : 'Show Console',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.electricCyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Glowing Run Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isExecuting ? null : _runCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.emerald, AppColors.electricCyan],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emerald.withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              if (_isExecuting) ...[
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Compiling...',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ] else ...[
                                const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                                const SizedBox(width: 6),
                                Text(
                                  'Run Code',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Console Output Terminal Panel (Slide-Up Animated Reveal)
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              height: _isTerminalVisible ? 180 : 0,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GlassContainer(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFF0B1120),
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Terminal Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.terminal_rounded, size: 16, color: AppColors.electricCyan),
                          const SizedBox(width: 8),
                          Text(
                            'Console Output',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          if (_exitCode != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _exitCode == 0
                                    ? AppColors.emerald.withValues(alpha: 0.2)
                                    : AppColors.roseError.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _exitCode == 0 ? 'Exit Code: 0 (Success)' : 'Exit Code: $_exitCode',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _exitCode == 0 ? AppColors.emerald : AppColors.roseError,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Output Text Area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_terminalError != null)
                              Text(
                                _terminalError!,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  color: AppColors.roseError,
                                ),
                              ),
                            if (_terminalOutput != null)
                              Text(
                                _terminalOutput!,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: AppColors.electricCyan,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
