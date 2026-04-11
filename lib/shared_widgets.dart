import 'package:flutter/material.dart';

// ============================================
// REUSABLE BOTTOM NAVIGATION BAR
// ============================================
Widget buildModernBottomNav(
  BuildContext context,
  Color primaryGreen,
  Color textGrey,
  Color cardColor,
  Color borderColor,
  int activeIndex,
) {
  return Container(
    height: 90,
    decoration: BoxDecoration(color: cardColor, border: Border(top: BorderSide(color: borderColor))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavItem(Icons.home_filled, "Home", activeIndex == 0, primaryGreen, textGrey, () {
          if (activeIndex != 0) Navigator.pushNamed(context, '/home');
        }),
        _buildNavItem(Icons.book, "Lessons", activeIndex == 1, primaryGreen, textGrey, () {
          if (activeIndex != 1) Navigator.pushNamed(context, '/lessons');
        }),
        _buildNavItem(Icons.person_outline, "Profile", activeIndex == 2, primaryGreen, textGrey, () {
          if (activeIndex != 2) Navigator.pushNamed(context, '/profile');
        }),
      ],
    ),
  );
}

Widget _buildNavItem(IconData icon, String label, bool isActive, Color primaryGreen, Color textGrey, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? primaryGreen : textGrey.withValues(alpha: 0.5), size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? primaryGreen : textGrey, fontSize: 12, fontWeight: isActive ? FontWeight.w800 : FontWeight.w600)),
      ],
    ),
  );
}

// ============================================
// REUSABLE TEXT INPUT FIELD (For Auth Screens)
// ============================================
Widget buildModernInputField(
  String label,
  TextEditingController controller,
  IconData icon, {
  bool isPassword = false,
  bool isPasswordVisible = false,
  VoidCallback? onPasswordToggle,
  Function? onChanged,
}) {
  return TextField(
    controller: controller,
    obscureText: isPassword && !isPasswordVisible,
    onChanged: (_) => onChanged?.call(),
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      suffixIcon: isPassword
        ? IconButton(
            icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 20),
            onPressed: onPasswordToggle,
          )
        : null,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: const TextStyle(color: Color(0xFF4A9F6A)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF4A9F6A), width: 2),
      ),
    ),
  );
}

// ============================================
// REUSABLE TEXT INPUT FIELD (For Edit Profile)
// ============================================
Widget buildEditProfileInputField(
  String label,
  TextEditingController controller,
  bool isDark,
  Color cardColor,
  Color borderColor,
  Color textDark,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(color: textDark.withValues(alpha: 0.5), fontWeight: FontWeight.w700, fontSize: 13)),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        style: TextStyle(color: textDark, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: true,
          fillColor: cardColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: const Color(0xFF4A9F6A), width: 1.5),
          ),
        ),
      ),
    ],
  );
}

// ============================================
// REUSABLE ROUTE ANIMATION TRANSITION
// ============================================
Route createRoute(Widget page, Offset startOffset) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeOutCubic;
      var scaleTween = Tween<double>(begin: 0.95, end: 1.0).chain(CurveTween(curve: curve));
      var slideTween = Tween<Offset>(begin: startOffset * 0.2, end: Offset.zero).chain(CurveTween(curve: curve));
      var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: ScaleTransition(scale: animation.drive(scaleTween), child: SlideTransition(position: animation.drive(slideTween), child: child)),
      );
    },
  );
}
