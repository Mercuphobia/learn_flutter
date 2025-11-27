import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả giống trong ảnh
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "See your statistic!",
        "subtitle": "Hello Phillip, let's see your progress in 2020",
        "type": "chart", // chart, check, warning
        "isRead": false,
      },
      {
        "title": "Task completed",
        "subtitle": "Well done Phillip, you have completed all tasks",
        "type": "check",
        "isRead": true,
      },
      {
        "title": "UI Task less than 8 days",
        "subtitle": "Phillip, your assignment is less than 8 days",
        "type": "warning",
        "isRead": false,
      },
      {
        "title": "Edit Task less than 12 days",
        "subtitle": "Phillip, your assignment is less than 12 days",
        "type": "warning",
        "isRead": true,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Color(0xFF1967D2), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Notification", style: TextStyle(color: Color(0xFF1967D2), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: item['isRead'] ? Colors.white.withOpacity(0.6) : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                _buildIcon(item['type']),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['subtitle'],
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'check':
        iconData = Icons.check;
        color = const Color(0xFF1967D2); // Xanh dương đậm
        break;
      case 'warning':
        iconData = Icons.priority_high;
        color = const Color(0xFF9B82D8); // Tím nhạt
        break;
      case 'chart':
      default:
        iconData = Icons.bar_chart;
        color = const Color(0xFF9B82D8);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, color: Colors.white, size: 20),
    );
  }
}