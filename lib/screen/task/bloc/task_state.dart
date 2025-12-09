import '../../../models/task/task_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_state.freezed.dart';

@freezed

class TaskState with _$TaskState {
  const factory TaskState.initial() = _Initial;
  const factory TaskState.loading() = _Loading;
  const factory TaskState.loaded(List<Task> tasks) = _Loaded;
  const factory TaskState.error(String message) = _Error;
}