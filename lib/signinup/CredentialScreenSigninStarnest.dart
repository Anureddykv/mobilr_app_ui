import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/screens/home_screen.dart';
import 'package:mobilr_app_ui/utils/snackbar_utils.dart';
import '../core/api_service.dart';

class CredentialScreenSigninStarnest extends StatefulWidget {
  const CredentialScreenSigninStarnest({super.key});

  @override
  State<CredentialScreenSigninStarnest> createState() => _CredentialScreenSigninStarnestState();
}

class _CredentialScreenSigninStarnestState extends State<CredentialScreenSigninStarnest> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Login with Starnest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                controller: _usernameController,
                hint: "Username / Email",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                hint: "Password",
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 40),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'General Sans Variable',
        fontSize: 12,
        height: 0.72,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF555555),
          fontFamily: 'General Sans Variable',
          fontSize: 12,
          height: 0.72,
        ),
        filled: true,
        fillColor: const Color(0xFF141414),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE6EAED), width: 1),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF626365),
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _isLoading ? null : () async {
        String errorMessage = "";
        if (_usernameController.text.isEmpty && _passwordController.text.isEmpty) {
          errorMessage = "Please enter Username and Password";
        } else if (_usernameController.text.isEmpty) {
          errorMessage = "Please enter Username / Email";
        } else if (_passwordController.text.isEmpty) {
          errorMessage = "Please enter Password";
        }

        if (errorMessage.isEmpty) {
          setState(() {
            _isLoading = true;
          });
          final api = ApiService();
          final result = await api.login(_usernameController.text, _passwordController.text);
          setState(() {
            _isLoading = false;
          });
          
          if (result != null) {
            Get.offAll(() => const HomeScreen());
          } else {
            SnackBarUtils.showTopSnackBar(context, "Invalid username or password", isError: true);
          }
        } else {
          SnackBarUtils.showTopSnackBar(context, errorMessage, isError: true);
        }
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey[800] : const Color(0xFFE6EAED),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: _isLoading 
            ? const SizedBox(
                width: 24, 
                height: 24, 
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              )
            : const Text(
            "Login",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "General Sans Variable",
              fontWeight: FontWeight.w600,
              color: Color(0xFF0B0B0B),
            ),
          ),
        ),
      ),
    );
  }
}
