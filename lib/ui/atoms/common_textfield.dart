import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/color_palette.dart';
import '../../core/constants/app_dimen.dart';
import '../../core/extensions/text_style_ext.dart';

/// Standard text field component for StarNest screens.
///
/// Usage:
/// ```dart
/// CommonTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   controller: emailController,
///   keyboardType: TextInputType.emailAddress,
/// )
/// CommonTextField.password(
///   label: 'Password',
///   controller: passwordController,
/// )
/// ```
class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.inputFormatters,
    this.autofocus = false,
    this.focusNode,
    this.enabled = true,
    this.height,
    this.fillColor,
  });

  /// Named constructor for password fields (auto-shows eye toggle)
  const CommonTextField.password({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.readOnly = false,
    this.prefixIcon,
    this.errorText,
    this.inputFormatters,
    this.autofocus = false,
    this.focusNode,
    this.enabled = true,
    this.height,
    this.fillColor,
  }) : isPassword = true,
       keyboardType = TextInputType.visiblePassword,
       maxLines = 1,
       minLines = null,
       maxLength = null,
       suffixIcon = null;

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool enabled;
  final double? height;
  final Color? fillColor;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: TextStyles.s14.w500),
          const SizedBox(height: 8),
        ],
        SizedBox(
          height: widget.height ?? AppDimen.inputHeight,
          child: TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.isPassword && _obscure,
            readOnly: widget.readOnly,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            inputFormatters: widget.inputFormatters,
            cursorColor: ColorPalette.grey400,
            style: TextStyles.s14.w400.generalSans.copyWith(
              color: ColorPalette.white300,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyles.s12.w600.generalSans
                  .copyWith(color: ColorPalette.grey400)
                  .lhPercent(100),
              filled: true,
              fillColor: widget.fillColor ?? ColorPalette.grey700,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorPalette.grey400,
                        size: 20,
                      ),
                    )
                  : widget.suffixIcon,
              errorText: widget.errorText,
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorPalette.grey400,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorPalette.grey400,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorPalette.grey400,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorPalette.error,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ColorPalette.error,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              errorStyle: TextStyles.s12.w400.generalSans
                  .copyWith(color: ColorPalette.error)
                  .lhPercent(100),
            ),
          ),
        ),
      ],
    );
  }
}
