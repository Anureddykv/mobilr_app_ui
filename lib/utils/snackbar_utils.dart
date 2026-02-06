import 'package:flutter/material.dart';
import '../onbording/onboarding_controller.dart';

class SnackBarUtils {
  static void showTopSnackBar(BuildContext context, String message, {bool isError = false}) {
    final OverlayState overlayState = Overlay.of(context);
    
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _TopSnackBarWidget(
        message: message,
        isError: isError,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlayState.insert(overlayEntry);

    // Auto-dismiss after 2 seconds as requested in design
    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _TopSnackBarWidget extends StatefulWidget {
  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  const _TopSnackBarWidget({
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The margin is 24 to match the Screen's horizontal padding (Buttons length)
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 24,
            right: 24,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 40, // Height from Figma
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF141414),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: widget.isError ? snackbarErrorColor : snackbarSuccessColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon container from Figma
                      Container(
                        width: 20,
                        height: 20,
                        decoration: ShapeDecoration(
                          color: widget.isError ? snackbarErrorColor : snackbarSuccessColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Icon(
                          widget.isError ? Icons.error_outline : Icons.check_circle_outline,
                          color: const Color(0xFF141414),
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: widget.isError ? snackbarErrorColor : snackbarSuccessColor,
                            fontSize: 14,
                            fontFamily: 'General Sans Variable',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
