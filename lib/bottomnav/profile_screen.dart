import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/settings/admin_screen_adding_new_title.dart';
import 'package:mobilr_app_ui/settings/settings_screen.dart';

// --- Color scheme for consistency ---
const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color cardBackgroundColor = Color(0xFF141414);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color chipBackgroundColor = Color(0xFF1E1E1E);
const Color dividerColor = Color(0xFF191919);

// --- Mock Models for Profile Data ---
class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String avatarUrl;
  final Map<String, List<String>> interests;
  final Map<String, List<String>> myLists; // Category -> List of Image URLs

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
    required this.interests,
    required this.myLists,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final HomeController homeController = Get.find<HomeController>();

  // Mock data initialized here
  final UserProfile _userProfile = UserProfile(
    firstName: "Rohit",
    lastName: "Parvathala",
    email: "example@gmail.com",
    avatarUrl: "https://placehold.co/72x72/FFFFFF/000000?text=R",
    interests: {
      'Movies': ['Action', 'Thriller', 'Telugu', 'Prabhas', 'NTR', 'RDJ'],
      'Books': ['Fiction', 'Self Help', 'Fantasy'],
      'Cuisines': ['Chinese', 'South India', 'South American'],
    },
    myLists: {
      'Movies': [
        "https://placehold.co/120x120/E05473/000000?text=RRR",
        "", // This will now show a fallback card
      ],
      'Books': [
        "https://placehold.co/120x120/54E0A1/000000?text=Ikigai"
      ],
      'Games': [
        "https://placehold.co/120x120/8B54E0/000000?text=GTA+VI"
      ],
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            homeController.selectedBottomNavIndex.value = 0;
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: primaryTextColor,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
            fontSize: 14,
              height: 0.72
          ),
        ),
        backgroundColor: darkBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            _buildProfileHeaderCard(),
            const SizedBox(height: 20),
            _buildAccountInfoCard(),
            const SizedBox(height: 20),
            _buildMyListsCard(),
            const SizedBox(height: 20),
            _buildAddNewTitleCard(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Builds the top card with the user's avatar, name, and email.
  Widget _buildProfileHeaderCard() {
    String interestsSummary = _userProfile.interests.keys.join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: _userProfile.avatarUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(_userProfile.avatarUrl),
                fit: BoxFit.cover,
              )
                  : null,
              color: Colors.white, // Fallback color
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_userProfile.firstName} ${_userProfile.lastName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                      height: 0.72
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _userProfile.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w400,
                      height: 0.72
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  interestsSummary,
                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 10,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w400,
                      height: 0.72
                  ),
                ),
              ],
            ),
          ),
          // Settings Icon
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.settings, size: 24, color: secondaryTextColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the card showing First Name, Last Name, Email, and Interests.
  Widget _buildAccountInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('First Name', _userProfile.firstName, hasDivider: true),
          _buildInfoRow('Last Name', _userProfile.lastName, hasDivider: true),
          _buildInfoRow('Email', _userProfile.email),
          // Divider is part of the interests section now
          _buildInterestsSection(),
        ],
      ),
    );
  }

  /// Helper for a single row in the account info card.
  Widget _buildInfoRow(String label, String value, {bool hasDivider = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: hasDivider
            ? const Border(bottom: BorderSide(color: dividerColor, width: 1))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
                height: 0.72
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w400,
                height: 0.72
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the 'Interest' section with categories and chips.
  Widget _buildInterestsSection() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: dividerColor, width: 1)),
      ),
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interest',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
                height: 0.72
            ),
          ),
          const SizedBox(height: 16),
          // Spacing between each category block
          ..._userProfile.interests.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key, // e.g., "Movies"
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w400,
                        height: 0.72
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.value
                        .map((interest) => _buildFilterChip(interest))
                        .toList(),
                  )
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Builds the "My Lists" card with a grid of images.
  Widget _buildMyListsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Lists',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
                height: 0.72
            ),
          ),
          const SizedBox(height: 16),
          ..._userProfile.myLists.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key, // Category name
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w400,
                        height: 0.72
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...entry.value.map((itemUrl) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: chipBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            image: (itemUrl.isNotEmpty)
                                ? DecorationImage(
                              image: NetworkImage(itemUrl),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: (itemUrl.isEmpty)
                              ? const Center(
                            child: Icon(Icons.add_photo_alternate_outlined,
                                color: secondaryTextColor),
                          )
                              : null,
                        );
                      }).toList(),
                      // "Add" button for each list
                      GestureDetector(
                        onTap: () {
                          print("Add new item to '${entry.key}' list");
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: chipBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(Icons.add,
                                color: secondaryTextColor, size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Builds a single chip for the interests section.
  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13.12, vertical: 8),
      decoration: BoxDecoration(
        color: chipBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: secondaryTextColor,
          fontSize: 12,
          fontFamily: 'Product Sans',
          fontWeight: FontWeight.w700,
            height: 0.72
        ),
      ),
    );
  }

  /// Builds the card to add a new title/category.
  Widget _buildAddNewTitleCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add new Title',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
                height: 0.72
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreenAddingNewTitle()),
              );
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: chipBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.add, color: secondaryTextColor, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to add a new category to 'My Lists'.
  void _showAddTypeDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: chipBackgroundColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Add New Type',
              style: TextStyle(color: Colors.white,height: 0.72)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter title type...',
              hintStyle: TextStyle(color: secondaryTextColor,height: 0.72),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: secondaryTextColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
              const Text('Cancel', style: TextStyle(color: Colors.white,height: 0.72)),
            ),
            TextButton(
              onPressed: () {
                final newType = controller.text.trim();
                if (newType.isNotEmpty &&
                    !_userProfile.myLists.containsKey(newType)) {
                  setState(() {
                    _userProfile.myLists[newType] = [];
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add', style: TextStyle(color: Colors.white,height: 0.72)),
            ),
          ],
        );
      },
    );
  }
}
