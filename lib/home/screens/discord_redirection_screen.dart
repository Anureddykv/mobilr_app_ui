import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
import 'package:mobilr_app_ui/signinup/CredentialScreenSignup.dart';

class DiscordRedirectionScreen extends StatelessWidget {
  final String serverName;
  final String serverImageUrl;
  final String serverInviteUrl;

  const DiscordRedirectionScreen({
    super.key,
    required this.serverName,
    required this.serverImageUrl,
    required this.serverInviteUrl,
  });

  void _launchDiscord(BuildContext context) {
    Get.offAll(() => HomeScreen());
  print("Navigating to Signup...");
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider = serverImageUrl.startsWith('http')
        ? NetworkImage(serverImageUrl)
        : AssetImage(serverImageUrl) as ImageProvider;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),

      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                width: 84,
                height: 84,
                decoration: ShapeDecoration(
                  color: const Color(0xFF141414),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFF191919), width: 1),
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      'We are redirecting you to Discord.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFE6EAED),
                        fontSize: 16,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Joining: $serverName',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF626365),
                        fontSize: 14,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 37, right: 37),
                child: GestureDetector(
                  onTap: () => _launchDiscord(context),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE6EAED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Color(0xFF0B0B0B),
                        fontSize: 16,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
