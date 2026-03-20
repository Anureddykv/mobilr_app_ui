import 'dart:async';
import 'package:flutter/material.dart';

class SplashMessageScreen extends StatefulWidget {
  final String title;
  final Color circleColor;
  final Color backgroundColor;
  final String? headerImageUrl;
  final Widget? icon;
  final Widget? nextPage;
  final Duration delay;

  const SplashMessageScreen({
    super.key,
    required this.title,
    this.circleColor = const Color(0xFF9DD870),
    this.backgroundColor = const Color(0xFF0B0B0B),
    this.headerImageUrl,
    this.icon,
    this.nextPage,
    this.delay = const Duration(seconds: 2),
  });

  @override
  State<SplashMessageScreen> createState() => _SplashMessageScreenState();
}

class _SplashMessageScreenState extends State<SplashMessageScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.nextPage != null) {
      Future.delayed(widget.delay, () {
        if (mounted && widget.nextPage != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => widget.nextPage!),
          );
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 108,
              height: 108,
              decoration: ShapeDecoration(
                color: widget.circleColor,
                shape: const OvalBorder(),
              ),
              child: Center(
                child: widget.icon ??
                    const Icon(Icons.check, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE6EAED),
                fontSize: 28,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w600,
                height: 1,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
