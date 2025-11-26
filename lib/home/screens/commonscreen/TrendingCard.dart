import 'package:flutter/material.dart';
import 'package:get/get.dart';import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/filledButton.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/outlinedButton.dart';

// Define constants for colors and text styles for consistency, based on Figma.
const Color cardBackgroundColor = Color(0xFF141414);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Color(0xFF626365);
const Color subtitleTextColor = Color(0xFF333333);
const Color ratingPillColor = Color(0xFF1F1F1F);

class TrendingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String details; // e.g., "2h 35m, U/A, Telugu"
  final String starnestRating;
  final String audienceRating;
  final String? audienceVotes;
  final VoidCallback? onWriteReview;
  final VoidCallback? onExplore;
  final Widget? ratingImage;
  final Widget? exploreButtonImage;
  final Color? exploreButtonImageColor;

  const TrendingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.details,
    required this.starnestRating,
    required this.audienceRating,
    this.audienceVotes,
    this.onWriteReview,
    this.onExplore,
    this.ratingImage,
    this.exploreButtonImage,
    this.exploreButtonImageColor,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Container(
      decoration: ShapeDecoration(
        color: cardBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      // ✅ ADDED: IntrinsicHeight allows the Row's children to size correctly.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left part: Image with gradient
            AspectRatio(
              aspectRatio: 121 / 184, // Maintain the image's aspect ratio
              child: _buildCardImage(imageUrl),
            ),
            // Right part: Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top section: Title, Details, Ratings
                    Text(
                      title.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 20,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                        height: 0.72
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildDetailsRow(details),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildRatingPill(
                            label: 'Starnest Rating',
                            rating: starnestRating,
                            icon: ratingImage,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRatingPill(
                            label: 'Audience Rating',
                            rating: audienceRating,
                            votes: audienceVotes,
                            icon: ratingImage,
                          ),
                        ),
                      ],
                    ),
                    // ✅ ADDED: Spacer pushes the buttons to the bottom
                    const Spacer(),
                    // Buttons at the bottom
                    Obx(
                          () => Row(
                        children: [
                          // ✅ CORRECTED: Use Expanded to allow buttons to fill space
                          Expanded(
                            child: outlinedButton(
                              "Write a Review",
                              controller.currentAccentColor.value,
                              image: Image.asset(
                                "assets/images/pen.png",
                                color: controller.currentAccentColor.value,
                                width: 14,
                                height: 14,
                              ),
                              fontSize: 8,
                              onTap: onWriteReview,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: filledButton(
                              "Explore Ratings",
                              background: controller.currentAccentColor.value,
                              image: exploreButtonImage,
                              fontSize: 8,
                              onTap: onExplore,
                            ),
                          ),
                        ],
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

  // Helper for the card image with a proper gradient
  Widget _buildCardImage(String imageUrl) {
    return Container(
      decoration: ShapeDecoration(
        image: imageUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
        color: imageUrl.isEmpty ? Colors.grey[850] : Colors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
      // Gradient Overlay to fade the image into the background
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, cardBackgroundColor],
            stops: const [0.3, 1.0],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
    );
  }

  // Helper to build the details row with separator dots
  Widget _buildDetailsRow(String detailsString) {
    final items = detailsString.split(',').map((e) => e.trim()).toList();
    List<Widget> widgets = [];
    for (int i = 0; i < items.length; i++) {
      widgets.add(Text(
        items[i],
        style: const TextStyle(
          color: secondaryTextColor,
          fontSize: 10,
          fontFamily: 'General Sans Variable',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.50,
        ),
      ));
      if (i < items.length - 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              width: 3,
              height: 3,
              decoration: const ShapeDecoration(
                color: secondaryTextColor,
                shape: OvalBorder(),
              ),
            ),
          ),
        );
      }
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
    );
  }

  // Helper to build a rating pill
  Widget _buildRatingPill({
    required String label,
    required String rating,
    String? votes,
    Widget? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label :',
          style: const TextStyle(
            color: subtitleTextColor,
            fontSize: 10,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ratingPillColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rating,
                    style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 4),
                    icon,
                  ],
                ],
              ),
            ),
            if (votes != null && votes.isNotEmpty) ...[
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  votes,
                  style: const TextStyle(
                    color: subtitleTextColor,
                    fontSize: 8,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
