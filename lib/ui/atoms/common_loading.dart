import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/color_palette.dart';

// ============================================================================
// CommonLoading — Full-screen loading indicator
// ============================================================================

/// Full-screen centered loading indicator.
class CommonLoading extends StatelessWidget {
  const CommonLoading({
    super.key,
    this.color,
    this.size = 32,
    this.backgroundColor,
  });

  final Color? color;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? ColorPalette.grey800,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(color!),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ShimmerBox — Rectangular shimmer placeholder
// ============================================================================

/// Rectangular shimmer loading placeholder.
///
/// Usage:
/// ```dart
/// ShimmerBox(width: double.infinity, height: 120, radius: 12)
/// ```
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.shimmerBase,
      highlightColor: ColorPalette.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ColorPalette.shimmerBase,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

// ============================================================================
// ShimmerCircle — Circular shimmer placeholder (avatars, icons)
// ============================================================================

class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.shimmerBase,
      highlightColor: ColorPalette.shimmerHighlight,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: ColorPalette.shimmerBase,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
