import 'package:flutter/material.dart';
import 'main.dart'; 
import 'dart:io'; 
import 'package:image_picker/image_picker.dart';
import 'shared_widgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  final TextEditingController _emailController = TextEditingController(text: "jane.doe@example.com");
  
  // Local state to track the image path before saving
  String? _tempImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: nameNotifier.value);
    _bioController = TextEditingController(text: bioNotifier.value);
    // Initialize with the current global image path
    _tempImagePath = profilePicPathNotifier.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // --- IMAGE PICKER LOGIC ---
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 50, // Optimize size
    );

    if (image != null) {
      setState(() {
        _tempImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = themeNotifier.value == ThemeMode.dark;
    Color primaryGreen = const Color(0xFF4A9F6A);
    Color textDark = isDark ? Colors.white : const Color(0xFF2D2D2D);
    Color bgLight = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
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
        title: Text("EDIT PROFILE", 
          style: TextStyle(color: textDark, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 16)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // --- AVATAR EDIT SECTION ---
                    GestureDetector(
                      onTap: () => _showAvatarPicker(context, cardColor, textDark, primaryGreen),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: primaryGreen.withValues(alpha: 0.1),
                            // Show selected image if it exists, otherwise show default icon
                            backgroundImage: _tempImagePath != null 
                                ? FileImage(File(_tempImagePath!)) 
                                : null,
                            child: _tempImagePath == null 
                                ? Icon(Icons.person, size: 50, color: primaryGreen) 
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                shape: BoxShape.circle,
                                border: Border.all(color: bgLight, width: 3),
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    buildEditProfileInputField("Full Name", _nameController, isDark, cardColor, borderColor, textDark),
                    const SizedBox(height: 20),
                    buildEditProfileInputField("Email Address", _emailController, isDark, cardColor, borderColor, textDark),
                    const SizedBox(height: 20),
                    buildEditProfileInputField("Bio", _bioController, isDark, cardColor, borderColor, textDark),
                    const SizedBox(height: 60),

                    // --- SAVE BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // UPDATE GLOBAL STATE
                          nameNotifier.value = _nameController.text;
                          bioNotifier.value = _bioController.text; 
                          profilePicPathNotifier.value = _tempImagePath; // Save the path string

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profile Updated Successfully!"), 
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color(0xFF4A9F6A),
                            )
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text("Save Changes", 
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UPDATED PICKER MODAL ---
  void _showAvatarPicker(BuildContext context, Color bgColor, Color textColor, Color primary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Profile Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 20),
            ListTile(
              leading: _buildIconCircle(Icons.photo_library, Colors.blue),
              title: Text("Choose from Gallery", style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: _buildIconCircle(Icons.camera_alt, Colors.orange),
              title: Text("Take a Photo", style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_tempImagePath != null)
              ListTile(
                leading: _buildIconCircle(Icons.delete_outline, Colors.red),
                title: const Text("Remove Photo", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
                onTap: () {
                  setState(() => _tempImagePath = null);
                  Navigator.pop(context);
                },
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, Color color) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
    child: Icon(icon, color: color, size: 22),
  );
}

