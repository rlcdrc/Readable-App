import 'package:flutter/material.dart';
import 'lesson_page.dart';
import 'main.dart';
import 'shared_widgets.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedSubjectIndex = 0;

  final List<Map<String, dynamic>> subjects = [
    {
      "title": "Reading", "lessons": "10 lessons", "icon": Icons.menu_book_rounded,
      "color": const Color(0xFFE8F5E9), "iconColor": const Color(0xFF81C784),
    },
    {
      "title": "Science", "lessons": "8 lessons", "icon": Icons.science_outlined,
      "color": const Color(0xFFEDE7F6), "iconColor": const Color(0xFF9575CD),
    },
    {
      "title": "Math", "lessons": "12 lessons", "icon": Icons.add_box_rounded,
      "color": const Color(0xFFFFF3E0), "iconColor": const Color(0xFFFFB74D),
    },
    {
      "title": "History", "lessons": "7 lessons", "icon": Icons.account_balance_rounded,
      "color": const Color(0xFFFFEBEE), "iconColor": const Color(0xFFE57373),
    },
    {
      "title": "English", "lessons": "9 lessons", "icon": Icons.edit_rounded,
      "color": const Color(0xFFE3F2FD), "iconColor": const Color(0xFF64B5F6),
    },
    {
      "title": "Arts", "lessons": "6 lessons", "icon": Icons.palette_outlined,
      "color": const Color(0xFFFCE4EC), "iconColor": const Color(0xFFF06292),
    },
  ];

  // --- NAVIGATION LOGIC ---
void _navigateToLessons() async {
  // Wait for the user to return from the LessonPage
  await Navigator.push(
    context,
    createRoute(
      LessonPage(subject: subjects[selectedSubjectIndex]["title"]),
      const Offset(0.0, 1.0),
    ),
  );
  
  // This triggers when the user comes back, refreshing the "Start" to "Continue"
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    bool isDark = themeNotifier.value == ThemeMode.dark;
    
    Color primaryGreen = const Color(0xFF4A9F6A);
    Color textDark = isDark ? Colors.white : const Color(0xFF2D2D2D);
    Color textGrey = isDark ? Colors.grey[400]! : const Color(0xFF9E9E9E);
    Color bgLight = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color borderColor = isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: bgLight, 
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(textDark, textGrey, cardColor),
                    const SizedBox(height: 24),
                    Expanded(child: _buildSubjectsGrid(isDark, primaryGreen, textDark, textGrey, cardColor)),
                    _buildStartButton(primaryGreen), // This uses the selected index
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            buildModernBottomNav(context, primaryGreen, textGrey, cardColor, borderColor, 0),
          ],
        ),
      ),
    );
  }

  // --- UI WIDGETS ---

  Widget _buildHeader(Color textDark, Color textGrey, Color cardColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What do you want to\nlearn?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textDark, height: 1.1, letterSpacing: -0.5)),
            const SizedBox(height: 8),
            Text("Pick a subject to get started", style: TextStyle(fontSize: 16, color: textGrey, fontWeight: FontWeight.w500)),
          ],
        ),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentTheme, _) {
            bool isDarkIcon = currentTheme == ThemeMode.dark;
            return IconButton(
              icon: Icon(
                isDarkIcon ? Icons.light_mode : Icons.dark_mode,
                color: isDarkIcon ? Colors.orangeAccent : const Color(0xFF4A9F6A),
                size: 28,
              ),
              onPressed: () {
                themeNotifier.value = isDarkIcon ? ThemeMode.light : ThemeMode.dark;
                setState(() {});
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubjectsGrid(bool isDark, Color primaryGreen, Color textDark, Color textGrey, Color cardColor) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.95,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        bool isSelected = selectedSubjectIndex == index; // This IS used for the border color below

        return GestureDetector(
          onTap: () => setState(() => selectedSubjectIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              // isSelected is used here to show the green highlight
              border: Border.all(
                color: isSelected ? primaryGreen : Colors.transparent, 
                width: 2
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // Simplified this to remove unused complex opacity variables
                    color: subject["color"], 
                    shape: BoxShape.circle
                  ),
                  child: Icon(subject["icon"], color: subject["iconColor"], size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  subject["title"],
                  style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subject["lessons"],
                  style: TextStyle(color: textGrey, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

Widget _buildStartButton(Color primaryGreen) {
  // 1. Get the title of the currently selected subject
  final String selectedTitle = subjects[selectedSubjectIndex]["title"];

  // 2. Check if the first lesson is 'done'
  // (Assuming subjectContent is the global map in main.dart)
  bool hasStarted = subjectContent[selectedTitle]![0]["status"] == "done";

  // 3. Set the label
  String buttonLabel = hasStarted 
      ? "Continue $selectedTitle" 
      : "Start $selectedTitle";

  return GestureDetector(
    onTap: _navigateToLessons, // This now handles the refresh
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: primaryGreen.withValues(alpha: 0.1), 
        borderRadius: BorderRadius.circular(16)
      ),
      child: Center(
        child: Text(
          buttonLabel, 
          style: TextStyle(
            color: primaryGreen, 
            fontSize: 16, 
            fontWeight: FontWeight.w800
          )
        ),
      ),
    ),
  );
}
}

