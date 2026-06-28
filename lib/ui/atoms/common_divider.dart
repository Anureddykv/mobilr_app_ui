import 'package:flutter/material.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';

/// A reusable divider component that optionally supports centered text labels
/// conforming to the Atomic Design system.
class CommonDivider extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextStyle? textStyle;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  const CommonDivider({
    super.key,
    this.text,
    this.color,
    this.textStyle,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? ColorPalette.grey400;

    if (text == null) {
      return Divider(
        color: dividerColor,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      );
    }

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness,
            indent: indent,
            endIndent: endIndent,
          ),
        ),
        Padding(
          padding: 12.paddingH,
          child: Text(
            text!,
            style:
                textStyle ??
                const TextStyle(
                  color: Color(0xFFCBCBCB),
                  fontSize: 12,
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.72,
                ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness,
            indent: indent,
            endIndent: endIndent,
          ),
        ),
      ],
    );
  }
}
