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
  final VoidCallback onNotifyToggle; // Action for both states of the button
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
    // --- Card layout updated to match Figma design ---
    return Container(
      width: 200,
      height: 300,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        // The borderRadius from Figma is 26
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      child: Stack(
        children: [
          // Background Image
          _buildBackgroundImage(imageUrl),
          // Gradient Overlay
          _buildGradientOverlay(),
          // Main content column (Title, Details, Release Date)
          Positioned(
            left: 14,
            right: 14,
            top: 145, // Positioned from the top as per Figma
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleAndDetails(),
                const SizedBox(height: 12),
                _buildReleaseInfo(),
              ],
            ),
          ),
          // Buttons positioned at the bottom
          Positioned(
            left: 14,
            right: 14,
            bottom: 14, // Positioned from the bottom as per Figma
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isNotified
                  ? _buildNotifiedStateButtons()
                  : _buildInitialStateButton(),
            ),
          ),
        ],
      ),
    );
  }


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
            child: const Icon(Icons.broken_image,
                color: Colors.white24, size: 50),
          ),
        )
            : Container(
          color: const Color(0xFF141414),
          child:
          const Icon(Icons.movie, color: Colors.white24, size: 50),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.0),
          gradient: LinearGradient(
            // Figma gradient starts higher up
            begin: const Alignment(0.5, 0.0),
            end: const Alignment(0.5, 1.0),
            colors: [
              const Color(0x00141414),
              const Color(0xFF141414),
            ],
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
        // Title Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w500, // Figma uses 550 weight
                  height: 1.0, // Tight line height for multi-line titles
                ),
              ),
            ),
            if (infoIcon != null) ...[const SizedBox(width: 4), ?infoIcon],
          ],
        ),
        const SizedBox(height: 6),
        // Details Text
        Text(
          details,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w400, // Figma uses 450 weight
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
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4), // Adjusted for better visual balance
        Text(
          releaseDate,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildInitialStateButton() {
    // This now uses the filledButton widget with the correct styling.
    return SizedBox(
      width: double.infinity,
      child: filledButton(
        notifyButtonText ?? "Notify Me",
        image: notifyIcon,
        background: accentColor,
        fontSize: 14,
        onTap: onNotifyToggle,
      ),
    );
  }

  Widget _buildNotifiedStateButtons() {
    // This Row now contains the "Explore" and the icon-only notified button.
    return Row(
      children: [
        Expanded(

          child: outlinedButton(
              "Explore",
              accentColor,
              fontSize: 12,
              centerText: true,
              onTap: onExplore,
            )
        ),
        const SizedBox(width: 10), // Spacing from Figma
        // The notified icon button
        GestureDetector(
          onTap: onNotifyToggle,
          child: Container(
            height: 42, // Match the height of the outlinedButton
            width: 48,
            decoration: ShapeDecoration(
              color: accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Center(
                child: notifiedIcon ??
                    const Icon(Icons.check, color: Colors.white, size: 24)),
          ),
        ),
      ],
    );
  }
}
