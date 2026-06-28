import 'package:flutter/material.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/l10n/app_localizations.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key, required this.strings});

  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 10.paddingH,
      child: Text.rich(
        TextSpan(
          style: TextStyles.s10.w500.generalSans
              .lhPercent(150)
              .cl(ColorPalette.white300),
          children: [
            TextSpan(text: strings.termsAcknowledgement),
            TextSpan(
              text: strings.termsConditions,
              style: TextStyles.s10.w500.generalSans
                  .lhPercent(150)
                  .underline
                  .cl(ColorPalette.white300),
              recognizer: null, // Add TapGestureRecognizer for interactivity
            ),
            TextSpan(
              text: strings.andWord,
              style: TextStyles.s10.w500.generalSans
                  .lhPercent(150)
                  .cl(ColorPalette.white300),
            ),
            TextSpan(
              text: strings.privacyPolicy,
              style: TextStyles.s10.w500.generalSans
                  .lhPercent(150)
                  .underline
                  .cl(ColorPalette.white300),
              recognizer: null, // Add TapGestureRecognizer for interactivity
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
