import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable Glassmorphism Container Widget with blur, border gradient, and soft shadow
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? color;
  final double borderWidth;
  final VoidCallback? onTap;
  final Gradient? borderGradient;
  final BoxShape shape;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 16.0,
    this.color,
    this.borderWidth = 1.2,
    this.onTap,
    this.borderGradient,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = shape == BoxShape.circle
        ? null
        : (borderRadius ?? BorderRadius.circular(20));
    final effectiveColor = color ?? AppColors.glassFill;

    final defaultBorderGradient = borderGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.glassBorderStart,
            AppColors.glassBorderEnd,
          ],
        );

    Widget containerContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
        shape: shape,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    Widget glassWidget = Container(
      margin: margin,
      child: CustomPaint(
        foregroundPainter: _GlassBorderPainter(
          borderRadius: effectiveBorderRadius,
          borderWidth: borderWidth,
          gradient: defaultBorderGradient,
          shape: shape,
        ),
        child: shape == BoxShape.circle
            ? ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: containerContent,
                ),
              )
            : ClipRRect(
                borderRadius: effectiveBorderRadius!,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: containerContent,
                ),
              ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          customBorder: shape == BoxShape.circle ? const CircleBorder() : null,
          child: glassWidget,
        ),
      );
    }

    return glassWidget;
  }
}

class _GlassBorderPainter extends CustomPainter {
  final BorderRadius? borderRadius;
  final double borderWidth;
  final Gradient gradient;
  final BoxShape shape;

  _GlassBorderPainter({
    this.borderRadius,
    required this.borderWidth,
    required this.gradient,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0) return;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = gradient.createShader(rect);

    if (shape == BoxShape.circle) {
      canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    } else if (borderRadius != null) {
      final rrect = borderRadius!.toRRect(rect);
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlassBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.gradient != gradient ||
        oldDelegate.shape != shape;
  }
}
