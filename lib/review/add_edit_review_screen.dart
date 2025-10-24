import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
import 'package:mobilr_app_ui/splash/SplashMessageScreen.dart';

// --- Theme Colors ---
const Color screenBackgroundColor = Color(0xFF0B0B0B);
const Color cardBgColor = Color(0xFF141414);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Color(0xFF626365);
const Color textFieldBgColor = Color(0xFF0B0B0B);

class AddEditReviewScreen extends StatefulWidget {
  final String itemName;
  final String itemType;
  final Color accentColor;
  final String ratingAssetPath;
  final double initialRating;

  const AddEditReviewScreen({
    super.key,
    required this.itemName,
    this.itemType = "Item",
    this.initialRating = 0.0,
    this.accentColor = const Color(0xFF54B6E0),
    this.ratingAssetPath = "assets/images/sd.png",
  });

  @override
  State<AddEditReviewScreen> createState() => _AddEditReviewScreenState();
}

class _AddEditReviewScreenState extends State<AddEditReviewScreen> {
  late double _currentRating;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  // --- NEW: State to control button visibility ---
  bool _showSubmitButton = false;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
    // --- NEW: Add a listener to the review controller ---
    _reviewController.addListener(() {
      // Show the button if the review field is not empty
      final bool isReviewNotEmpty = _reviewController.text.isNotEmpty;
      if (isReviewNotEmpty != _showSubmitButton) {
        setState(() {
          _showSubmitButton = isReviewNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_currentRating == 0) {
      Get.snackbar(
        "Incomplete Review",
        "Please provide a rating before submitting.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    print('Submitting Review For: ${widget.itemName}');
    print('Rating: $_currentRating');
    print('Title: ${_titleController.text}');
    print('Review: ${_reviewController.text}');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SplashMessageScreen(
          title: "Review Added\nSuccessfully",
          circleColor: const Color(0xFF9DD870),
          backgroundColor: screenBackgroundColor,
          headerImageUrl: "https://placehold.co/375x48",
          icon: const Icon(Icons.check, size: 48, color: Colors.white),
          nextPage: const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Review for ${widget.itemName}',
          style: const TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Rating Header ---
              Text(
                'Rate this ${widget.itemType}',
                style: const TextStyle(
                  color: primaryTextColor,
                  fontSize: 14,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tell us what you think about this ${widget.itemType}',
                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 10,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    bool isSelected = index < _currentRating;
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      visualDensity: VisualDensity.compact,
                      icon: Image.asset(
                        widget.ratingAssetPath,
                        width: 42,
                        height: 42,
                        color: isSelected ? widget.accentColor : Color(0xFFCCCCCC),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentRating = index + 1.0;
                        });
                      },
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(color: Color(0xFF191919)),
              const SizedBox(height: 24),

              // --- Text Input Fields ---
              _buildTextField(
                controller: _titleController,
                hintText: 'Title your review (optional)',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _reviewController,
                hintText: 'Describe your view...',
                maxLines: 5,
              ),
              const SizedBox(height: 32),

              // --- NEW: Conditional Submit Button ---
              // AnimatedOpacity provides a smooth fade-in/fade-out effect
              AnimatedOpacity(
                opacity: _showSubmitButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _showSubmitButton
                    ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.accentColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitReview,
                    child: const Text(
                      "Submit Review",
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(), // Takes no space when hidden
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: primaryTextColor, fontSize: 14),
      maxLines: maxLines,
      minLines: maxLines > 1 ? maxLines : 1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: secondaryTextColor, fontSize: 14),
        filled: true,
        fillColor: textFieldBgColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800, width: 1), // Subtle border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.accentColor, width: 1.5),
        ),
      ),
    );
  }
}
