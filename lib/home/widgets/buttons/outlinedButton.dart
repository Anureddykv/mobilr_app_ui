import 'package:flutter/material.dart';

Widget outlinedButton(
    String text,
    Color color, {
      double fontSize = 8,
      Widget? image,
      bool imageOnRight = false,
      bool centerText = true,
      VoidCallback? onTap,
    }) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: color),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!imageOnRight && image != null) ...[
            image,
            const SizedBox(width: 6),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.40,
            ),
          ),
          if (imageOnRight && image != null) ...[
            const SizedBox(width: 6),
            image,
          ],
        ],
      ),
    ),
  );
}