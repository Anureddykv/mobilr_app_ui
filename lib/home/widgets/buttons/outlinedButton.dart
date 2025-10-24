import 'package:flutter/material.dart';

Widget outlinedButton(
    String text,
    Color color, {
      double fontSize = 10,
      Widget? image,
      bool imageOnRight = false,
      bool centerText = false,
      VoidCallback? onTap,
    }) {
  return GestureDetector(onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: color),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: centerText && image == null
            ? MainAxisAlignment
            .center // Center Row content if only text and centerText is true
            : MainAxisAlignment.start,
        children: [
          if (!imageOnRight && image != null) ...[
            image,
            const SizedBox(width: 6),
          ],
          if (centerText &&
              image != null)
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.40,
                  ),
                ),
              ),
            )
          else
            Text(
              text,
              textAlign: centerText
                  ? TextAlign.center
                  : TextAlign.start,
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