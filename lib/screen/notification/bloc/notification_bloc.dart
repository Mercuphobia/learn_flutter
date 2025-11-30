

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namer_app/models/notification_model/notification_model.dart';
import './notification_state.dart';
import '../../../services/notification_service.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _service;

  // Khởi tạo Cubit với trạng thái ban đầu là Initial
  NotificationCubit(this._service) : super(const NotificationState.initial());

  Future<void> getNotificationData() async {
    try {
      // 1. Bắn ra trạng thái Loading (để UI hiện vòng xoay)
      emit(const NotificationState.loading());

      // 2. Gọi Service lấy dữ liệu
      final data = await _service.getNotifications();

      // 3. Nếu thành công -> Bắn ra trạng thái Loaded kèm dữ liệu
      emit(NotificationState.loaded(data));

    } catch (e) {
      // 4. Nếu lỗi -> Bắn ra trạng thái Error
      emit(NotificationState.error(e.toString()));
      print("loi cucbit: $e\n");
    }
  }

  void readNotification(NotificationModel targetItem) {
    // 1. Kiểm tra xem state hiện tại có phải là loaded (đang có dữ liệu) không
    state.whenOrNull(
      loaded: (currentList) {
        // 2. Tạo một danh sách mới từ danh sách cũ
        final newList = currentList.map((item) {
          // Nếu tìm thấy item trùng khớp với cái vừa bấm
          if (item == targetItem) {
            // Tạo bản sao và đổi isRead thành true (dùng copyWith của Freezed)
            return item.copyWith(isRead: true);
          }
          // Các item khác giữ nguyên
          return item;
        }).toList();

        // 3. Bắn danh sách mới ra cho UI cập nhật
        emit(NotificationState.loaded(newList));
      },
    );
  }
}