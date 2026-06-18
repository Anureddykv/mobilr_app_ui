import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';
import 'common_loading.dart';

/// Network image widget with built-in shimmer placeholder and error fallback.
///
/// Usage:
/// ```dart
/// CommonImageWidget(
///   imageUrl: 'https://...',
///   width: 80,
///   height: 80,
///   radius: 12,
/// )
/// CommonImageWidget.circle(imageUrl: '...', size: 48)
/// ```
class CommonImageWidget extends StatelessWidget {
  const CommonImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.radius = 0,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholder,
  });

  /// Named constructor for circular avatar images
  const CommonImageWidget.circle({
    super.key,
    required this.imageUrl,
    required double size,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholder,
  })  : width = size,
        height = size,
        radius = size / 2;

  final String imageUrl;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final Widget? errorWidget;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            ShimmerBox(
              width: width ?? 100,
              height: height ?? 100,
              radius: radius,
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: ColorPalette.cardBg,
              child: const Icon(
                Icons.broken_image_outlined,
                color: ColorPalette.textSecondary,
              ),
            ),
      ),
    );
  }
}

/// Asset image widget with consistent corner radius and fit.
class CommonAssetImage extends StatelessWidget {
  const CommonAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.radius = 0,
    this.fit = BoxFit.cover,
    this.color,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: ColorPalette.cardBg,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: ColorPalette.textSecondary,
          ),
        ),
      ),
    );
  }
}
