import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/filledButton.dart';

// Assuming these are defined in your profile_screen.dart or a constants file.
const Color cardBackgroundColor = Color(0xFF141414);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Color(0xFF626365);

class CommunityCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final VoidCallback? onJoin;
  final String buttonText;
  final Widget? buttonIcon;
  final Color accentColor;

  const CommunityCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.onJoin,
    this.buttonText = "Join Community",
    this.buttonIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: cardBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // The column takes up minimum vertical space.
        mainAxisAlignment: MainAxisAlignment.end, // Aligns children to the bottom.
        children: [
          // Top section with Icon, Name, and Description
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                // Subtle border from Figma to separate sections.
                side: BorderSide(width: 1, color: Color(0xFF191919)),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCommunityIcon(imageUrl),
                const SizedBox(width: 10),
                _buildNameAndDescription(),
              ],
            ),
          ),
          // Bottom section with the "Join Community" button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: SizedBox(
              width: double.infinity,
              child: filledButton(
                buttonText,
                image: buttonIcon,
                background: accentColor,
                fontSize: 14,
                onTap: onJoin,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityIcon(String url) {
    if (url.isEmpty) {
      // Return the placeholder immediately if the URL is empty
      return _buildPlaceholder();
    }
    return Container(
      width: 40,
      height: 40,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Use ClipRRect to ensure the image respects the border radius
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          // Show the same placeholder on error
          errorBuilder: (context, error, stackTrace) {
            debugPrint("Image Error: $error"); // Log the error
            return _buildPlaceholder();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 40,
      height: 40,
      decoration: ShapeDecoration(
        color: const Color(0xFFD9D9D9), // Grey placeholder color from Figma
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Icon(Icons.group, color: Colors.white24, size: 24),
    );
  }

  Widget _buildNameAndDescription() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
              height: 1.0, // Tight line height from Figma.
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: secondaryTextColor, // Using secondary color for better contrast.
              fontSize: 10,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w400,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
