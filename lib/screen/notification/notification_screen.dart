
import 'package:flutter/material.dart';
import './notification_detail_screen.dart';
import '../../models/notification_model/notification_model.dart';
import '../../services/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/notification_bloc.dart';
import './bloc/notification_state.dart';


// ... các import bên trên giữ nguyên

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F0),
      appBar: AppBar(
        // ... code AppBar giữ nguyên
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

      body: BlocProvider(
        create: (context) {
          final service = NotificationService();
          return NotificationCubit(service)..getNotificationData();
        },
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF1967D2)),
              ),
              error: (message) => Center(child: Text("Lỗi: $message")),

              loaded: (notificationList) {
                if (notificationList.isEmpty) {
                  return const Center(child: Text("Không có thông báo nào"));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemCount: notificationList.length,
                  itemBuilder: (context, index) {
                    final item = notificationList[index];
                    return InkWell(
                        onTap: () {
                          context.read<NotificationCubit>().readNotification(item);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationDetailScreen(data: item),
                            ),
                          );
                        },
                      child: _buildNotificationItem(item),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel item) {

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // LOGIC MÀU SẮC:
        // item.isRead == true  -> Màu xám nhạt (Colors.grey[100])
        // item.isRead == false -> Màu trắng (Colors.white)
        color: item.isRead ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          // Chỉ hiện bóng đổ nếu chưa đọc (tạo cảm giác nổi lên)
          if (!item.isRead)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(item.type),

          const SizedBox(width: 15),

          // 2. Nội dung text bên phải
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    // Nếu chưa đọc thì màu đen đậm, đã đọc thì nhạt hơn chút
                    color: item.isRead ? Colors.black87 : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                // Subtitle
                Text(
                  item.subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData iconData;
    Color color;
    switch (type) {
      case 'check':
        iconData = Icons.check;
        color = const Color(0xFF1967D2); // Xanh dương
        break;
      case 'warning':
        iconData = Icons.priority_high;
        color = const Color(0xFF9B82D8); // Tím
        break;
      case 'chart':
      default:
        iconData = Icons.bar_chart;
        color = const Color(0xFF9B82D8); // Tím
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