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

// --- Color Constants ---
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color sectionHeaderColor = Color(0xFF3F3F3F);
const Color sheetBackgroundColor = Color(0xFF141414);

class MoreInfoBottomSheet extends StatefulWidget {
  final String itemId;
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

  const MoreInfoBottomSheet({
    super.key,
    required this.itemId,
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
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: const BoxDecoration(
        color: sheetBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section 1: Header (Title, Info, Rating)
            _buildHeader(),
            const SizedBox(height: 31),

            /// Section 2: Buttons
            _buildActionButtons(),
            const SizedBox(height: 47),

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
                height: 1.5, // Giving it a bit more line height for readability
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            /// Section 4: Cast & Crew
            if (widget.cast.isNotEmpty) ...[
              _buildSectionHeader('Cast & Crew'),
              const SizedBox(height: 12),
              // Use a SingleChildScrollView for the horizontal list
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.cast
                      .map((actor) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _actorCard(
                      name: actor.name,
                      role: actor.role,
                      img: actor.imageUrl,
                    ),
                  ))
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader() {
    return Row(
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
                widget.title.toUpperCase(),
                style: const TextStyle(
                  color: primaryTextColor,
                  fontSize: 20,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.80,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: widget.infoItems
                    .expand((item) => [
                  if (item.isNotEmpty) _infoText(item),
                  if (item != widget.infoItems.last && item.isNotEmpty) _dot(),
                ])
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
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
                const SizedBox(width: 6),
                Image.asset(
                  widget.ratingIconAsset,
                  height: 16,
                  width: 16,
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
                height: 0.72
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // The primary button is now just one of the buttons
        filledButton(
          widget.primaryButtonText,
          background: widget.accentColor,
          fontSize: 10,
          onTap: widget.onPrimaryButtonTap,
        ),
        // Obx widget for the dynamic "Add"/"Saved" button
        Obx(() {
          final isSaved = controller.isItemSaved(widget.itemId);
          if (isSaved) {
            return filledButton(
              "Saved",
              background: widget.accentColor,
              fontSize: 10,
              image: Image.asset("assets/images/add_select.png", width: 12, height: 12, color: Colors.white),
              onTap: () {
                controller.toggleItemSaved(widget.itemId, itemName: widget.title);
              },
            );
          } else {
            return outlinedButton(
              "Add",
              widget.accentColor,
              fontSize: 10,
              image: Image.asset("assets/images/add.png", width: 12, height: 12, color: widget.accentColor),
              imageOnRight: true,
              onTap: () {
                controller.toggleItemSaved(widget.itemId, itemName: widget.title);
              },
            );
          }
        }),
      ],
    );
  }

  Widget _infoText(String text) => Text(
    text,
    style: const TextStyle(
        color: secondaryTextColor, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.50),
  );

  Widget _dot() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: 3,
    height: 3,
    decoration: const BoxDecoration(color: secondaryTextColor, shape: BoxShape.circle),
  );

  Widget _buildSectionHeader(String title) => Text(
    title,
    style: const TextStyle(color: sectionHeaderColor, fontSize: 12, fontWeight: FontWeight.w600,height: 0.72),
  );

  Widget _actorCard({required String name, required String role, required String img}) {
    return SizedBox(
      width: 78,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              img,
              height: 78,
              width: 78,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _placeholderBox(),
            ),
          ),
          const SizedBox(height: 10),
          // Use Text.rich for two-line text with different styles
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$name\n',
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: role,
                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 10,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _placeholderBox() => Container(
    height: 78,
    width: 78,
    decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(20)),
    alignment: Alignment.center,
    child: const Icon(Icons.person, color: Colors.white38, size: 32),
  );
}
