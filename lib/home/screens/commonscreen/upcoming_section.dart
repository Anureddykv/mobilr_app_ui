import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/filledButton.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/outlinedButton.dart';

class UpcomingContentCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String details;
  final String releaseDate;
  final bool isNotified;
  final VoidCallback onNotifyToggle;
  final VoidCallback? onExplore;
  final Color accentColor;
  final Widget? infoIcon;
  final Widget? notifyIcon;
  final Widget? notifiedIcon;
  final String? notifyButtonText;

  const UpcomingContentCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.details,
    required this.releaseDate,
    required this.isNotified,
    required this.onNotifyToggle,
    this.onExplore,
    required this.accentColor,
    this.infoIcon,
    this.notifyIcon,
    this.notifiedIcon,
    this.notifyButtonText,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ WRAPPED IN ASPECTRATIO FOR RESPONSIVENESS
    // This maintains the card's shape while allowing it to scale.
    return AspectRatio(
      aspectRatio: 200 / 300,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
        child: Stack(
          fit: StackFit.expand, // Ensure stack children fill the container
          children: [
            _buildBackgroundImage(imageUrl),
            _buildGradientOverlay(),
            // ✅ REBUILT CONTENT LAYOUT FOR ACCURACY & RESPONSIVENESS
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacer to push content to the bottom half
                  const Spacer(flex: 145), // Approximates the top: 145 position
                  _buildTitleAndDetails(),
                  const SizedBox(height: 12),
                  _buildReleaseInfo(),
                  const Spacer(flex: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isNotified
                        ? _buildNotifiedStateButtons()
                        : _buildInitialStateButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (Updated to match Figma styles) ---

  Widget _buildBackgroundImage(String url) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.0),
        child: url.isNotEmpty
            ? Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF141414),
            child: const Icon(Icons.image_not_supported_outlined,
                color: Colors.white24, size: 50),
          ),
        )
            : Container(
          color: const Color(0xFF141414),
          child: const Icon(Icons.movie_creation_outlined,
              color: Colors.white24, size: 50),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.0),
          gradient: const LinearGradient(
            // ✅ GRADIENT MATCHES FIGMA
            begin: Alignment(0.5, 0.0),
            end: Alignment(0.5, 1.0),
            colors: [Color(0x00141414), Color(0xFF141414)],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ CORRECTED: Use a Row to include the infoIcon
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title text should be flexible
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w500, // Figma uses w550
                  height: 1.0,
                ),
              ),
            ),
            // Conditionally add the icon if it's provided
            if (infoIcon != null) ...[
              const SizedBox(width: 6),
              infoIcon!,
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          details,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w400, // Figma uses w450
          ),
        ),
      ],
    );
  }

  Widget _buildReleaseInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Releasing on',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w500, // Figma uses w550
          ),
        ),
        const SizedBox(height: 8),
        Text(
          releaseDate,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w400, // Figma uses w450
          ),
        ),
      ],
    );
  }

  Widget _buildInitialStateButton() {
    // ✅ BUTTON STYLES MATCH FIGMA
    return SizedBox(
      width: double.infinity,
      child: filledButton(
        notifyButtonText ?? "Notify Me",
        image: notifyIcon,
        background: accentColor,
        fontSize: 14,
        onTap: onNotifyToggle,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }

  Widget _buildNotifiedStateButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 32, // Match height of the other button
            child: outlinedButton(
              "Explore",
              accentColor,
              fontSize: 12,
              centerText: true,
              onTap: onExplore,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onNotifyToggle,
          child: Container(
            height: 32, // Match height
            width: 38,
            decoration: ShapeDecoration(
              color: accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Center(
              child: notifiedIcon ??
                  const Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
