import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/filledButton.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/outlinedButton.dart';

class ActorInfo {
  final String name;
  final String role;
  final String imageUrl;

  ActorInfo({required this.name, required this.role, required this.imageUrl});
}

const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color sectionHeaderColor = Color(0xFF3F3F3F);

// 1. Converted to StatefulWidget
class MoreInfoBottomSheet extends StatefulWidget {
  final String itemId; // Added for state tracking
  final String title;
  final String rating;
  final String votes;
  final List<String> infoItems;
  final String description;
  final List<ActorInfo> cast;
  final Color accentColor;
  final String ratingIconAsset;
  final String primaryButtonText;
  final VoidCallback? onPrimaryButtonTap;
  // Note: secondaryButton fields are no longer needed as Obx handles this logic.

  const MoreInfoBottomSheet({
    super.key,
    required this.itemId, // Made itemId required
    required this.title,
    required this.rating,
    required this.votes,
    required this.infoItems,
    required this.description,
    this.cast = const [],
    this.accentColor = Colors.teal,
    this.ratingIconAsset = "assets/images/sd.png",
    this.primaryButtonText = "View All Reviews",
    this.onPrimaryButtonTap,
  });

  @override
  State<MoreInfoBottomSheet> createState() => _MoreInfoBottomSheetState();
}

class _MoreInfoBottomSheetState extends State<MoreInfoBottomSheet> {
  // 2. Get an instance of HomeController
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // The main container is wrapped in a Column to manage spacing and button layout as per Figma.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // The Column should only be as tall as its children.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section 1: Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Title and info items
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 20,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w500,
                        height: 1.2, // Adjusted for better readability
                        letterSpacing: 0.80,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: widget.infoItems.expand((item) => [
                        if (item.isNotEmpty) _infoText(item),
                        if (item != widget.infoItems.last && item.isNotEmpty) _dot(),
                      ]).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16), // Spacing between title and rating
              // Right side: Rating and votes
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
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
                      Image.asset(
                        widget.ratingIconAsset,
                        height: 16,
                        color: widget.accentColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
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

          /// Section 2: Buttons (Corrected Layout)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // The primary button now takes up most of the space
              Flexible(
                child: filledButton(
                  widget.primaryButtonText,
                  background: widget.accentColor,
                  fontSize: 10,
                  onTap: widget.onPrimaryButtonTap,
                ),
              ),
              const SizedBox(width: 12),
              // 3. Replaced the static button with the Obx widget for dynamic state
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
          const SizedBox(height: 24),

          /// Section 3: Information
          _buildSectionHeader('Information'),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: const TextStyle(
              color: primaryTextColor,
              fontSize: 10,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),

          /// Section 4: Cast & Crew
          if (widget.cast.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Cast & Crew'),
            const SizedBox(height: 12),
            SizedBox(
              height: 120, // Height for the horizontal list
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.cast.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final actor = widget.cast[index];
                  return _actorCard(
                      name: actor.name, role: actor.role, img: actor.imageUrl);
                },
              ),
            ),
          ],
          const SizedBox(height: 16), // Added bottom padding
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _infoText(String text) => Text(
    text,
    style: const TextStyle(
        color: secondaryTextColor,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.50),
  );

  Widget _dot() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: 3,
    height: 3,
    decoration: const BoxDecoration(
        color: secondaryTextColor, shape: BoxShape.circle),
  );

  Widget _buildSectionHeader(String title) => Text(
    title,
    style: const TextStyle(
        color: sectionHeaderColor,
        fontSize: 12,
        fontWeight: FontWeight.w600),
  );

  Widget _actorCard({required String name, required String role, required String img}) {
    final bool isValidImage =
        img.isNotEmpty && (img.startsWith('http://') || img.startsWith('https://'));
    return SizedBox(
      width: 78,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: isValidImage
                ? Image.network(img,
                height: 78, // Corrected height for actor image
                width: 78,  // Corrected width for actor image
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _placeholderBox())
                : _placeholderBox(),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
                color: primaryTextColor,
                fontSize: 14,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            role,
            style: const TextStyle(
                color: secondaryTextColor,
                fontSize: 10,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _placeholderBox() => Container(
    height: 78,
    width: 78,
    decoration: BoxDecoration(
        color: Colors.grey[850], borderRadius: BorderRadius.circular(20)),
    alignment: Alignment.center,
    child: const Icon(Icons.person, color: Colors.white38, size: 32),
  );
}
