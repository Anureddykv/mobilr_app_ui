import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';

// ✅ Color constants from Figma
const Color snackbarBackgroundColor = Color(0xFF141414);
const Color snackbarErrorColor = Color(0xFFD86868);
const Color snackbarSuccessColor = Color(0xFF9DD870);
const Color snackbarWarningColor = Color(0xFFE5AB5A);
const Color snackbarInfoColor = Color(0xFF626365);

class OnboardingController extends GetxController {
  final RxList<String> selectedMainInterests = <String>[].obs;
  final RxList<String> collectedSubInterests = <String>[].obs;
  final RxString activeSubInterestScreen = ''.obs;

  void toggleMainInterest(String interest) {
    if (selectedMainInterests.contains(interest)) {
      selectedMainInterests.remove(interest);
    } else {
      selectedMainInterests.add(interest);
    }
  }

  void startSubInterestFlow() {
    if (selectedMainInterests.isNotEmpty) {
      activeSubInterestScreen.value = selectedMainInterests.first;
    }
  }

  void toggleSubInterest(String subInterest) {
    if (collectedSubInterests.contains(subInterest)) {
      collectedSubInterests.remove(subInterest);
    } else {
      collectedSubInterests.add(subInterest);
    }
  }

  void toggleSelectAll(List<String> sectionItems, bool shouldSelect) {
    if (shouldSelect) {
      for (var item in sectionItems) {
        if (!collectedSubInterests.contains(item)) {
          collectedSubInterests.add(item);
        }
      }
    } else {
      collectedSubInterests.removeWhere((item) => sectionItems.contains(item));
    }
  }

  void goBackToPreviousSubInterest() {
    final currentIndex = selectedMainInterests.indexOf(activeSubInterestScreen.value);
    if (currentIndex > 0) {
      final previousInterest = selectedMainInterests[currentIndex - 1];
      activeSubInterestScreen.value = previousInterest;
    } else {
      goBackToMainInterests();
    }
  }

  void navigateToNextInterestOrFinish() {
    final currentIndex = selectedMainInterests.indexOf(activeSubInterestScreen.value);
    if (currentIndex < selectedMainInterests.length - 1) {
      final nextInterest = selectedMainInterests[currentIndex + 1];
      activeSubInterestScreen.value = nextInterest;
    } else {
      submitInterests();
    }
  }

  Future<void> submitInterests() async {
    debugPrint('Onboarding Complete!');
    Get.offAll(() => HomeScreen());
  }

  void goBackToMainInterests() {
    activeSubInterestScreen.value = '';
    Get.back();
  }

