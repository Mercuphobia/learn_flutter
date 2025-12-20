import 'package:flutter/material.dart';

class InviteFriendScreen extends StatelessWidget {
  InviteFriendScreen({super.key});

  // Dữ liệu giả lập danh bạ
  final List<Map<String, String>> contacts = [
    {'name': 'Jakob', 'phone': '+62 812-5575-1205', 'img': 'assets/images/google.png'},
    {'name': 'Kianna Westervelt', 'phone': '+62 812-1955-1278', 'img': 'assets/images/google.png'},
    {'name': 'Roger Aminoff', 'phone': '+62 812-1955-8742', 'img': 'assets/images/google.png'},
    {'name': 'Kianna', 'phone': '+62 812-2995-1878', 'img': 'assets/images/google.png'},
    {'name': 'Jakob Septimus', 'phone': '+62 812-1265-1754', 'img': 'assets/images/google.png'},
    {'name': 'Lindsey Vetrovs', 'phone': '+62 812-5858-1868', 'img': 'assets/images/google.png'},
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.arrow_back, color: primaryBlue, size: 20),
                    ),
                  ),
                  const Expanded(child: Text("Invite a Friend", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // BODY LIST
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bgPink,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("From contact", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 15),

                    Expanded(
                      child: ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey[300],
                                // Nếu chưa có ảnh thật, dùng Icon thay thế
                                child: const Icon(Icons.person, color: Colors.white),
                                // backgroundImage: AssetImage(contact['img']!), // Bật dòng này khi có ảnh thật
                              ),
                              title: Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Text(contact['phone']!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}