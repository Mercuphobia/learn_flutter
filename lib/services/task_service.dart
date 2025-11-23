import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart'; // Đảm bảo import đúng file model chứa cả Task và SubTask

class TaskService {
  static const String _tasksKey = 'tasks_data';

  // 1. Lấy danh sách Task
  Future<List<Task>> getTasks() async {
    final pref = await SharedPreferences.getInstance();
    final String? taskJson = pref.getString(_tasksKey);

    if (taskJson == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(taskJson);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      print("Lỗi đọc dữ liệu: $e");
      return [];
    }
  }

  // 2. Lưu danh sách task (Hàm nội bộ)
  Future<void> _saveToPrefs(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String taskJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_tasksKey, taskJson);
  }

  // 3. Thêm Task mới
  Future<void> addTask(Task newTask) async {
    final tasks = await getTasks();
    final newTasks = [newTask, ...tasks];
    await _saveToPrefs(newTasks);
  }

  // 4. Cập nhật Task
  Future<void> updateTask(Task updatedTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);

    if (index != -1) {
      tasks[index] = updatedTask;
      await _saveToPrefs(tasks);
    }
  }

  // 5. Xóa Task
  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await _saveToPrefs(tasks);
  }

  // 6. Hàm tạo dữ liệu giả (Đã cập nhật theo cấu trúc SubTask)
  Future<void> initFakeData() async {
    final currentTasks = await getTasks();
    // Nếu đã có dữ liệu thì không tạo nữa
    if (currentTasks.isNotEmpty) return;

    final now = DateTime.now();

    final List<Task> fakeTasks = [
      // --- TASK 1: UI Design (Giả lập 80% progress) ---
      Task(
        id: '1',
        title: 'UI Design',
        description: 'Design mobile app interface for client',
        startTime: now,
        endTime: now.add(const Duration(days: 12, hours: 18)),
        isPriority: true,
        // Progress sẽ tự tính = (4/5) * 100 = 80%
        subTasks: [
          SubTask(title: 'Make a moodboard', isCompleted: true),
          SubTask(title: 'Make a wireframe', isCompleted: true),
          SubTask(title: 'Make a component design', isCompleted: true),
          SubTask(title: 'Client Meeting', isCompleted: true),
          SubTask(title: 'Make final design', isCompleted: false),
        ],
      ),

      // --- TASK 2: Laravel Task (Giả lập 33% progress) ---
      Task(
        id: '2',
        title: 'Laravel Task',
        description: 'Fix bugs in backend API',
        startTime: now,
        endTime: now.add(const Duration(days: 20)),
        isPriority: true,
        // Progress = (1/3) * 100 = 33%
        subTasks: [
          SubTask(title: 'Check database schema', isCompleted: true),
          SubTask(title: 'Fix Login API', isCompleted: false),
          SubTask(title: 'Deploy to server', isCompleted: false),
        ],
      ),

      // --- TASK 3: Edit Picture (Giả lập 50% progress) ---
      Task(
        id: '3',
        title: 'Edit Picture',
        description: 'Edit photos for marketing campaign',
        startTime: now,
        endTime: now.add(const Duration(days: 5)),
        isPriority: true,
        subTasks: [
          SubTask(title: 'Select best photos', isCompleted: true),
          SubTask(title: 'Color correction', isCompleted: false),
        ],
      ),

      // --- DAILY TASKS (Không cần Subtask, chỉ cần trạng thái check/uncheck) ---
      Task(
        id: '4',
        title: 'Work Out',
        description: 'Gym time',
        startTime: now,
        endTime: now,
        isPriority: false,
        isCompleted: true, // Đã xong
        subTasks: [],
      ),
      Task(
        id: '5',
        title: 'Daily Meeting',
        description: 'Meeting with team via Zoom',
        startTime: now,
        endTime: now,
        isPriority: false,
        isCompleted: true, // Đã xong
        subTasks: [],
      ),
      Task(
        id: '6',
        title: 'Reading a Book',
        description: 'Read 20 pages of Clean Code',
        startTime: now,
        endTime: now,
        isPriority: false,
        isCompleted: false, // Chưa xong
        subTasks: [],
      ),
      Task(
        id: '7',
        title: 'Client Meeting',
        description: 'Discuss requirement for new project',
        startTime: now,
        endTime: now,
        isPriority: false,
        isCompleted: false,
        subTasks: [],
      ),
    ];

    await _saveToPrefs(fakeTasks);
    print("Đã tạo dữ liệu mẫu với SubTasks thành công!");
  }
}