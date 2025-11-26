import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';

// ✅ ADDED: Color constants for the custom snackbar
const Color snackbarBackgroundColor = Color(0xFF141414);
const Color snackbarWarningColor = Color(0xFFD86868);

class OnboardingController extends GetxController {
  // ✅ 1. Use a list for multiple main interest selections.
  final RxList<String> selectedMainInterests = <String>[].obs;

  // ✅ 2. This will hold all chosen sub-interests from all categories.
  final RxList<String> collectedSubInterests = <String>[].obs;

  // ✅ 3. This tracks which main interest's sub-screen we are currently showing.
  final RxString activeSubInterestScreen = ''.obs;

  // --- METHODS FOR THE MAIN INTEREST SCREEN ---

  /// Toggles the selection of a main interest on the first screen.
  void toggleMainInterest(String interest) {
    if (selectedMainInterests.contains(interest)) {
      selectedMainInterests.remove(interest);
    } else {
      selectedMainInterests.add(interest);
    }
  }

  /// Starts the sub-interest selection flow based on user's choices.
  void startSubInterestFlow() {
    if (selectedMainInterests.isNotEmpty) {
      // Set the first selected interest as the active screen.
      activeSubInterestScreen.value = selectedMainInterests.first;
    } else {
      Get.showSnackbar(GetSnackBar(
        messageText: const CustomSnackbarWidget(
          message: 'Removed from your list.',
          backgroundColor: snackbarBackgroundColor,
          icon: Icons.remove,
          iconColor: snackbarWarningColor,
          textColor: snackbarWarningColor,
        ),
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ));
    }
  }

  // --- METHODS FOR THE SUB-INTEREST SCREENS ---

  /// Toggles the selection of a sub-interest (e.g., 'Action', 'Marvel').
  void toggleSubInterest(String subInterest) {
    if (collectedSubInterests.contains(subInterest)) {
      collectedSubInterests.remove(subInterest);
    } else {
      collectedSubInterests.add(subInterest);
    }
  }

  /// Toggles the selection of all items within a specific section.
  void toggleSelectAll(List<String> sectionItems, bool shouldSelect) {
    if (shouldSelect) {
      // Add all items from the section that aren't already selected
      for (var item in sectionItems) {
        if (!collectedSubInterests.contains(item)) {
          collectedSubInterests.add(item);
        }
      }
    } else {
      // Remove all items from the section
      collectedSubInterests.removeWhere((item) => sectionItems.contains(item));
    }
  }

  /// Navigates to the PREVIOUS sub-interest screen in the sequence.
  void goBackToPreviousSubInterest() {
    final currentIndex =
    selectedMainInterests.indexOf(activeSubInterestScreen.value);
    if (currentIndex > 0) {
      final previousInterest = selectedMainInterests[currentIndex - 1];
      // Update the active screen to the previous one
      activeSubInterestScreen.value = previousInterest;
    } else {
      // If we are on the first item, going back should return to the main selection screen.
      goBackToMainInterests();
    }
  }

  /// Navigates to the next sub-interest screen in the sequence or finishes.
  void navigateToNextInterestOrFinish() {
    // Find the index of the *current* screen in the user's selected list
    final currentIndex =
    selectedMainInterests.indexOf(activeSubInterestScreen.value);

    // Check if there is a next interest in their selected sequence
    if (currentIndex < selectedMainInterests.length - 1) {
      // Get the name of the next interest
      final nextInterest = selectedMainInterests[currentIndex + 1];
      // Update the active screen. The UI will react and show the next screen.
      activeSubInterestScreen.value = nextInterest;
    } else {
      // If we are at the end of their selected list, finish the onboarding process.
      submitInterests();
    }
  }

  /// Submits all collected data and navigates to the home screen.
  Future<void> submitInterests() async {
    debugPrint('Onboarding Complete!');
    debugPrint('Selected Main Interests: ${selectedMainInterests.join(', ')}');
    debugPrint(
        'All collected sub-interests: ${collectedSubInterests.join(', ')}');

    // Here, you would typically save the data to SharedPreferences, a database, or send it to your backend.
    Get.offAll(() => HomeScreen());
  }

  /// Navigates back to the main interest selection screen.
  void goBackToMainInterests() {
    activeSubInterestScreen.value = '';
    // This will cause the Obx in OnboardingSubInterestsRouter to see an empty value
    // and Get.back() will pop it off the stack, returning to the main screen.
    Get.back();
  }

