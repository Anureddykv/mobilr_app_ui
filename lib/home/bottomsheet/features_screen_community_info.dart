import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/settings/privacy_policy_screen.dart' hide dividerColor;
import 'package:mobilr_app_ui/utils/snackbar_utils.dart';

import '../../bottomnav/notification_screen.dart' hide dividerColor, primaryTextColor, darkBackgroundColor;
import '../../settings/settings_screen.dart' hide darkBackgroundColor, primaryTextColor;

// Re-using colors and styles from your chat screen for consistency
const Color communityScreenBackgroundColor = Color(0xFF0B0B0B);
const Color communityAppBarColor = Color(0xFF1E1E1E);
const Color communityPrimaryTextColor = Color(0xFFE6EAED);
const Color communitySecondaryTextColor = Color(0xFF626365);
const Color cardBackgroundColor = Color(0xFF141414);
const Color cardBorderColor = Color(0xFF191919);
const Color dangerColor = Color(0xFFD86868);
const Color accentColor = Color(0xFF9DD870);

const TextStyle headingStyle = TextStyle(
  color: Colors.white,
  fontSize: 10,
  fontFamily: 'General Sans Variable',
  fontWeight: FontWeight.w600,
  letterSpacing: 0.50,
);

const TextStyle bodyStyle = TextStyle(
  color: communityPrimaryTextColor,
  fontSize: 14,
  fontFamily: 'General Sans Variable',
  fontWeight: FontWeight.w400,
);

class FeaturesScreenCommunityInfo extends StatefulWidget {
  final String communityName;
  final String communityImageUrl;
  final int memberCount;

  const FeaturesScreenCommunityInfo({
    super.key,
    required this.communityName,
    required this.communityImageUrl,
    required this.memberCount,
  });

  @override
  State<FeaturesScreenCommunityInfo> createState() =>
      _FeaturesScreenCommunityInfoState();
}

