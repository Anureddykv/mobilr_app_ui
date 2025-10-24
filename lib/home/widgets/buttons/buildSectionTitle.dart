import 'package:flutter/material.dart';

import '../../../bottomnav/profile_screen.dart';

Widget buildSectionTitle(
    String title, {
      Color textColor = secondaryTextColor,
      double topPadding = 20,
      double bottomPadding = 12,
    }) {
  return Padding(
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
      top: topPadding,
      bottom: bottomPadding,
    ),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontFamily: 'General Sans Variable',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.96,
      ),
    ),
  );
}