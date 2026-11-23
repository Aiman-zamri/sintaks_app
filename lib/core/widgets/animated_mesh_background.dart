import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Global Animated Mesh-Gradient Background widget with floating glowing blurred orbs
class AnimatedMeshBackground extends StatefulWidget {
  final Widget child;

  const AnimatedMeshBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedMeshBackground> createState() => _AnimatedMeshBackgroundState();
}

class _AnimatedMeshBackgroundState extends State<AnimatedMeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Animated Mesh Gradient Orbs
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final val = _controller.value;
              final sinVal = math.sin(val * math.pi * 2);
              final cosVal = math.cos(val * math.pi * 2);

              return Stack(
                children: [
                  // Orb 1: Electric Cyan (Top-Left floating)
                  Positioned(
                    top: size.height * 0.05 + (sinVal * 45),
                    left: size.width * 0.05 + (cosVal * 35),
                    child: _buildBlurOrb(
                      size: size.width * 0.75,
                      color: AppColors.electricCyan.withOpacity(0.35),
                    ),
                  ),

                  // Orb 2: Neon Violet (Center-Right floating)
                  Positioned(
                    top: size.height * 0.35 - (cosVal * 55),
                    right: -size.width * 0.15 + (sinVal * 40),
                    child: _buildBlurOrb(
                      size: size.width * 0.85,
                      color: AppColors.neonViolet.withOpacity(0.35),
                    ),
                  ),

                  // Orb 3: Emerald (Bottom-Left floating)
                  Positioned(
                    bottom: size.height * 0.08 + (cosVal * 40),
                    left: -size.width * 0.1 + (sinVal * 50),
                    child: _buildBlurOrb(
                      size: size.width * 0.70,
                      color: AppColors.emerald.withOpacity(0.30),
                    ),
                  ),
                ],
              );
            },
          ),

          // Main Screen Content
          SafeArea(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  Widget _buildBlurOrb({required double size, required Color color}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
