// C:/Users/anureddy.kv/mobilr_app_ui/lib/home/screens/commonscreen/survey_card.dart

import 'package:flutter/material.dart';

// It's better to move these model classes to their own file in `lib/models/`
class SurveyOption {
  final String id;
  final String text;

  SurveyOption({required this.id, required this.text});
}

class Survey {
  final String id;
  final String question;
  final List<SurveyOption> options;

  Survey({required this.id, required this.question, required this.options});
}

class SurveyCard extends StatefulWidget {
  final Survey survey;
  final Color accentColor;
  final Function(String selectedOptionId) onSubmit;
  // This builder function allows for a custom button, increasing reusability.
  final Widget Function(String text, {Color? background, VoidCallback? onTap}) filledButtonBuilder;

  const SurveyCard({
    super.key,
    required this.survey,
    required this.accentColor,
    required this.onSubmit,
    required this.filledButtonBuilder,
  });

  @override
  State<SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  String? _selectedOptionId;
  bool _hasSubmitted = false;

  void _submitSurvey() {
    // Disable the submit button if no option is selected.
    if (_selectedOptionId == null) return;

    setState(() {
      _hasSubmitted = true;
    });
    widget.onSubmit(_selectedOptionId!);
  }

  // A helper getter to find the text of the selected option.
  String get _selectedOptionText {
    if (_selectedOptionId == null) return "";
    return widget.survey.options.firstWhere((opt) => opt.id == _selectedOptionId).text;
  }

  @override
  Widget build(BuildContext context) {
    // Consistent color and text styling based on the reference.
    const Color cardBackgroundColor =  Color(0xFF141414); // Corrected background color
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Colors.white70;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: cardBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Question Section ---
          Text(
            widget.survey.question,
            style: const TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
              height: 1.2, // Improved line height for readability
            ),
          ),
          const SizedBox(height: 16),
          // --- Divider ---
          Container(
            width: double.infinity,
            height: 0.5,
            color: secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),

          // --- Conditional UI: Show options or submitted response ---
          if (_hasSubmitted)
          // --- Submitted State ---
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'General Sans Variable',
                    color: primaryTextColor,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'Your response: '),
                    TextSpan(
                      text: _selectedOptionText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
          // --- Options State ---
            Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.survey.options.map((option) {
                final bool isSelected = _selectedOptionId == option.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOptionId = option.id;
                    });
                  },
                  // Use Padding + Transparent color for better tap detection area
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          // --- Custom Radio Button ---
                          Container(
                            width: 18, // Corrected size
                            height: 18, // Corrected size
                            decoration: ShapeDecoration(
                              color: isSelected ? widget.accentColor : Colors.transparent,
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 1.5, // Corrected border width
                                  color: isSelected ? widget.accentColor : secondaryTextColor,
                                ),
                              ),
                            ),
                            // Inner circle for selected state
                            child: isSelected
                                ? Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          // --- Option Text ---
                          Expanded(
                            child: Text(
                              option.text,
                              style: const TextStyle(
                                color: primaryTextColor,
                                fontSize: 16,
                                fontFamily: 'General Sans Variable',
                                fontWeight: FontWeight.w500,
                                height: 1.2, // Corrected height
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 4),

          // --- Conditional UI: Show Submit button or Submitted text ---
          if (!_hasSubmitted)
          // --- Submit Button ---
            Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: _selectedOptionId == null ? 0.5 : 1.0, // Dims button when disabled
                child: widget.filledButtonBuilder(
                  "Submit",
                  background: widget.accentColor,
                  onTap: _submitSurvey,
                ),
              ),
            )
          else
          // --- "Response Submitted" Text ---
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0), // Matches button height
                child: Text(
                  "Response Submitted!",
                  style: TextStyle(
                    color: widget.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
