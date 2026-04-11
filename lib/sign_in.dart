import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'shared_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              const SizedBox(height: 60),
              _buildModernHeader(),
              const Spacer(),

              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to continue your lessons",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              buildModernInputField(
                "Email or Username",
                _emailController,
                Icons.alternate_email,
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 20),
              
              buildModernInputField(
                "Password",
                _passwordController,
                Icons.lock_outline,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onPasswordToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                onChanged: () => setState(() {}),
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF4A9F6A), fontSize: 12)),
                ),
              ),

              const SizedBox(height: 10),
              // The button now re-builds every time the fields change
              _buildLearnNowButton(context),
              
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      children: [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(color: Color(0xFF4A9F6A), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
            children: [
              TextSpan(text: 'Read', style: TextStyle(color: Colors.black87)),
              TextSpan(text: 'able', style: TextStyle(color: Color(0xFF4A9F6A))),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 3,
          width: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF4A9F6A),
            borderRadius: BorderRadius.circular(2),
          ),
        )
      ],
    );
  }

  Widget _buildLearnNowButton(BuildContext context) {
    // Logic to check if both fields are filled
    bool isFormFilled = _emailController.text.isNotEmpty && 
                        _passwordController.text.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        // Button is disabled (null) if form is not filled
        onPressed: isFormFilled 
            ? () => Navigator.pushNamed(context, '/home') 
            : null,
        style: ElevatedButton.styleFrom(
          // Colors change dynamically based on filled status
          backgroundColor: isFormFilled 
              ? const Color(0xFFE8F5E9) 
              : Colors.grey.shade200, 
          foregroundColor: isFormFilled 
              ? const Color(0xFF4A9F6A) 
              : Colors.grey.shade400,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text(
          "Learn Now",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}