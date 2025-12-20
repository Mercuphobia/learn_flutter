import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user/user_model.dart';
import '../../screen/task/bloc/task_bloc.dart';
import '../../screen/task/bloc/task_state.dart';
import 'edit_profile_screen.dart';
import './static_screen.dart';
import './setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel currentUser = UserModel.dummyData();

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return Scaffold(
      backgroundColor: bgPink,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... (Phần Header giữ nguyên như cũ) ...
            SizedBox(
              height: 340, // Chiều cao tổng của khu vực Header
              child: Stack(
                children: [
                  // Lớp 1: Nền xanh cong
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 60, left: 25),
                    child: const Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Lớp 2: Thẻ thông tin User (Đè lên lớp 1)
                  Positioned(
                    top: 110,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: bgPink,
                            backgroundImage: AssetImage(currentUser.avatarUrl),
                          ),
                          const SizedBox(height: 12),

                          // Tên
                          Text(
                            currentUser.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Nghề nghiệp
                          Text(
                            currentUser.profession,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 20),

                          // Thông tin chi tiết (Location | Task Completed)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Location
                              _buildInfoBadge(Icons.location_on, currentUser.location),

                              // Vách ngăn
                              Container(height: 30, width: 1, color: Colors.grey[300]),

                              // Task Completed (Dùng BlocBuilder để tự động đếm)
                              BlocBuilder<TaskCubit, TaskState>(
                                builder: (context, state) {
                                  int completedCount = 0;
                                  // Lọc ra các task có isCompleted == true
                                  state.whenOrNull(loaded: (tasks) {
                                    completedCount = tasks.where((t) => t.isCompleted).length;
                                  });

                                  return _buildInfoBadge(
                                    Icons.check_circle,
                                    "$completedCount tasks completed",
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // --- MENU OPTIONS SECTION (ĐÃ CẬP NHẬT NAVIGATOR) ---
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 1. My Profile
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: "My Profile",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: currentUser),
                        ),
                      );
                    },
                  ),

                  // 2. Statistic (ĐÃ THÊM LINK)
                  _buildMenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: "Statistic",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StatisticScreen()),
                      );
                    },
                  ),

                  // 3. Location (Chưa có màn hình, để trống hoặc thông báo)
                  _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: "Location",
                      onTap: () {
                        // Navigator.push(context, ... LocationScreen ...);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Location feature coming soon!")),
                        );
                      }
                  ),

                  // 4. Settings (ĐÃ THÊM LINK)
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),

                  // 5. Logout
                  _buildMenuItem(icon: Icons.logout, title: "Logout", isDestructive: true),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ... (Giữ nguyên các widget con _buildInfoBadge và _buildMenuItem) ...
  Widget _buildInfoBadge(IconData icon, String text) {
    // ... code cũ
    return Row(children: [Icon(icon, size: 18, color: const Color(0xFF1967D2)), const SizedBox(width: 8), Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500))]);
  }

  Widget _buildMenuItem({required IconData icon, required String title, VoidCallback? onTap, bool isDestructive = false}) {
    // ... code cũ
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(children: [Icon(icon, color: isDestructive ? Colors.redAccent : const Color(0xFF1967D2), size: 22), const SizedBox(width: 20), Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDestructive ? Colors.redAccent : Colors.black87))), if (!isDestructive) const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)]),
      ),
    );
  }
}