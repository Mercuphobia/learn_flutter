import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model/notification_model.dart';

class NotificationService {
  static const String _storageKey = 'read_notifications_ids';

  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // Lấy danh sách các Tiêu đề (hoặc ID) đã đọc từ bộ nhớ máy
    final prefs = await SharedPreferences.getInstance();
    final List<String> readTitles = prefs.getStringList(_storageKey) ?? [];

    // Duyệt qua danh sách Mock Data gốc
    // Nếu tiêu đề của item nằm trong danh sách "đã đọc" -> set isRead = true
    final List<NotificationModel> syncedList = mockNotifications.map((item) {
      if (readTitles.contains(item.title)) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();

    return syncedList;
  }

  // 2. Lưu trạng thái đã đọc vào SharedPreferences
  Future<void> markAsRead(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> readTitles = prefs.getStringList(_storageKey) ?? [];

    // Nếu chưa có trong danh sách thì thêm vào và lưu lại
    if (!readTitles.contains(title)) {
      readTitles.add(title);
      await prefs.setStringList(_storageKey, readTitles);
    }
  }
}