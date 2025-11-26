import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/outlinedButton.dart';

const Color cardBackgroundColor = Color(0xFF141414);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Color(0xFF626365);

class FeaturedContentCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? rating;
  final VoidCallback? onTap;
  final String ratingIconAsset;
  final Color? activeRatingIconColor; // Renamed for clarity
  final Color? inactiveRatingIconColor; // <-- NEW

  const FeaturedContentCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.rating,
    this.onTap,
    this.ratingIconAsset = "assets/images/sd.png",
    this.activeRatingIconColor, // Renamed
    this.inactiveRatingIconColor, // <-- NEW
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final double ratingValue = double.tryParse(rating ?? "0") ?? 0;

    return Container(
      width: 152,
      decoration: ShapeDecoration(
        color: cardBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 152 / 174,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[850],
                  child: const Icon(Icons.photo_size_select_actual_outlined,
                      color: Colors.white24, size: 40),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: primaryTextColor,
                          fontSize: 16,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Audience Rating:',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 10,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w600,
                          height: 0.72
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildRatingDisplay(
                        controller,
                        ratingValue: ratingValue,
                        iconAsset: ratingIconAsset,
                        activeColor: activeRatingIconColor, // Pass the active color
                        inactiveColor: inactiveRatingIconColor, // Pass the inactive color
                      ),
                    ],
                  ),
                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      child: outlinedButton(
                        "Explore",
                        controller.currentAccentColor.value,
                        fontSize: 12,
                        centerText: true,
                        onTap: onTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the rating display with full, partially, and empty icons.
  Widget _buildRatingDisplay(
      HomeController controller, {
        required double ratingValue,
        required String iconAsset,
        Color? activeColor,
        Color? inactiveColor, // <-- NEW
      }) {
    // Fallback logic for both colors
    final Color finalActiveColor = activeColor ?? controller.currentAccentColor.value;
    final Color finalInactiveColor = inactiveColor ?? Colors.grey[700]!;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (ratingValue > 0) ...[
            Text(
              ratingValue.toStringAsFixed(1),
              style: const TextStyle(
                color: primaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Row(
            children: List.generate(5, (index) {
              Widget starWidget;
              int fullStars = ratingValue.floor();
              double decimalPart = ratingValue - fullStars;

              if (index < fullStars) {
                // 1. Full Star
                starWidget = Image.asset(
                  iconAsset,
                  width: 14,
                  height: 14,
                  color: finalActiveColor,
                );
              } else if (index == fullStars && decimalPart > 0) {
                // 2. Partially Filled Star
                starWidget = Stack(
                  children: [
                    Image.asset(
                      iconAsset,
                      width: 14,
                      height: 14,
                      color: finalInactiveColor,
                    ),
                    ClipRect(
                      clipper: _FractionalClipper(clipFactor: decimalPart),
                      child: Image.asset(
                        iconAsset,
                        width: 14,
                        height: 14,
                        color: finalActiveColor,
                      ),
                    ),
                  ],
                );
              } else {
                // 3. Empty Star
                starWidget = Image.asset(
                  iconAsset,
                  width: 14,
                  height: 14,
                  color: finalInactiveColor,
                );
              }

              return Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: starWidget,
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// A custom clipper to clip a widget to a fraction of its width.
class _FractionalClipper extends CustomClipper<Rect> {
  final double clipFactor;

  _FractionalClipper({required this.clipFactor});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * clipFactor, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return oldClipper is _FractionalClipper && oldClipper.clipFactor != clipFactor;
  }
}

