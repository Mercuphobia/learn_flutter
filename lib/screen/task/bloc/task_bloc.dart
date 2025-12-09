import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/task/task_model.dart';
import '../../../services/task_service.dart';
import './task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskService _service;

  TaskCubit(this._service) : super(const TaskState.initial());

  Future<void> loadTasks() async {
    try{
      emit(const TaskState.loading());

      await _service.initFakeData();

      final tasks = await _service.getTasks();
      emit(TaskState.loaded(tasks));

    }
    catch (e) {
      emit(TaskState.error("Loi tai du lieu"));
    }
  }

  Future<void> addTask(Task newTask) async {
    // lay state hien tai neu dang loaded
    state.whenOrNull(loaded: (currentTask) async{
      final newList = [newTask, ...currentTask];

      emit(TaskState.loaded(newList));

      await _service.saveToPrefs(newList);
    });
  }

  Future<void> toggleSubTask(String taskId, int subIndex) async {
    state.whenOrNull(loaded: (currentTasks) async {
      // Tìm và sửa task trong list
      final newTaskList = currentTasks.map((task) {
        if (task.id == taskId) {
          // Copy list subtask ra để sửa
          final newSubTasks = List<SubTask>.from(task.subTasks);
          final target = newSubTasks[subIndex];

          // Đảo trạng thái isCompleted
          newSubTasks[subIndex] = target.copyWith(isCompleted: !target.isCompleted);

          // Trả về task mới với subtask mới
          return task.copyWith(subTasks: newSubTasks);
        }
        return task;
      }).toList();

      // Emit state mới để UI vẽ lại thanh progress
      emit(TaskState.loaded(newTaskList));

      // Lưu toàn bộ list mới xuống máy
      await _service.saveToPrefs(newTaskList);
    });
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    state.whenOrNull(loaded: (currentTasks) async {
      // 1. Tạo danh sách mới, tìm task trùng ID và đảo ngược isCompleted
      final updatedList = currentTasks.map((t) {
        if (t.id == taskId) {
          return t.copyWith(isCompleted: !t.isCompleted);
        }
        return t;
      }).toList();

      // 2. Cập nhật UI ngay lập tức
      emit(TaskState.loaded(updatedList));

      // 3. Lưu xuống máy (quan trọng)
      await _service.saveToPrefs(updatedList);
    });
  }
}