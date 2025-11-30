import '../models/notification_model/notification_model.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return mockNotifications;
  }
}