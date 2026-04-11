import 'package:flutter/material.dart';
import 'main.dart'; 

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = themeNotifier.value == ThemeMode.dark;
    Color primaryGreen = const Color(0xFF4A9F6A);
    Color textDark = isDark ? Colors.white : const Color(0xFF2D2D2D);
    Color bgLight = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color borderColor = isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("HELP CENTER", style: TextStyle(color: textDark, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text("How can we help?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textDark, letterSpacing: -0.5)),
            const SizedBox(height: 24),
            
            // Search Bar
            Container(
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: textDark),
                decoration: const InputDecoration(
                  hintText: "Search topics, questions...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            Text("CATEGORIES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.2)),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildCategoryCard(Icons.rocket_launch_outlined, "Basics", primaryGreen, cardColor, textDark),
                _buildCategoryCard(Icons.person_outline, "Account", Colors.blue, cardColor, textDark),
                _buildCategoryCard(Icons.star_outline_rounded, "Premium", Colors.orange, cardColor, textDark),
                _buildCategoryCard(Icons.security_outlined, "Security", Colors.redAccent, cardColor, textDark),
              ],
            ),

            const SizedBox(height: 32),
            Text("POPULAR QUESTIONS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.2)),
            const SizedBox(height: 16),
            _buildFAQTile("How do I save my reading progress?", cardColor, textDark, borderColor),
            _buildFAQTile("Is there an offline reading mode?", cardColor, textDark, borderColor),
            _buildFAQTile("How do I upgrade to Scholar Plus?", cardColor, textDark, borderColor),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, Color color, Color cardBg, Color textDark) {
    return Container(
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textDark, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String question, Color cardBg, Color textDark, Color borderColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: textDark,
          collapsedIconColor: Colors.grey,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(question, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textDark)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                "Our system automatically saves your progress every time you complete a lesson. You can view your status in the 'Reading History' section.",
                style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}