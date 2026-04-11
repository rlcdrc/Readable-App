import 'package:flutter/material.dart';
import 'shared_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildModernHeader(),
              const SizedBox(height: 40),

              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                "Fill in your details to get started",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              buildModernInputField("Full Name", _userController, Icons.person_outline, onChanged: () => setState(() {})),
              const SizedBox(height: 20),
              buildModernInputField("Email Address", _emailController, Icons.alternate_email, onChanged: () => setState(() {})),
              const SizedBox(height: 20),
              buildModernInputField(
                "Password",
                _passController,
                Icons.lock_outline,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onPasswordToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 20),
              buildModernInputField(
                "Confirm Password",
                _confirmPassController,
                Icons.lock_reset,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onPasswordToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                onChanged: () => setState(() {}),
              ),

              const SizedBox(height: 32),
              // Button updates dynamically based on the state of all controllers
              _buildConfirmButton(context),
              
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      children: [
                        TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(color: Color(0xFF4A9F6A), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1),
            children: [
              TextSpan(text: 'Read', style: TextStyle(color: Colors.black87)),
              TextSpan(text: 'able', style: TextStyle(color: Color(0xFF4A9F6A))),
            ],
          ),
        ),
        Container(
          height: 3,
          width: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF4A9F6A),
            borderRadius: BorderRadius.circular(2),
          ),
        )
      ],
    );
  }

Widget _buildConfirmButton(BuildContext context) {
  bool isFormFilled = _userController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty &&
                      _passController.text.isNotEmpty &&
                      _confirmPassController.text.isNotEmpty;

  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      // Disable button if form isn't filled OR if it's already loading
      onPressed: (isFormFilled && !_isLoading) 
          ? () {
              setState(() => _isLoading = true); // Start loading state
              final navigator = Navigator.of(context);

              // Start the 5-second timer
              Future.delayed(const Duration(seconds: 5), () {
                if (!mounted) return;
                navigator.pushReplacementNamed('/signin');
              });
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFormFilled ? const Color(0xFFE8F5E9) : Colors.grey.shade200,
        foregroundColor: isFormFilled ? const Color(0xFF4A9F6A) : Colors.grey.shade400,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: _isLoading 
          ? const SizedBox(
              height: 20, 
              width: 20, 
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF4A9F6A))
            )
          : const Text("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    )
   );
  }
}