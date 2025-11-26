import 'package:flutter/material.dart';

import '../../../bottomnav/profile_screen.dart';

Widget filledButton(
    String text, {
      required Color background,
      double fontSize = 8,
      VoidCallback? onTap,
      Widget? image,
      bool imageOnRight = false,
    }) => GestureDetector(
  onTap: onTap,
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    decoration: ShapeDecoration(
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        if (!imageOnRight && image != null) ...[
          image,
          const SizedBox(width: 6),
        ],
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: primaryTextColor,
            fontSize: fontSize,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.40,
          ),
        ),
        if (imageOnRight && image != null) ...[
          const SizedBox(width: 6), // Spacing between text and image
          image,
        ],
      ],
    ),
  ),
);