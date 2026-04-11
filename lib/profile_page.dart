import 'package:flutter/material.dart';
import 'main.dart'; 
import 'edit_profile.dart';
import 'reading_history.dart';
import 'help_center.dart'; 
import 'shared_widgets.dart';
import 'dart:io'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _selectedSpeed = "1.5x";
  bool _dailyReminder = true;
  bool _storyAlerts = false;
  bool _weeklyReport = true;

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
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        title: Text("PROFILE", style: TextStyle(color: textDark, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 16)),
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: lessonsCompletedNotifier,
          builder: (context, count, child) {
            int totalXP = count * 100;
            int currentLevel = (totalXP / 500).floor() + 1; 
            double levelProgress = (totalXP % 500) / 500;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView( 
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20), 
                        _buildProfileHeader(primaryGreen, textDark, textGrey),
                        const SizedBox(height: 30), 
                        _buildLevelCard(cardColor, textDark, primaryGreen, borderColor, currentLevel, levelProgress, totalXP),
                        const SizedBox(height: 24), 
                        _buildStatsRow(primaryGreen, textGrey, cardColor, borderColor),
                        const SizedBox(height: 32), 
                        _buildSettingsCard(context, textDark, textGrey, bgLight, cardColor, borderColor, isDark, primaryGreen),
                        const SizedBox(height: 32), 
                        _buildSupportSection(cardColor, textDark, primaryGreen, bgLight, borderColor),
                        const SizedBox(height: 40), 
                      ],
                    ),
                  ),
                ),
                buildModernBottomNav(context, primaryGreen, textGrey, cardColor, borderColor, 2),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildSupportSection(Color cardColor, Color textDark, Color primaryGreen, Color bgLight, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text("SUPPORT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _buildListTile(Icons.help_outline_rounded, "Help Center", textDark, Colors.grey, bgLight, () {
                // Now navigates to the separate help_center.dart file
                Navigator.push(context, createRoute(const HelpCenterPage(), const Offset(1.0, 0.0)));
              }, showArrow: true),
              _buildDivider(borderColor),
              _buildListTile(Icons.headset_mic_outlined, "Contact Support", textDark, Colors.grey, bgLight, () {
                _showContactSupportOverlay(context, cardColor, textDark, primaryGreen);
              }, showArrow: true),
            ],
          ),
        ),
      ],
    );
  }

  // ... (All your other existing helper methods like _buildLevelCard, _buildSettingsCard remain exactly as they were) ...

  void _showContactSupportOverlay(BuildContext context, Color bgColor, Color textColor, Color primary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            Text("Contact Support", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textColor)),
            const SizedBox(height: 10),
            Text("How would you like to reach us?", style: TextStyle(color: textColor.withValues(alpha: 0.6))),
            const SizedBox(height: 25),
            _buildSupportOption(Icons.email_outlined, "Send an Email", "Response within 24h", primary, textColor),
            const SizedBox(height: 12),
            _buildSupportOption(Icons.chat_bubble_outline_rounded, "Live Chat", "Talk to our team now", primary, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(IconData icon, String title, String sub, Color primary, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
              Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLevelCard(Color cardColor, Color textDark, Color primaryGreen, Color borderColor, int level, double progress, int totalXP) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Level $level Scholar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                Text("$totalXP Total XP Gained", style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ]),
              Icon(Icons.stars_rounded, color: primaryGreen, size: 32),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: primaryGreen.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, Color textDark, Color textGrey, Color bgLight, Color cardColor, Color borderColor, bool isDark, Color primaryGreen) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildListTile(Icons.person_outline, "Edit Profile", textDark, textGrey, bgLight, () {
            Navigator.push(context, createRoute(const EditProfilePage(), const Offset(1.0, 0.0)));
          }, showArrow: true),
          _buildDivider(borderColor),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            leading: _buildIconContainer(isDark ? Icons.dark_mode : Icons.light_mode, isDark ? Colors.deepPurple[300]! : Colors.orangeAccent, bgLight),
            title: Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: textDark)),
            trailing: Switch(
              value: isDark,
              activeThumbColor: primaryGreen,
              onChanged: (bool value) {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                setState(() {});
              },
            ),
          ),
          _buildDivider(borderColor),
          _buildListTile(Icons.text_fields, "Reading Preferences", textDark, textGrey, bgLight, () {
            _showPreferencesOverlay(context, cardColor, textDark, primaryGreen);
          }),
          _buildDivider(borderColor),
          _buildListTile(Icons.notifications_none, "Notifications", textDark, textGrey, bgLight, () {
            _showNotificationsOverlay(context, cardColor, textDark, primaryGreen);
          }),
          _buildDivider(borderColor),
          _buildListTile(Icons.history, "History", textDark, textGrey, bgLight, () {
            Navigator.push(context, createRoute(const ReadingHistoryPage(), const Offset(1.0, 0.0)));
          }, showArrow: true),
          _buildDivider(borderColor),
          _buildListTile(Icons.logout, "Log Out", Colors.redAccent, textGrey, Colors.redAccent.withValues(alpha: 0.1), () {
            Navigator.pushReplacementNamed(context, '/signin');
          }, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Color primaryGreen, Color textDark, Color textGrey) {
    return Column(
      children: [
        ValueListenableBuilder<String?>(
          valueListenable: profilePicPathNotifier,
          builder: (context, currentPath, child) {
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryGreen.withValues(alpha: 0.2), width: 2)),
              child: CircleAvatar(
                radius: 45, 
                backgroundColor: primaryGreen.withValues(alpha: 0.1), 
                backgroundImage: currentPath != null ? FileImage(File(currentPath)) : null,
                child: currentPath == null ? Icon(Icons.person, size: 40, color: primaryGreen) : null,
              ),
            );
          }
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<String>(
          valueListenable: nameNotifier,
          builder: (context, currentName, child) => Text(currentName, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textDark, letterSpacing: -0.5)),
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder<String>(
          valueListenable: bioNotifier,
          builder: (context, currentBio, child) => Text(currentBio, style: TextStyle(fontSize: 14, color: textGrey, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

Widget _buildStatsRow(Color primaryGreen, Color textGrey, Color cardColor, Color borderColor) {
  return Row(
    children: [
      // 1. Lessons Completed Stat
      Expanded(
        child: ValueListenableBuilder<int>(
          valueListenable: lessonsCompletedNotifier,
          builder: (context, count, child) => _buildStatBox(
            count.toString(), 
            "Lessons Completed", 
            primaryGreen, 
            textGrey, 
            cardColor, 
            borderColor,
          ),
        ),
      ),
      const SizedBox(width: 12), // Space between boxes
      // 2. Accuracy Stat (Now Dynamic!)
      Expanded(
        child: ValueListenableBuilder<double>(
          valueListenable: accuracyNotifier, // Listens to the global accuracy
          builder: (context, accuracy, child) => _buildStatBox(
            "${accuracy.toInt()}%", // Converts 92.0 to "92%"
            "Accuracy", 
            Colors.orange, 
            textGrey, 
            cardColor, 
            borderColor,
          ),
        ),
      ),
    ],
  );
}

  Widget _buildStatBox(String value, String label, Color color, Color textGrey, Color cardColor, Color borderColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: textGrey, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, Color color, Color bg) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20));

  Widget _buildListTile(IconData icon, String title, Color titleColor, Color textGrey, Color bgLight, VoidCallback onTap, {bool isDestructive = false, bool showArrow = true}) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    leading: _buildIconContainer(icon, titleColor, bgLight),
    title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: titleColor)),
    trailing: isDestructive ? null : (showArrow ? Icon(Icons.arrow_forward_ios, size: 14, color: textGrey.withValues(alpha: 0.4)) : null),
    onTap: onTap,
  );

  Widget _buildDivider(Color borderColor) => Divider(height: 1, thickness: 1, color: borderColor, indent: 60, endIndent: 20);

