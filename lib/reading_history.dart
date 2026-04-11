// reading_history.dart
import 'package:flutter/material.dart';
import 'main.dart';

class ReadingHistoryPage extends StatelessWidget {
  const ReadingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = themeNotifier.value == ThemeMode.dark;
    Color primaryGreen = const Color(0xFF4A9F6A);
    Color textDark = isDark ? Colors.white : const Color(0xFF2D2D2D);
    Color textGrey = isDark ? Colors.grey[400]! : const Color(0xFF9E9E9E);
    Color bgLight = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    Color borderColor = isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("HISTORY", 
          style: TextStyle(color: textDark, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 16)),
      ),
      body: ValueListenableBuilder(
        valueListenable: readingHistoryNotifier,
        builder: (context, List<Map<String, dynamic>> history, child) {
          if (history.isEmpty) {
            return Center(
              child: Text("No history yet. Start reading!", style: TextStyle(color: textGrey)),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: history.length,
            separatorBuilder: (context, index) => Divider(color: borderColor),
            itemBuilder: (context, index) {
              return _buildHistoryTile(
                history[index], 
                primaryGreen, 
                textDark, 
                textGrey, 
                borderColor,
                isDark
              );
            },
          );
        },
      ),
    );
  }

// reading_history.dart

Widget _buildHistoryTile(Map<String, dynamic> item, Color primary, Color textDark, Color textGrey, Color border, bool isDark) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${item['subject']}: ${item['title']}", 
                      style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(item['date'], style: TextStyle(color: textGrey, fontSize: 11)),
                ],
              ),
            ),
            Text("${item['percentage']}%", 
                style: TextStyle(color: primary, fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        // --- PROGRESS BAR FOR THIS SUBJECT ---
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: item['progressValue'], // The 0.2 value
            backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(primary),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text("Subject Mastery", style: TextStyle(color: textGrey, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
}