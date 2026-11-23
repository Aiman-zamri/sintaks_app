import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_mesh_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../result/presentation/result_page.dart';

class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

class QuizPage extends StatefulWidget {
  final String moduleTitle;
  final String lessonTitle;

  const QuizPage({
    super.key,
    required this.moduleTitle,
    required this.lessonTitle,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final List<QuizQuestion> _questions = const [
    QuizQuestion(
      questionText: 'What is a defining requirement of Dart 3 Switch Expressions?',
      options: [
        'They require explicit "break" keywords after every case.',
        'They evaluate to a value and must be exhaustive.',
        'They can only evaluate integer types.',
        'They replace all functions in Dart.',
      ],
      correctOptionIndex: 1,
      explanation: 'Dart 3 switch expressions must cover all possible values (exhaustive) and yield a return value without needing "break".',
    ),
    QuizQuestion(
      questionText: 'Which keyword adds an additional guard condition to a switch case in Dart?',
      options: [
        'where',
        'if',
        'when',
        'with',
      ],
      correctOptionIndex: 2,
      explanation: 'The "when" keyword is used in Dart 3 pattern matching to specify guard clauses.',
    ),
    QuizQuestion(
      questionText: 'What occurs if an enum value is omitted in a switch expression without a default case?',
      options: [
        'Compile-time Error',
        'Runtime Exception',
        'Warning log in output',
        'Ignores the omitted case',
      ],
      correctOptionIndex: 0,
      explanation: 'Dart 3 static analysis detects non-exhaustive switch expressions at compile time.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleOptionSelect(int index) {
    if (_isAnswered) return;

    final question = _questions[_currentIndex];
    final isCorrect = index == question.correctOptionIndex;

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (isCorrect) {
        _score++;
      } else {
        _shakeController.forward(from: 0.0);
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
      });
    } else {
      // Quiz Complete -> Navigate to Result Page
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => ResultPage(
            score: _score,
            totalQuestions: _questions.length,
            xpEarned: _score * 25,
            moduleTitle: widget.moduleTitle,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return AnimatedMeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Quiz Challenge',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.electricCyan.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: AppColors.electricCyan),
                  const SizedBox(width: 4),
                  Text(
                    '${_currentIndex + 1}/${_questions.length}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.electricCyan,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Progress Bar
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 400),
                builder: (context, val, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: val,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.electricCyan),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Animated Question Container
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(_currentIndex),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Card
                      GlassContainer(
                        padding: const EdgeInsets.all(22),
                        borderRadius: BorderRadius.circular(24),
                        borderWidth: 1.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QUESTION ${_currentIndex + 1}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: AppColors.electricCyan,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              question.questionText,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Options List with Immediate Feedback
                      ...List.generate(question.options.length, (optIndex) {
                        final optionText = question.options[optIndex];
                        final isSelected = _selectedOptionIndex == optIndex;
                        final isCorrect = optIndex == question.correctOptionIndex;

                        return AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            final shakeOffset = (isSelected && !isCorrect)
                                ? _shakeAnimation.value
                                : 0.0;
                            return Transform.translate(
                              offset: Offset(shakeOffset, 0),
                              child: child,
                            );
                          },
                          child: _buildOptionTile(
                            index: optIndex,
                            text: optionText,
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            onTap: () => _handleOptionSelect(optIndex),
                          ).animate().fadeIn(delay: (100 * optIndex).ms, duration: 300.ms),
                        );
                      }),

                      // Explanation Banner if Answered
                      if (_isAnswered) ...[
                        const SizedBox(height: 20),
                        GlassContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(16),
                          color: _selectedOptionIndex == question.correctOptionIndex
                              ? AppColors.emerald.withValues(alpha: 0.15)
                              : AppColors.roseError.withValues(alpha: 0.15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _selectedOptionIndex == question.correctOptionIndex
                                    ? Icons.check_circle_rounded
                                    : Icons.info_outline_rounded,
                                color: _selectedOptionIndex == question.correctOptionIndex
                                    ? AppColors.emerald
                                    : AppColors.roseError,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  question.explanation,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 24),

                        // Next Question CTA
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _nextQuestion,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColors.electricCyan,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _currentIndex < _questions.length - 1
                                  ? 'Next Question'
                                  : 'See Results',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 300.ms),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required int index,
    required String text,
    required bool isSelected,
    required bool isCorrect,
    required VoidCallback onTap,
  }) {
    Color fillColor = Colors.white.withValues(alpha: 0.06);
    Color borderColor = Colors.white.withValues(alpha: 0.12);
    Color textColor = Colors.white;

    if (_isAnswered) {
      if (isCorrect) {
        fillColor = AppColors.emerald.withValues(alpha: 0.2);
        borderColor = AppColors.emerald;
      } else if (isSelected && !isCorrect) {
        fillColor = AppColors.roseError.withValues(alpha: 0.2);
        borderColor = AppColors.roseError;
      }
    }

    final optionLabels = ['A', 'B', 'C', 'D'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: (isSelected && isCorrect) ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.elasticOut,
          child: GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(18),
            color: fillColor,
            borderWidth: (isSelected || (_isAnswered && isCorrect)) ? 1.5 : 1.0,
            borderGradient: LinearGradient(
              colors: [borderColor, borderColor.withValues(alpha: 0.5)],
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: borderColor.withValues(alpha: 0.2),
                    border: Border.all(color: borderColor),
                  ),
                  child: Center(
                    child: Text(
                      optionLabels[index],
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ),
                if (_isAnswered && isCorrect)
                  const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 22)
                else if (_isAnswered && isSelected && !isCorrect)
                  const Icon(Icons.cancel_rounded, color: AppColors.roseError, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
