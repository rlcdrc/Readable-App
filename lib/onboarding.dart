import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Interactive Stories",
      "desc": "Access a vast library of interactive stories designed for early learners.",
      "image": "assets/logo.png" 
    },
    {
      "title": "Understand Better",
      "desc": "Bite-sized summaries to help you learn and comprehend faster.",
      "image": "assets/understand.png" 
    },
    {
      "title": "Daily Growth",
      "desc": "Track your reading habits and watch your skills grow every day.",
      "image": "assets/grow_daily.png" 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. THE SWIPEABLE CONTENT
            PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return _buildPageContent(
                  onboardingData[index]["title"]!,
                  onboardingData[index]["desc"]!,
                  onboardingData[index]["image"]!,
                );
              },
            ),

            // 2. SKIP BUTTON (User Control)
            Positioned(
              top: 20,
              right: 20,
              child: TextButton(
                onPressed: () => _navigateToSignin(context),
                child: const Text(
                  "SKIP",
                  style: TextStyle(
                    color: Color(0xFF4A9F6A), 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // 3. BOTTOM UI (Dots & Button)
            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  // Pagination Dots (Feedback)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildModernActionButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(String title, String desc, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset(imagePath, height: 180, fit: BoxFit.contain),
          ),
          const SizedBox(height: 50),
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? const Color(0xFF4A9F6A) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildModernActionButton(BuildContext context) {
    bool isLastPage = _currentIndex == onboardingData.length - 1;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (isLastPage) {
            _navigateToSignin(context);
          } else {
            _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE8F5E9), // Light green background
          foregroundColor: const Color(0xFF4A9F6A), // Dark green text
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          isLastPage ? "GET STARTED" : "NEXT",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _navigateToSignin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/signin');
  }
}