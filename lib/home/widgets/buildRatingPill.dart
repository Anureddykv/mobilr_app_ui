import 'package:flutter/material.dart';

import '../../bottomnav/notification_screen.dart';

Widget buildRatingPill(
    String label,
    String rating, {
      String? votes,
      double fontSize = 14,
      Widget? image,
      final Color? imageColor
    }) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Label
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 10,
          fontFamily: 'General Sans Variable',
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: ShapeDecoration(
              color: Color(0xFF1F1F1F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              children: [
                Text(
                  rating,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: fontSize,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (image != null) ...[const SizedBox(width: 4), image],
              ],
            ),
          ),
          if (votes != null) ...[
            const SizedBox(width: 5),
            Text(
              votes,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 8,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    ],
  );
}