  final Map<String, Map<String, dynamic>> _subInterestData = {
    'Movies': {
      'title': 'Lights, Camera, Action!',
      'description':
      'We know everyone has their favorite genres, actors, and directors. Let us know what excites you in the world of movies!',
      'color': const Color(0xFF54B6E0),
      'sections': {
        'Cast': [
          'Steven Spielberg',
          'Prabhas',
          'Balakrishna',
          'SS Rajamouli',
          'James Cameron',
          'Amitabh Bachan',
          'Sujith',
          'SRK',
          'Alia Bhatt',
          'Samantha'
        ],
        'Cinematic Universe': [
          'D.C Comics',
          'Marvel',
          'LCU',
          'PVCU',
          'Monsterverse',
          'SCU',
          'Conjuring',
          'Star Wars'
        ],
        'Genre': [
          'Horror Thriller',
          'Rom-Com',
          'Action',
          'Horror',
          'Thriller',
          'Comedy',
          'Mythology',
          'Romance'
        ],
        // This section seems to be a duplicate of 'Genre' in your design, so I'm using a placeholder name.
        // You can rename 'Production House' to whatever is appropriate.
        'Production House': [
          'Horror Thriller',
          'Rom-Com',
          'Action',
          'Horror',
          'Thriller',
          'Comedy',
          'Mythology',
          'Romance'
        ],
      }
    },
    'Restaurants': {
      'title': 'Foodie Mode: On!',
      'description':
      'From spicy to savory, pick your culinary interests. Whether it\'s cuisine, chains, or vegan-friendly options—we\'ll help you find the perfect dish for your taste!',
      'color': const Color(0xFFF9C74F),
      'sections': {
        'Cuisine': [
          'Indian',
          'Chinese',
          'Mediterranean',
          'Mexican',
          'Thai',
          'Japanese',
          'French',
          'Greek',
          'Spanish',
          'Italian'
        ],
        'Restaurant Chains': [
          'Pista House',
          'Bawarchi',
          'Mehfil',
          'KFC',
          'Dominos',
          'Udupi',
          'Pizza Hut',
          'Scuzi'
        ],
        'Dishes': [
          'Biryani',
          'Curd Rice',
          'Dal Tadka',
          'Pizza',
          'French Fries',
          'Burger',
          'Paratha',
          'Sambar',
          'Sushi',
          'Shawarma'
        ],
        'Specialty': [
          'Protein',
          'Gluten-free',
          'Vegan',
          'Vegetarian',
          'Egg',
          'Non-Vegetarian',
          'Junk'
        ],
      }
    },
    'Gadgets': {
      'title': 'Tech Enthusiast? We Got You.',
      'description':
      'Tech is always evolving. Let us know what gadgets you\'re into, and we\'ll keep you updated on all the coolest devices!',
      'color': const Color(0xFFE45659),
      'sections': {
        'Brand': [
          'Nokia',
          'Blackberry',
          'Lenovo',
          'Samsung',
          'One Plus',
          'Karbon',
          'Apple',
          'Dell',
          'Dyson'
        ],
        'Model': ['Galaxy Z Flip', 'Vacuum Cleaner', 'Iphone', 'Air Filter'],
        'Usage': [
          'Photography',
          'Gaming',
          'Regular Use',
          'Work',
          'Designing',
          'Coding',
          'Production',
          'Creative'
        ],
        'OS': ['Oxygen OS', 'Windows', 'IOS', 'MacOS', 'Linux'],
      }
    },
    'Books': {
      'title': 'Books, Books, Books!',
      'description':
      'From mystery to fantasy, let us know what you love to read. We\'ll help you find new books and authors that match your taste!',
      'color': const Color(0xFFCDBBE9),
      'sections': {
        'Author': [
          'J.K. Rowling',
          'George R.R. Martin',
          'Stephen King',
          'Agatha Christie',
          'Dan Brown',
          'John Green',
          'Rick Riordan'
        ],
        'Series': [
          'The Lord of the Rings',
          'The Chronicles of Narnia',
          'Sherlock Holmes',
          'Dune',
          'Harry Potter',
          'Percy Jackson',
          'Star Wars'
        ],
        'Publisher': [
          'Penguin Random House',
          'HarperCollins',
          'Scholastic',
          'Tor Books',
          'Vintage Books',
          'Oxford University Press'
        ],
        'Genre': [
          'Fantasy',
          'Mystery & Thriller',
          'Romance',
          'Science Fiction',
          'Historical Fiction',
          'Self-Help',
          'Horror'
        ],
      }
    },
    'Games': {
      'title': 'Game On!',
      'description':
      'Whether you\'re into role-playing, action, or strategy, we can match you with the games you\'ll love. Tell us about your gaming interests!',
      'color': const Color(0xFF90BE6D),
      'sections': {
        'Series': [
          'Assassin’s Creed',
          'Call of Duty',
          'Minecraft',
          'Apex Legends',
          'Battlefield',
          'Grand Theft Auto (GTA)',
          'Red Dead Redemption',
          'Resident Evil',
          'God of War',
          'Counter-Strike'
        ],
        'Publisher': [
          'Ubisoft',
          'Electronic Arts (EA)',
          'Rockstar Games',
          'Activision Blizzard',
          'Nintendo',
          'Epic Games',
          'Riot Games'
        ],
        'Type': [
          'Action',
          'Massively Multiplayer Online (MMO)',
          'Survival',
          'Adventure',
          'Role-Playing Game (RPG)',
          'Indie Games',
          'First-Person Shooter (FPS)',
          'Sandbox / Open World'
        ],
      }
    },
  };

  /// Gets the data for a specific sub-interest screen.
  Map<String, dynamic> getSubInterestData(String interest) {
    return _subInterestData[interest] ??
        {
          'title': 'Select Your Preferences',
          'description': 'Tell us more about what you like.',
          'color': Colors.grey,
          'sections': {},
        };
  }
}

class CustomSnackbarWidget extends StatelessWidget {
  final String message;
  final String? title;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  const CustomSnackbarWidget({
    required this.message,
    this.title,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: textColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: ShapeDecoration(
              color: iconColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: Icon(icon, color: backgroundColor, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
