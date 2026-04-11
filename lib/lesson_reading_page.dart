import 'package:flutter/material.dart';
import 'main.dart';
import 'quiz_page.dart';

class ReadingPage extends StatelessWidget {
  final String title;
  final String content;
  final String quizId;
  final String? imagePath; 
  final String subject;
  final VoidCallback onQuizComplete;

  const ReadingPage({
    super.key, 
    required this.subject,
    required this.title, 
    required this.content, 
    required this.quizId,
    this.imagePath, 
    required this.onQuizComplete, 
  });

  @override
  Widget build(BuildContext context) {
    // Using ValueListenableBuilder ensures theme changes reflect here instantly
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, child) {
        bool isDark = currentTheme == ThemeMode.dark;
        Color textDark = isDark ? Colors.white : const Color(0xFF2D2D2D);
        Color bgLight = isDark ? const Color(0xFF121212) : Colors.white;
        Color primaryGreen = const Color(0xFF4A9F6A);

        return Scaffold(
          backgroundColor: bgLight,
          appBar: AppBar(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: textDark,
            actions: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, currentTheme, _) {
                  bool isDarkMode = currentTheme == ThemeMode.dark;
                  return IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: isDarkMode ? Colors.orangeAccent : const Color(0xFF4A9F6A),
                      size: 28,
                    ),
                    onPressed: () {
                      themeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
                    },
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // --- OPTIONAL: TOP PROGRESS BAR ---
              // This gives visual feedback that they are in a "Lesson"
              LinearProgressIndicator(
                value: 0.7, // Static for now, represents "Reading" phase
                backgroundColor: primaryGreen.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                minHeight: 3,
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- LESSON ILLUSTRATION ---
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: imagePath != null && imagePath!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  imagePath!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.menu_book_rounded, 
                                size: 80, 
                                color: primaryGreen,
                              ),
                      ),
                      
                      const SizedBox(height: 30),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold, 
                          color: textDark,
                          letterSpacing: -0.5
                        ),
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<double>(
                        valueListenable: fontSizeNotifier, // This listens to the global slider
                        builder: (context, multiplier, child) {
                          return Text(
                            content,
                            style: TextStyle(
                              // We multiply your base size (18) by the slider value
                              fontSize: 18 * multiplier, 
                              color: textDark.withValues(alpha: 0.8),
                              height: 1.6,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40), // Extra space at bottom for scrolling
                    ],
                  ),
                ),
              ),
              
              // --- BOTTOM ACTION BAR ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                            quizId: quizId,
                            subject: subject, // Pass the lesson title as the subject for the quiz
                            // When the quiz is passed, it triggers the callback
                            // which unlocks the next lesson in the list.
                            onFinish: onQuizComplete, 
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    child: const Text(
                      "Take Lesson Quiz",
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}