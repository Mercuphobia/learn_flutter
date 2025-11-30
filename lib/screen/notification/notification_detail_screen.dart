import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notification_model/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel data;

  const NotificationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('d MMMM yyyy').format(data.date);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F0), // Màu nền hồng nhạt
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 45, // Kích thước box icon
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1967D2), // Xanh dương
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildIcon(data.type),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0), // Căn chỉnh cho đều với icon
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800, // Chữ rất đậm
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1967D2), // Xanh dương
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 60.0),
                child: Text(
                  dateString, // "4 March 2022"
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Text(
                data.subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 15),

              // Description (Nếu có)
              if (data.description != null)
                Text(
                  data.description!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData iconData;
    switch (type) {
      case 'check':
        iconData = Icons.check;
        break;
      case 'warning':
        iconData = Icons.priority_high;
        break;
      case 'chart':
      default:
        iconData = Icons.bar_chart;
        break;
    }
    return Icon(iconData, color: Colors.white, size: 24);
  }
}