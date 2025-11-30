import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:namer_app/models/notification_model/notification_model.dart';
import '../../../models/notification_model/notification_model.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState  with _$NotificationState {
  const factory NotificationState.initial() = _Initial;

  const factory NotificationState.loading() = _Loading;

  const factory NotificationState.loaded(List<NotificationModel> notification) = _Loaded;

  const factory NotificationState.error(String message) = _Error;
}