  final Map<String, Map<String, dynamic>> _subInterestData = {
    'Movies': {
      'title': 'Lights, Camera, Action!',
      'description': 'We know everyone has their favorite genres, actors, and directors. Let us know what excites you in the world of movies!',
      'color': const Color(0xFF54B6E0),
      'sections': {
        'Cast': ['Steven Spielberg', 'Prabhas', 'Balakrishna', 'SS Rajamouli', 'James Cameron', 'Amitabh Bachan', 'Sujith', 'SRK', 'Alia Bhatt', 'Samantha'],
        'Cinematic Universe': ['D.C Comics', 'Marvel', 'LCU', 'PVCU', 'Monsterverse', 'SCU', 'Conjuring', 'Star Wars'],
        'Genre': ['Horror Thriller', 'Rom-Com', 'Action', 'Horror', 'Thriller', 'Comedy', 'Mythology', 'Romance'],
        'Production House': ['Horror Thriller', 'Rom-Com', 'Action', 'Horror', 'Thriller', 'Comedy', 'Mythology', 'Romance'],
      }
    },
    'Restaurants': {
      'title': 'Foodie Mode: On!',
      'description': 'From spicy to savory, pick your culinary interests. Whether it\'s cuisine, chains, or vegan-friendly options—we\'ll help you find the perfect dish for your taste!',
      'color': const Color(0xFFF9C74F),
      'sections': {
        'Cuisine': ['Indian', 'Chinese', 'Mediterranean', 'Mexican', 'Thai', 'Japanese', 'French', 'Greek', 'Spanish', 'Italian'],
        'Restaurant Chains': ['Pista House', 'Bawarchi', 'Mehfil', 'KFC', 'Dominos', 'Udupi', 'Pizza Hut', 'Scuzi'],
        'Dishes': ['Biryani', 'Curd Rice', 'Dal Tadka', 'Pizza', 'French Fries', 'Burger', 'Paratha', 'Sambar', 'Sushi', 'Shawarma'],
        'Specialty': ['Protein', 'Gluten-free', 'Vegan', 'Vegetarian', 'Egg', 'Non-Vegetarian', 'Junk'],
      }
    },
    'Gadgets': {
      'title': 'Tech Enthusiast? We Got You.',
      'description': 'Tech is always evolving. Let us know what gadgets you\'re into, and we\'ll keep you updated on all the coolest devices!',
      'color': const Color(0xFFE45659),
      'sections': {
        'Brand': ['Nokia', 'Blackberry', 'Lenovo', 'Samsung', 'One Plus', 'Karbon', 'Apple', 'Dell', 'Dyson'],
        'Model': ['Galaxy Z Flip', 'Vacuum Cleaner', 'Iphone', 'Air Filter'],
        'Usage': ['Photography', 'Gaming', 'Regular Use', 'Work', 'Designing', 'Coding', 'Production', 'Creative'],
        'OS': ['Oxygen OS', 'Windows', 'IOS', 'MacOS', 'Linux'],
      }
    },
    'Books': {
      'title': 'Books, Books, Books!',
      'description': 'From mystery to fantasy, let us know what you love to read. We\'ll help you find new books and authors that match your taste!',
      'color': const Color(0xFFCDBBE9),
      'sections': {
        'Author': ['J.K. Rowling', 'George R.R. Martin', 'Stephen King', 'Agatha Christie', 'Dan Brown', 'John Green', 'Rick Riordan'],
        'Series': ['The Lord of the Rings', 'The Chronicles of Narnia', 'Sherlock Holmes', 'Dune', 'Harry Potter', 'Percy Jackson', 'Star Wars'],
        'Publisher': ['Penguin Random House', 'HarperCollins', 'Scholastic', 'Tor Books', 'Vintage Books', 'Oxford University Press'],
        'Genre': ['Fantasy', 'Mystery & Thriller', 'Romance', 'Science Fiction', 'Historical Fiction', 'Self-Help', 'Horror'],
      }
    },
    'Games': {
      'title': 'Game On!',
      'description': 'Whether you\'re into role-playing, action, or strategy, we can match you with the games you\'ll love. Tell us about your gaming interests!',
      'color': const Color(0xFF90BE6D),
      'sections': {
        'Series': ['Assassin’s Creed', 'Call of Duty', 'Minecraft', 'Apex Legends', 'Battlefield', 'Grand Theft Auto (GTA)', 'Red Dead Redemption', 'Resident Evil', 'God of War', 'Counter-Strike'],
        'Publisher': ['Ubisoft', 'Electronic Arts (EA)', 'Rockstar Games', 'Activision Blizzard', 'Nintendo', 'Epic Games', 'Riot Games'],
        'Type': ['Action', 'Massively Multiplayer Online (MMO)', 'Survival', 'Adventure', 'Role-Playing Game (RPG)', 'Indie Games', 'First-Person Shooter (FPS)', 'Sandbox / Open World'],
      }
    },
  };

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
  final IconData? icon;
  final Color themeColor;

  const CustomSnackbarWidget({
    required this.message,
    this.title,
    required this.backgroundColor,
    this.icon,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              color: themeColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 20,
                height: 20,
                decoration: ShapeDecoration(
                  color: themeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Icon(icon, color: backgroundColor, size: 14),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: themeColor,
                  fontSize: 14,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
