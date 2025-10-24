import 'package:flutter/material.dart';

// --- Reusing your color palette ---
const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Color(0xFF626365);
const Color dividerColor = Color(0xFF191919);

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic list of sections (can come from JSON/API)
    final List<PolicySection> sections = [
      PolicySection(
        title: "1. Information We Collect",
        content: '''
a. Personal Information
We may collect personal information you provide directly, including:
  • Name
  • Email address
  • Username
  • Profile photo (if applicable)
  • Account login details

b. Content You Submit
When using the app, especially while adding reviews, you may provide:
  • Written reviews
  • Ratings
  • Photos or media
  • Tags, categories, or locations related to your reviews

c. Automatically Collected Data
We may automatically collect certain information when you use the App, including:
  • Device type and OS
  • IP address
  • App usage data (e.g. screen views, session time)
  • Crash logs and diagnostics

d. Location Data
With your permission, we may collect and use your location data to show location-specific content (e.g., nearby places to review).
''',
      ),
      PolicySection(
        title: "2. How We Use Your Information",
        content: '''
We use the collected information for purposes such as:
  • Personalizing your experience
  • Improving our App and features
  • Sending important updates and notifications
  • Providing customer support
  • Enforcing our Terms and Conditions
''',
      ),
      PolicySection(
        title: "3. Data Sharing & Disclosure",
        content: '''
We do not sell your data. However, we may share information with:
  • Service providers who assist in app operations
  • Legal authorities when required by law
  • Analytics providers for app performance insights
''',
      ),
      PolicySection(
        title: "4. Your Data Rights",
        content: '''
You may:
  • Request access to your data
  • Request deletion of your data
  • Opt out of marketing communications
  • Revoke permissions (e.g., location, notifications)
''',
      ),
    ];

    return Scaffold(
      backgroundColor:  Color(0xFF1E1E1E),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryTextColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 20,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true, // Changed from false to true
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: dividerColor, height: 1.0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildIntroText(),
          const SizedBox(height: 24),
          // Dynamically generate sections
          ...sections.map((section) => _buildSection(section)).toList(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildIntroText() {
    return const Text(
      'Welcome to [App Name] (the "App"), operated by [Your Company Name] ("we", "us", or "our"). '
          'This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application, '
          'including any related services and features.\n\n'
          'By using the App, you agree to the terms of this Privacy Policy. If you do not agree with our practices, please do not use the App.',
      style: TextStyle(
        color: primaryTextColor,
        fontSize: 14,
        fontFamily: 'General Sans Variable',
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
    );
  }

  Widget _buildSection(PolicySection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 16,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            section.content,
            style: const TextStyle(
              color: primaryTextColor,
              fontSize: 14,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
// Data Model for dynamic sections
// ---------------------------
class PolicySection {
  final String title;
  final String content;

  const PolicySection({required this.title, required this.content});
}
