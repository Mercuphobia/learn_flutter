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

  Future<void> readNotification(NotificationModel targetItem) async {
    if (targetItem.isRead) return;

    state.whenOrNull(
      loaded: (currentList) async {
        final newList = currentList.map((item) {
          if (item.title == targetItem.title) {
            return item.copyWith(isRead: true);
          }
          return item;
        }).toList();

        emit(NotificationState.loaded(newList));

        await _service.markAsRead(targetItem.title);
      },
    );
  }
}