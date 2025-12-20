import 'package:flutter/material.dart';

// Import các màn hình con đã tạo
import './security_screen.dart';
import './help_screen.dart';
import './invite_friend_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return Scaffold(
      backgroundColor: primaryBlue, // Nền gốc màu xanh
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- 1. HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  // Nút Back
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Icon(Icons.arrow_back, color: primaryBlue, size: 20),
                    ),
                  ),

                  // Tiêu đề
                  const Expanded(
                    child: Text(
                        "Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ),

                  // Khoảng trống giả để cân giữa tiêu đề
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // --- 2. BODY LIST ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bgPink,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 1. Notification (Chưa có màn hình -> Hiện thông báo)
                      _buildSettingItem(context, Icons.notifications, "Notification"),

                      // 2. Security (Đã kết nối)
                      _buildSettingItem(
                        context,
                        Icons.lock,
                        "Security",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SecurityScreen()),
                          );
                        },
                      ),

                      // 3. Help (Đã kết nối)
                      _buildSettingItem(
                        context,
                        Icons.help_outline,
                        "Help",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpScreen()),
                          );
                        },
                      ),

                      // 4. Update System (Chưa có màn hình)
                      _buildSettingItem(context, Icons.system_update_alt, "Update System"),

                      // 5. About (Chưa có màn hình)
                      _buildSettingItem(context, Icons.info_outline, "About"),

                      // 6. Invite a friend (Đã kết nối)
                      _buildSettingItem(
                        context,
                        Icons.people_outline,
                        "Invite a friend",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InviteFriendScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con để vẽ từng dòng cài đặt
  // Đã thêm tham số tùy chọn {VoidCallback? onTap}
  Widget _buildSettingItem(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1967D2)), // Icon màu xanh
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 15
          ),
        ),
        // Nếu có onTap thì dùng, không có thì hiện thông báo "Coming soon"
        onTap: onTap ?? () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Feature '$title' is coming soon!"),
              duration: const Duration(milliseconds: 500),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}