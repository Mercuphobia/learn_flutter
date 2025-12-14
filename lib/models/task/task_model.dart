import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class SubTask with _$SubTask {
  factory SubTask({
    required String title,
    @Default(false) bool isCompleted,
  }) = _SubTask;

  factory SubTask.fromJson(Map<String, dynamic> json) => _$SubTaskFromJson(json);
}

@freezed
class Task with _$Task {
  // Cần thêm dòng này để viết custom getter trong Freezed
  const Task._();

  factory Task({
    required String id,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    @Default(false) bool isPriority,
    @Default(false) bool isCompleted,
    @Default([]) List<SubTask> subTasks,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  // LOGIC TỰ ĐỘNG TÍNH %
  int get progress {
    if (subTasks.isEmpty) return 0;

    // Đếm số việc con đã xong
    int completedCount = subTasks.where((s) => s.isCompleted).length;

    // Tính phần trăm: (đã xong / tổng) * 100
    return ((completedCount / subTasks.length) * 100).round();
  }
}