void _showPreferencesOverlay(BuildContext context, Color bgColor, Color textColor, Color primary) {
  showModalBottomSheet(
    context: context,
    backgroundColor: bgColor,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 25),
            Text("Reading Preferences", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textColor)),
            const SizedBox(height: 25),
            
            // --- UPDATED FONT SIZE SECTION ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Font Size", style: TextStyle(color: textColor.withAlpha(153), fontWeight: FontWeight.w600)),
                // Displays 1.0x, 1.2x etc.
                Text("${fontSizeNotifier.value.toStringAsFixed(1)}x", 
                  style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: fontSizeNotifier.value, // Use global value
              min: 1.0,  // Normal
              max: 2.5,  // PWD Friendly (Extra Large)
              divisions: 6,
              activeColor: primary,
              onChanged: (v) {
                // Update both the UI and the global value
                setSheetState(() {
                  fontSizeNotifier.value = v;
                });
                // Also trigger a rebuild of the Profile Page itself
                setState(() {}); 
              },
            ),
            // --- END UPDATED SECTION ---

            const SizedBox(height: 15),
            Text("Auto-Scroll Speed", style: TextStyle(color: textColor.withAlpha(153), fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            Row(
              children: ["1x", "1.5x", "2x"].map((speed) => Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ChoiceChip(
                  label: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(speed)),
                  selected: _selectedSpeed == speed,
                  onSelected: (v) => setSheetState(() => _selectedSpeed = speed),
                  selectedColor: primary.withAlpha(51),
                  labelStyle: TextStyle(color: _selectedSpeed == speed ? primary : textColor, fontWeight: FontWeight.bold),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _showNotificationsOverlay(BuildContext context, Color bgColor, Color textColor, Color primary) {
    showModalBottomSheet(context: context, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))), builder: (context) => StatefulBuilder(builder: (context, setSheetState) => Padding(padding: const EdgeInsets.fromLTRB(10, 12, 10, 40), child: Column(mainAxisSize: MainAxisSize.min, children: [Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))), const SizedBox(height: 20), _buildToggleTile("Daily Reading Reminder", _dailyReminder, primary, textColor, (v) => setSheetState(() => _dailyReminder = v)), _buildToggleTile("New Story Alerts", _storyAlerts, primary, textColor, (v) => setSheetState(() => _storyAlerts = v)), _buildToggleTile("Weekly Progress Report", _weeklyReport, primary, textColor, (v) => setSheetState(() => _weeklyReport = v))]))));
  }

  Widget _buildToggleTile(String title, bool val, Color primary, Color textColor, Function(bool) onChanged) => SwitchListTile(title: Text(title, style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.w700)), value: val, activeThumbColor: primary, onChanged: onChanged);

}