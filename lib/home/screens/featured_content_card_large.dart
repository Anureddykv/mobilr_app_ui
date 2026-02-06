import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/filledButton.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/outlinedButton.dart';

const Color cardBackgroundColor = Color(0xFF141414);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;

class FeaturedContentCardLarge extends StatefulWidget {
  final String itemId;
  final String imageUrl;
  final String title;
  final List<String> infoItems;
  final String rating;
  final String votes;
  final Widget ratingIcon;
  final Color accentColor;
  final VoidCallback? onMoreInfo;
  final VoidCallback? onViewAllReviews;

  const FeaturedContentCardLarge({
    super.key,
    required this.itemId,
    required this.imageUrl,
    required this.title,
    required this.infoItems,
    required this.rating,
    required this.votes,
    required this.ratingIcon,
    required this.accentColor,
    this.onMoreInfo,
    this.onViewAllReviews,
  });

  @override
  State<FeaturedContentCardLarge> createState() => _FeaturedContentCardLargeState();
}

class _FeaturedContentCardLargeState extends State<FeaturedContentCardLarge> {
  final HomeController controller = Get.find<HomeController>();

  Widget _dot() => Container(
    width: 3,
    height: 3,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: const BoxDecoration(
      color: secondaryTextColor,
      shape: BoxShape.circle,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Calculate image height based on a standard aspect ratio from Figma
    final screenWidth = MediaQuery.of(context).size.width;
    // Card width is screen width minus horizontal margins (e.g., 12 on each side)
    final cardWidth = screenWidth - 24;
    final imageHeight = cardWidth * (170 / 355); // Aspect ratio from Figma

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      width: cardWidth,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: cardBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Stack(
        children: [
          // Background Image
          SizedBox(
            width: double.infinity,
            height: imageHeight,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image,
                    color: Colors.white24, size: 60),
              ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              height: imageHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x26141414), cardBackgroundColor],
                  stops: [0.0, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side: Title and Info
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Text(
                                widget.title.toUpperCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 20,
                                  fontFamily: 'General Sans Variable',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.80,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Info Items (Runtime, Rating, Language)
                            Row(
                              children: widget.infoItems
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int idx = entry.key;
                                String text = entry.value;
                                return Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (idx != 0) _dot(),
                                      Flexible(
                                        child: Text(
                                          text,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: secondaryTextColor,
                                            fontSize: 10,
                                            fontFamily:
                                            'General Sans Variable',
                                            fontWeight: FontWeight.w600,
                                            height: 0.72,
                                            letterSpacing: 0.50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      // Right side: Rating and Votes
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.rating,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 20,
                                  fontFamily: 'General Sans Variable',
                                  fontWeight: FontWeight.w600,
                                  height: 0.72,
                                ),
                              ),
                              const SizedBox(width: 9),
                              widget.ratingIcon,
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (widget.votes.isNotEmpty)
                            Text(
                              widget.votes,
                              style: const TextStyle(
                                color: secondaryTextColor,
                                fontSize: 8,
                                fontFamily: 'General Sans Variable',
                                fontWeight: FontWeight.w600,
                                height: 0.72,
                                letterSpacing: 0.40,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Bottom Row: Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Buttons: More Info, View All Reviews
                      Flexible(
                        child: Row(
                          children: [
                            if (widget.onMoreInfo != null)
                              outlinedButton(
                                "More Info",
                                widget.accentColor,
                                image: Image.asset("assets/images/Union.png", width: 14, height: 14, color: widget.accentColor),
                                onTap: widget.onMoreInfo,
                                // Increased font size as per request
                                fontSize: 10,
                              ),
                            if (widget.onMoreInfo != null &&
                                widget.onViewAllReviews != null)
                              const SizedBox(width: 12),
                            if (widget.onViewAllReviews != null)
                              filledButton(
                                "View All Reviews",
                                background: widget.accentColor,
                                onTap: widget.onViewAllReviews,
                                // Increased font size as per request
                                fontSize: 10,
                              ),
                          ],
                        ),
                      ),
                      // Right Button: Add/Saved
                      Obx(() {
                        final isSaved = controller.isItemSaved(widget.itemId);
                        if (isSaved) {
                          return filledButton(
                            "Saved",
                            background: widget.accentColor,
                            fontSize: 10, // Increased font size
                            image: Image.asset("assets/images/add_select.png",
                                width: 12, height: 12, color: Colors.white),
                            onTap: () {
                              controller.toggleItemSaved(widget.itemId,
                                  itemName: widget.title);
                            },
                          );
                        } else {
                          return outlinedButton(
                            "Add",
                            widget.accentColor,
                            fontSize: 10, // Increased font size
                            image: Image.asset("assets/images/add.png",
                                width: 12, height: 12, color: widget.accentColor),
                            imageOnRight: true,
                            onTap: () {
                              controller.toggleItemSaved(widget.itemId,
                                  itemName: widget.title);
                            },
                          );
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
