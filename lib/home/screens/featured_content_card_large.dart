import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/filledButton.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/outlinedButton.dart';

const Color cardBackgroundColor = Color(0xFF141414);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;

// 1. Convert the StatelessWidget to a StatefulWidget
class FeaturedContentCardLarge extends StatefulWidget {
  final String itemId; // Use a generic ID
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
    required this.itemId, // Make ID a required parameter
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
  // 2. Get an instance of your HomeController to access the generic methods
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
    // Calculate image height based on a standard aspect ratio
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.92;
    final imageHeight = cardWidth * (200 / 355);

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
              widget.imageUrl, // Use widget.property in StatefulWidget
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white24, size: 60),
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
          // Content
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title, Info, and Rating Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side: Title and Info
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title.toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 18,
                                fontFamily: 'General Sans Variable',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.64,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Info Items
                            Row(
                              children: widget.infoItems.asMap().entries.map((entry) {
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
                                            fontFamily: 'General Sans Variable',
                                            fontWeight: FontWeight.w600,
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
                        mainAxisSize: MainAxisSize.min,
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
                                ),
                              ),
                              const SizedBox(width: 4),
                              widget.ratingIcon,
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (widget.votes.isNotEmpty)
                            Text(
                              widget.votes,
                              style: const TextStyle(
                                color: secondaryTextColor,
                                fontSize: 8,
                                fontFamily: 'General Sans Variable',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.40,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Buttons Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Buttons
                      Flexible(
                        child: Row(
                          children: [
                            if (widget.onMoreInfo != null)
                              outlinedButton(
                                "More Info",
                                widget.accentColor,
                                image: Image.asset("assets/images/Union.png", width: 14, height: 14, color: widget.accentColor),
                                onTap: widget.onMoreInfo,
                                fontSize: 10,
                              ),
                            if (widget.onMoreInfo != null && widget.onViewAllReviews != null)
                              const SizedBox(width: 12),
                            if (widget.onViewAllReviews != null)
                              filledButton(
                                "View All Reviews",
                                background: widget.accentColor,
                                onTap: widget.onViewAllReviews,
                                fontSize: 10,
                              ),
                          ],
                        ),
                      ),
 Obx(() {
                        // Check the saved state using the controller and the item's unique ID
                        final isSaved = controller.isItemSaved(widget.itemId);

                        if (isSaved) {
                          // If saved, show the "Saved" button
                          return filledButton(
                            "Saved",
                            background: widget.accentColor,
                            fontSize: 10,
                            image: Image.asset("assets/images/add_select.png", width: 14, height: 14, color: Colors.white),
                            onTap: () {
                              controller.toggleItemSaved(widget.itemId, itemName: widget.title);
                            },
                          );
                        } else {
                          // Otherwise, show the default "Add" button
                          return outlinedButton(
                            "Add",
                            widget.accentColor,
                            fontSize: 10,
                            image: Image.asset("assets/images/add.png", width: 14, height: 14, color: widget.accentColor),
                            imageOnRight: true,
                            onTap: () {
                              // On tap, call the same controller toggle method
                              controller.toggleItemSaved(widget.itemId, itemName: widget.title);
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