class _FeaturesScreenCommunityInfoState
    extends State<FeaturesScreenCommunityInfo> {
  // State for the notification toggles
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _inAppNotifications = true;
  bool _doNotDisturb = false;
  bool _showNotificationPreferences = false;
  bool _dnd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: communityScreenBackgroundColor,
      appBar: AppBar(
        backgroundColor: communityAppBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.maybePop(context); // This safely tries to go back, but won't crash if it can't
          },
        ),
        title: const Text(
          "Community Info",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildInfoCard(
            title: "DESCRIPTION",
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                'In Salaar, a fierce warrior rises against a tyrannical regime to protect his friend and reclaim justice through violence.',
                style: bodyStyle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildNotificationsCard(),
          const SizedBox(height: 20),
          _buildLegalPoliciesCard(),
          const SizedBox(height: 20),
          _buildActionsCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // This widget is now structured as you requested.
    return SizedBox(
      height: 180,
      child: Stack(
          children: [
      // Background Image with Error Handling
      Positioned.fill(
      child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        widget.communityImageUrl, // Correctly reference the variable
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[850],
            child: const Icon(
              Icons.photo_size_select_actual_outlined,
              color: Colors.white24,
              size: 48,
            ),
          );
        },
      ),
    ),
    ),
    Positioned.fill(
    child: DecoratedBox(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
    colors: [
    Colors.black.withOpacity(0.6),
    Colors.transparent,
    Colors.black.withOpacity(0.8),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: const [0.0, 0.5, 1.0],
    ),
    ),
    ),
    ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.communityName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.memberCount} Members',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'General Sans Variable',
                    ),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }


  Widget _buildInfoCard(
      {required String title, required Widget child}) {
    return Card(
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: cardBorderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Text(title, style: headingStyle),
          ),
          const Divider(color: cardBorderColor, height: 1),
          child,
        ],
      ),
    );
  }

  // --- NOTIFICATIONS CARD ---
  Widget _buildNotificationsCard() {
    return _buildSettingsCard(
      title: 'NOTIFICATIONS',
      children: [
        _buildSwitchRow(
          'Push Notification',
          _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
          leading: Image.asset("assets/images/inapp.png", color: primaryTextColor, width: 14, height: 14),
        ),
        _buildSwitchRow(
          'Email Notification',
          _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
          leading: Image.asset("assets/images/email.png", color: primaryTextColor, width: 14, height: 14),
        ),
        _buildSwitchRow(
          'In-App Notification',
          _inAppNotifications,
              (value) => setState(() => _inAppNotifications = value),
          leading: Image.asset("assets/images/inapp.png", color: primaryTextColor, width: 14, height: 14),
        ),
        // Notification Preferences header
        InkWell(
          onTap: () => setState(() => _showNotificationPreferences = !_showNotificationPreferences),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: _showNotificationPreferences ? dividerColor : Colors.transparent, width: 1)),
            ),
            child: Row(
              children: [
                Image.asset("assets/images/inapp.png", color: primaryTextColor, width: 14, height: 14),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Notification Preferences',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 14,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  _showNotificationPreferences ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: primaryTextColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        // Expanded dropdown with animation
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: const NotificationPreferencesList(),
          crossFadeState: _showNotificationPreferences ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        _buildSwitchRow(
          'Do not Disturb',
          _doNotDisturb,
              (value) => setState(() => _doNotDisturb = value),
          leading: const SizedBox(width: 14),
          hasDivider: false,
        ),
      ],
    );
  }

  // --- LEGAL & POLICIES CARD ---
  Widget _buildLegalPoliciesCard() {
    return _buildSettingsCard(
      title: 'LEGAL & POLICIES',
      children: [
        _buildInfoRow(
          'Privacy Policy',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
          leading: Image.asset("assets/images/lock.png", color: primaryTextColor, width: 14, height: 14),
        ),
        _buildInfoRow(
          'Terms & Condition',
          onTap: () => print("Terms tapped"),
          leading: Image.asset("assets/images/terms.png", color: primaryTextColor, width: 14, height: 14),
        ),
        _buildInfoRow(
          'Cookies Policy',
          onTap: () => print("Cookies tapped"),
          leading: Image.asset("assets/images/cookies.png", color: primaryTextColor, width: 14, height: 14),
        ),
        _buildInfoRow(
          'Content Ownership & Licensing Info',
          onTap: () => print("Licensing tapped"),
          leading: Image.asset("assets/images/licenseinfo.png", color: primaryTextColor, width: 14, height: 14),
        ),
        _buildInfoRow(
          'Community Guidelines',
          onTap: () => print("Community Guidelines tapped"),
          leading: Image.asset("assets/images/community.png", color: primaryTextColor, width: 14, height: 14),
          hasDivider: false,
        ),
      ],
    );
  }
  // --- GENERIC CARD BUILDERS ---
  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
    bool showInfoIcon = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: cardBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: dividerColor),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontSize: 10,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.50,
                  ),
                ),
                if (showInfoIcon)
                  const Icon(
                    Icons.info_outline,
                    color: primaryTextColor,
                    size: 16,
                  ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
  Widget _buildSwitchRow(
      String label,
      bool value,
      ValueChanged<bool> onChanged, {
        Widget? leading,
        bool hasDivider = true,
      }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: hasDivider
              ? const Border(bottom: BorderSide(color: dividerColor, width: 1))
              : null,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading, const SizedBox(width: 8)],
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: primaryTextColor,
                  fontSize: 14,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _CustomSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label, {
        VoidCallback? onTap,
        Widget? leading,
        bool hasDivider = true,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          border: hasDivider
              ? const Border(bottom: BorderSide(color: dividerColor, width: 1))
              : null,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading, const SizedBox(width: 8)],
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: primaryTextColor,
                  fontSize: 14,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // Only show arrow if it's tappable
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                color: primaryTextColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return _buildInfoCard(
      title: 'ACTIONS',
      child: Column(
        children: [
          _buildActionTile('Clear Chat'),
          _buildActionTile('Exit Community'),
          _buildActionTile('Report Community'),
          _buildActionTile('Report Member', isLast: true),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: cardBorderColor, width: 1),
        ),
      ),
      child: SwitchListTile(
        title: Text(title, style: bodyStyle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: accentColor,
        inactiveThumbColor: communitySecondaryTextColor,
        inactiveTrackColor: Colors.black,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      ),
    );
  }

  Widget _buildNavigationTile(String title, {bool isLast = false}) {
    return ListTile(
      title: Text(title, style: bodyStyle),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: () {
        SnackBarUtils.showTopSnackBar(context, 'Tapped on $title');
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      shape: Border(
        bottom: isLast ? BorderSide.none : const BorderSide(color: cardBorderColor),
      ),
    );
  }

  Widget _buildActionTile(String title, {bool isLast = false}) {
    return ListTile(
      title: Text(title, style: bodyStyle.copyWith(color: dangerColor)),
      onTap: () {
        Get.defaultDialog(
          title: "Confirm Action",
          middleText: "Are you sure you want to '$title'?",
          backgroundColor: cardBackgroundColor,
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: communityPrimaryTextColor),
          radius: 10,

          // --- Cancel Action ---
          textCancel: "No",
          cancelTextColor: Colors.white,
          onCancel: () {
          },

          // --- Confirm Action ---
          textConfirm: "Yes",
          confirmTextColor: Colors.white,
          buttonColor: dangerColor,
          onConfirm: () {
            // 1. Close the dialog FIRST using Get.back()
            Get.back();

            // 2. Perform the specific action
            switch (title) {
              case 'Clear Chat':
                SnackBarUtils.showTopSnackBar(context, "Chat history cleared");
                break;

              case 'Exit Community':
                Get.back();
                SnackBarUtils.showTopSnackBar(context, "You have successfully left community.");
                break;

              case 'Report Community':
                SnackBarUtils.showTopSnackBar(context, "You have successfully reported community.");
                break;

              case 'Report Member':
                SnackBarUtils.showTopSnackBar(context, "You have successfully reported member.");
                break;
            }
          },
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      shape: Border(
        bottom: isLast ? BorderSide.none : const BorderSide(color: cardBorderColor),
      ),
    );
  }
}

class _CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Dimensions from Figma
    const double width = 63;
    const double height = 28;
    const double handleSize = 21;
    const double padding = 3.5;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: value ? switchActiveColor : darkBackgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: value ? Colors.transparent : cardBackgroundColor,
                width: 1.5
            )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ON Text
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 11 : -30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: value ? 1.0 : 0.0,
                child: const Text(
                  'ON',
                  style: TextStyle(
                    color: switchActiveHandle,
                    fontSize: 10,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // OFF Text
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              right: value ? -30 : 8,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: value ? 0.0 : 1.0,
                child:  const Text(
                  'OFF',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 10,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Handle
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding),
                child: Container(
                  width: handleSize,
                  height: handleSize,
                  decoration: BoxDecoration(
                    color: value ? switchActiveHandle : switchInactiveHandle,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
