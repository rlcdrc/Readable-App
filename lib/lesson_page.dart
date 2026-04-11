import 'package:flutter/material.dart';
import 'main.dart'; 
import 'lesson_reading_page.dart';
import 'shared_widgets.dart'; 

class LessonPage extends StatefulWidget {
  final String subject;

  const LessonPage({
    super.key, 
    this.subject = "Reading", 
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  
// --- PROGRESSION LOGIC ---
void completeLesson(String subject, int currentIndex) {
  setState(() {
    // 1. Mark current lesson as done
    subjectContent[subject]![currentIndex]["status"] = "done";
    
    // --- CALCULATE PROGRESS DATA ---
    int total = subjectContent[subject]!.length;
    int completedCount = subjectContent[subject]!.where((l) => l["status"] == "done").length;
    double progressValue = completedCount / total; // e.g., 0.2
    int percentage = (progressValue * 100).toInt(); // e.g., 20

    // --- ADD TO HISTORY ---
    final now = DateTime.now();
    final String formattedDate = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    
    readingHistoryNotifier.value = [
      {
        "title": subjectContent[subject]![currentIndex]["title"],
        "subject": subject,
        "date": formattedDate,
        "percentage": percentage,      // Saves the 20
        "progressValue": progressValue, // Saves the 0.2 for the bar
      },
      ...readingHistoryNotifier.value,
    ];

    // 2. Unlock next lesson logic
    if (currentIndex + 1 < subjectContent[subject]!.length) {
      if (subjectContent[subject]![currentIndex + 1]["status"] == "locked") {
        subjectContent[subject]![currentIndex + 1]["status"] = "inProgress";
      }
    }
  });
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

    List<Map<String, String>> currentLessons = 
        subjectContent[widget.subject] ?? subjectContent["Reading"]!;

    return Scaffold(
      backgroundColor: bgLight, 
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildHeader(widget.subject, textDark, textGrey, cardColor),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: currentLessons.length,
                itemBuilder: (context, index) {
                  
                  final lesson = currentLessons[index];
                  bool isLocked = lesson["status"] == "locked";

                  Widget pathItem = _buildPathItem(
                    number: (index + 1).toString(),
                    title: lesson["title"] ?? "Untitled",
                    subtitle: lesson["sub"] ?? "",
                    status: lesson["status"] ?? "locked",
                    isLast: index == currentLessons.length - 1,
                    primaryGreen: primaryGreen, 
                    textDark: textDark, textGrey: textGrey, bgLight: bgLight, cardColor: cardColor, isDark: isDark
                  );

                  // Inside your ListView.builder...
                          return GestureDetector(
                              onTap: isLocked ? null : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReadingPage(
                                      title: lesson["title"]!,
                                      subject: widget.subject,
                                      content: lesson["content"]!,
                                      quizId: lesson["quizType"]!,
                                      imagePath: lesson['image'],
                                      onQuizComplete: () {
                                        // Check if this is a NEW completion
                                        bool wasAlreadyDone = currentLessons[index]["status"] == "done";

                                        // Update local state (unlocks next lesson)
                                        completeLesson(widget.subject, index);

                                        // Update global profile counter
                                        if (!wasAlreadyDone) {
                                          lessonsCompletedNotifier.value++;
                                        }

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(wasAlreadyDone 
                                              ? "Review complete!" 
                                              : "Great job! Next lesson unlocked."),
                                            backgroundColor: primaryGreen,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }, 
                              child: pathItem,
                            );
                          },
                        ),
                      ),
                      buildModernBottomNav(context, primaryGreen, textGrey, cardColor, borderColor, 1),
                    ],
                  ),
                ),
              );
            }

  // ... (Header, PathItem, BottomNav widgets remain exactly as you had them)
    Widget _buildHeader(String subjectTitle, Color textDark, Color textGrey, Color cardColor) {
        // 1. Get the list of lessons for the current subject
        List<Map<String, String>> lessons = subjectContent[subjectTitle] ?? [];
        
        // 2. Calculate how many are 'done'
        int completedCount = lessons.where((l) => l["status"] == "done").length;
        
        // 3. Calculate percentage (e.g., 0.5 for 50%)
        double progress = lessons.isEmpty ? 0 : completedCount / lessons.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("$subjectTitle Path", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textDark)),
                  Text("Keep up the great work!", style: TextStyle(fontSize: 16, color: textGrey)),
                ]),
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
            ),
            const SizedBox(height: 16),
            // --- THIS PART USES THE 'PROGRESS' VARIABLE ---
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress, // Now the variable is used!
                      minHeight: 8,
                      backgroundColor: textGrey.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A9F6A)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A9F6A),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        );
      }

  Widget _buildPathItem({required String number, required String title, required String subtitle, required String status, bool isLast = false, required Color primaryGreen, required Color textDark, required Color textGrey, required Color bgLight, required Color cardColor, required bool isDark}) {
    bool isDone = status == "done";
    bool isInProgress = status == "inProgress";
    bool isLocked = status == "locked";

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? cardColor : (isInProgress ? primaryGreen : bgLight),
                border: Border.all(color: isDone || isInProgress ? primaryGreen : textGrey.withValues(alpha: 0.3), width: 2),
              ),
              child: Center(child: isDone ? Icon(Icons.check, color: primaryGreen, size: 24) : Text(number, style: TextStyle(color: isInProgress ? Colors.white : textGrey.withValues(alpha: 0.6), fontWeight: FontWeight.bold, fontSize: 18))),
            ),
            if (!isLast) Expanded(child: Container(width: 2, color: isDone || isInProgress ? primaryGreen.withValues(alpha: 0.5) : textGrey.withValues(alpha: 0.2))),
          ]),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 30, top: 4),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isLocked ? textDark.withValues(alpha: 0.5) : textDark)),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: textGrey)),
                ])),
                _buildStatusBadge(status, primaryGreen, textGrey, isDark),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color primaryGreen, Color textGrey, bool isDark) {
    if (status == "done") return Text("Done", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w700, fontSize: 13));
    if (status == "inProgress") return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: isDark ? const Color(0xFF3E2723) : const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(12)), child: Text("In progress", style: TextStyle(color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE68A00), fontWeight: FontWeight.w700, fontSize: 12)));
    return Text("Locked", style: TextStyle(color: textGrey.withValues(alpha: 0.6), fontWeight: FontWeight.w700, fontSize: 13));
  }
}

