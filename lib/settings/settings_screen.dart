import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/bottomnav/profile_screen.dart';
import 'package:mobilr_app_ui/settings/privacy_policy_screen.dart';

// --- COLOR CONSTANTS (From Figma) ---
const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color cardBackgroundColor = Color(0xFF141414);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color switchActiveColor = Color(0xFF9DD870);
const Color dividerColor = Color(0xFF191919);
const Color switchActiveHandle = Color(0xFF1E1E1E);
const Color switchInactiveHandle = Color(0xFF3F3F3F);
const Color profileAvatarColor = Color(0xFFCBCBCB);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables remain the same
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _inAppNotifications = true;
  bool _doNotDisturb = false;
  bool _showNotificationPreferences = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: cardBackgroundColor, // Changed to match Figma AppBar
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryTextColor,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 16, // Figma has a slightly different title style
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Padding adjusted to match Figma's layout
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
        child: Column(
          children: [
            _buildProfileHeader(onTap: () {
              Navigator.of(context).pop();
              print("Navigate to Profile Screen");
            }),
            const SizedBox(height: 20),
            _buildAppearanceCard(),
            const SizedBox(height: 20),
            _buildNotificationsCard(),
            const SizedBox(height: 20),
            _buildLegalPoliciesCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- PROFILE HEADER ---
  Widget _buildProfileHeader({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: dividerColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 28, // 56 / 2
              backgroundColor: profileAvatarColor,
              // backgroundImage: NetworkImage("URL_TO_IMAGE"), // Uncomment to use real image
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Name of the Account',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6), // Figma has 10px, but 6 looks better with this font
                  Text(
                    'example@gmail.com',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 14,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
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

  // --- APPEARANCE CARD ---
  Widget _buildAppearanceCard() {
    return _buildSettingsCard(
      title: 'APPEARANCE',
      showInfoIcon: true,
      children: [
        _buildInfoRow(
          'Theme',
          leading: SizedBox(
            width: 14,
            height: 14,
            child: Stack(
              children: [
                // White half
                Container(
                  decoration:  BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1), // CORRECTED LINE

                  ),
                ),
                // Black half
                ClipPath(
                  clipper: HalfCircleClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            // TODO: Implement theme switching logic
            print("Theme tapped");
          },
          hasDivider: false,
        ),
      ],
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
          leading: Image.asset("assets/images/lock.png", color: primaryTextColor, width: 14, height: 14),
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
                Image.asset("assets/images/licenseinfo.png", color: primaryTextColor, width: 14, height: 14),
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
          leading: Image.asset("assets/images/community.png", color: primaryTextColor, width: 14, height: 14),
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
          leading: Image.asset("assets/images/email.png", color: primaryTextColor, width: 14, height: 14),
        ),
        _buildInfoRow(
          'Cookies Policy',
          onTap: () => print("Cookies tapped"),
          leading: Image.asset("assets/images/inapp.png", color: primaryTextColor, width: 14, height: 14),
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
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: dividerColor),
                borderRadius: BorderRadius.only(
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
}

class NotificationPreferencesList extends StatefulWidget {
  const NotificationPreferencesList({super.key});

  @override
  State<NotificationPreferencesList> createState() =>
      _NotificationPreferencesListState();
}

class _NotificationPreferencesListState extends State<NotificationPreferencesList> {
  // State for sub-preferences
  bool likes = true;
  bool replies = false;
  bool followers = true;
  bool interests = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPreferenceRow(
          label: "Likes on my Reviews",
          value: likes,
          onChanged: (v) => setState(() => likes = v),
          iconPath: "assets/images/thum_up.png",
        ),
        _buildDivider(),
        _buildPreferenceRow(
          label: "Replies / Comments",
          value: replies,
          onChanged: (v) => setState(() => replies = v),
          iconPath: "assets/images/inapp.png",
        ),
        _buildDivider(),
        _buildPreferenceRow(
          label: "New Followers",
          value: followers,
          onChanged: (v) => setState(() => followers = v),
          iconPath: "assets/images/pepole.png",
        ),
        _buildDivider(),
        _buildPreferenceRow(
          label: "New content in my Interests",
          value: interests,
          onChanged: (v) => setState(() => interests = v),
          iconPath: "assets/images/email.png",
        ),
      ],
    );
  }

  Widget _buildPreferenceRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required String iconPath,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        width: double.infinity,
        // Indented padding to match Figma design
        padding: const EdgeInsets.fromLTRB(34, 14, 14, 14),
        child: Row(
          children: [
            Image.asset(iconPath, color: primaryTextColor, width: 14, height: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
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

  Widget _buildDivider() => const Divider(height: 1, color: dividerColor, indent: 14, endIndent: 14);
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
                color: value ? Colors.transparent : switchInactiveHandle,
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
                child: const Text(
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

// Helper clipper for the theme icon
class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.addArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -1.57, // Start angle (top)
      3.14,   // Sweep angle (180 degrees)
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
