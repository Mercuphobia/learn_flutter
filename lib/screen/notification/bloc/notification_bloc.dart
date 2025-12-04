import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/notification_model/notification_model.dart';
import '../../../services/notification_service.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _service;

  NotificationCubit(this._service) : super(const NotificationState.initial());

  Future<void> getNotificationData() async {
    try {
      emit(const NotificationState.loading());
      final data = await _service.getNotifications();
      emit(NotificationState.loaded(data));
    } catch (e) {
      emit(NotificationState.error(e.toString()));
    }
  }

  // HÀM QUAN TRỌNG: Đánh dấu đã đọc
  Future<void> readNotification(NotificationModel targetItem) async {
    // Nếu đã đọc rồi thì không làm gì cả để tối ưu
    if (targetItem.isRead) return;

    state.whenOrNull(
      loaded: (currentList) async {
        // 1. Cập nhật UI ngay lập tức (cho mượt)
        final newList = currentList.map((item) {
          if (item.title == targetItem.title) { // So sánh bằng title (hoặc ID)
            return item.copyWith(isRead: true);
          }
          return item;
        }).toList();

        emit(NotificationState.loaded(newList));

        // 2. Gọi Service để lưu vào bộ nhớ máy (Lưu ngầm bên dưới)
        await _service.markAsRead(targetItem.title);
      },
    );
  }
}