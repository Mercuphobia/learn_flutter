import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task/task_model.dart';
import 'dart:math';

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
  Future<void> saveToPrefs(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String taskJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_tasksKey, taskJson);
  }

  // 3. Thêm Task mới
  // Future<void> addTask(Task newTask) async {
  //   final tasks = await getTasks();
  //   final newTasks = [newTask, ...tasks];
  //   await _saveToPrefs(newTasks);
  // }

  // 4. Cập nhật Task
  Future<void> updateTask(Task updatedTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);

    if (index != -1) {
      tasks[index] = updatedTask;
      await saveToPrefs(tasks);
    }
  }

  // 5. Xóa Task
  // Future<void> deleteTask(String id) async {
  //   final tasks = await getTasks();
  //   tasks.removeWhere((t) => t.id == id);
  //   await _saveToPrefs(tasks);
  // }

  // // 6. Hàm tạo dữ liệu giả (Đã cập nhật theo cấu trúc SubTask)
  // Future<void> initFakeData() async {
  //   final currentTasks = await getTasks();
  //   // Nếu đã có dữ liệu thì không tạo nữa
  //   if (currentTasks.isNotEmpty) return;
  //
  //   final now = DateTime.now();
  //
  //   final List<Task> fakeTasks = [
  //     // --- TASK 1: UI Design (Giả lập 80% progress) ---
  //     Task(
  //       id: '1',
  //       title: 'UI Design',
  //       description: 'Design mobile app interface for client, This includes everything from screens ans touchscreens, keyboard, sounds'
  //           'and event, light. To understand the evolution of UI, however, it helpful to learn a bit more about its history and how it has'
  //           'evolved into best practices and a profession',
  //       startTime: now,
  //       endTime: now.add(const Duration(days: 12, hours: 18)),
  //       isPriority: true,
  //       // Progress sẽ tự tính = (4/5) * 100 = 80%
  //       subTasks: [
  //         SubTask(title: 'Make a moodboard', isCompleted: true),
  //         SubTask(title: 'Make a wireframe', isCompleted: true),
  //         SubTask(title: 'Make a component design', isCompleted: true),
  //         SubTask(title: 'Client Meeting', isCompleted: true),
  //         SubTask(title: 'Make final design', isCompleted: false),
  //       ],
  //     ),
  //
  //     // --- TASK 2: Laravel Task (Giả lập 33% progress) ---
  //     Task(
  //       id: '2',
  //       title: 'Laravel Task',
  //       description: 'Fix bugs in backend API. To understand the evolution of UI, however, it helpful to learn a bit more about its history and how it has'
  //           'evolved into best practices and a profession',
  //       startTime: now,
  //       endTime: now.add(const Duration(days: 20)),
  //       isPriority: true,
  //       // Progress = (1/3) * 100 = 33%
  //       subTasks: [
  //         SubTask(title: 'Check database schema', isCompleted: true),
  //         SubTask(title: 'Fix Login API', isCompleted: false),
  //         SubTask(title: 'Deploy to server', isCompleted: false),
  //       ],
  //     ),
  //
  //     // --- TASK 3: Edit Picture (Giả lập 50% progress) ---
  //     Task(
  //       id: '3',
  //       title: 'Edit Picture',
  //       description: 'Edit photos for marketing campaign. To understand the evolution of UI, however, it helpful to learn a bit more about its history and how it has'
  //           'evolved into best practices and a profession',
  //       startTime: now,
  //       endTime: now.add(const Duration(days: 5)),
  //       isPriority: true,
  //       subTasks: [
  //         SubTask(title: 'Select best photos', isCompleted: true),
  //         SubTask(title: 'Color correction', isCompleted: false),
  //       ],
  //     ),
  //
  //     // --- DAILY TASKS (Không cần Subtask, chỉ cần trạng thái check/uncheck) ---
  //     Task(
  //       id: '4',
  //       title: 'Work Out',
  //       description: 'Gym time',
  //       startTime: now,
  //       endTime: now,
  //       isPriority: false,
  //       isCompleted: true, // Đã xong
  //       subTasks: [],
  //     ),
  //     Task(
  //       id: '5',
  //       title: 'Daily Meeting',
  //       description: 'Meeting with team via Zoom',
  //       startTime: now,
  //       endTime: now,
  //       isPriority: false,
  //       isCompleted: true, // Đã xong
  //       subTasks: [],
  //     ),
  //     Task(
  //       id: '6',
  //       title: 'Reading a Book',
  //       description: 'Read 20 pages of Clean Code',
  //       startTime: now,
  //       endTime: now,
  //       isPriority: false,
  //       isCompleted: false, // Chưa xong
  //       subTasks: [],
  //     ),
  //     Task(
  //       id: '7',
  //       title: 'Client Meeting',
  //       description: 'Discuss requirement for new project',
  //       startTime: now,
  //       endTime: now,
  //       isPriority: false,
  //       isCompleted: false,
  //       subTasks: [],
  //     ),
  //   ];
  //
  //   await saveToPrefs(fakeTasks);
  //   print("Đã tạo dữ liệu mẫu với SubTasks thành công!");
  // }


  Future<void> initFakeData() async {
    final currentTasks = await getTasks();
    // Nếu muốn reset toàn bộ dữ liệu cũ để nạp dữ liệu mới này, hãy mở comment dòng dưới:
    // await saveToPrefs([]);

    // Nếu đã có task rồi thì thôi không tạo nữa (để tránh nhân bản mỗi lần mở app)
    if (currentTasks.isNotEmpty) return;

    final now = DateTime.now();
    final List<Task> fakeTasks = [];
    final random = Random();

    // =========================================================================
    // 1. DỮ LIỆU QUÁ KHỨ (CHO MÀN HÌNH STATISTIC)
    // Tạo dữ liệu cho 12 tháng gần nhất để biểu đồ đẹp
    // =========================================================================
    for (int i = 1; i <= 12; i++) {
      // Lấy ngày của i tháng trước
      final pastMonth = DateTime(now.year, now.month - i, 15);

      // Số lượng task trong tháng đó (Random từ 10 đến 25 task mỗi tháng)
      int taskCount = 10 + random.nextInt(15);

      for (int j = 0; j < taskCount; j++) {
        // Random ngày trong tháng
        final date = DateTime(pastMonth.year, pastMonth.month, 1 + random.nextInt(25));

        // Random trạng thái hoàn thành (Tỷ lệ 70% là đã xong để biểu đồ đẹp)
        bool isDone = random.nextDouble() > 0.3;
        bool isPriority = random.nextBool();

        fakeTasks.add(Task(
          id: 'past_${i}_$j',
          title: isPriority ? 'Project Phase ${random.nextInt(5)}' : 'Daily Report',
          description: 'This is a history task for statistics testing.',
          startTime: date,
          endTime: date.add(const Duration(hours: 2)),
          isPriority: isPriority,
          isCompleted: isDone, // Quan trọng cho màn Statistic
          subTasks: [],
        ));
      }
    }

    // =========================================================================
    // 2. DỮ LIỆU HIỆN TẠI (TUẦN NÀY - CHI TIẾT)
    // Tạo các task cụ thể có Subtask để demo màn hình Edit/Add
    // =========================================================================

    // Task 1: UI Design (Hôm nay)
    fakeTasks.add(Task(
      id: 'today_1',
      title: 'UI Mobile Design',
      description: 'Design mobile app interface for client. Include Login, Home, Profile screens.',
      startTime: now,
      endTime: now.add(const Duration(hours: 4)),
      isPriority: true,
      isCompleted: false,
      subTasks: [
        SubTask(title: 'Moodboard', isCompleted: true),
        SubTask(title: 'Wireframe', isCompleted: true),
        SubTask(title: 'Visual Design', isCompleted: false),
      ],
    ));

    // Task 2: Meeting (Hôm nay)
    fakeTasks.add(Task(
      id: 'today_2',
      title: 'Team Meeting',
      description: 'Weekly sprint meeting via Zoom',
      startTime: now.add(const Duration(hours: 2)),
      endTime: now.add(const Duration(hours: 3)),
      isPriority: false, // Daily Task
      isCompleted: true,
      subTasks: [],
    ));

    // Task 3: Laravel (Ngày mai)
    fakeTasks.add(Task(
      id: 'tom_1',
      title: 'Laravel Backend',
      description: 'Setup API authentication using Sanctum.',
      startTime: now.add(const Duration(days: 1)),
      endTime: now.add(const Duration(days: 1, hours: 5)),
      isPriority: true,
      isCompleted: false,
      subTasks: [
        SubTask(title: 'Database Schema', isCompleted: false),
        SubTask(title: 'Controller Logic', isCompleted: false),
      ],
    ));

    // =========================================================================
    // 3. DỮ LIỆU TƯƠNG LAI (CHO MÀN HÌNH LỊCH)
    // Rải task cho 2 tháng tới để cuộn lịch
    // =========================================================================
    for (int i = 1; i <= 60; i++) {
      // Chỉ tạo task ngẫu nhiên (khoảng 30% số ngày là có việc)
      if (random.nextDouble() > 0.7) {
        final futureDate = now.add(Duration(days: i));
        fakeTasks.add(Task(
          id: 'future_$i',
          title: 'Future Plan $i',
          description: 'Upcoming event preparation',
          startTime: futureDate,
          endTime: futureDate.add(const Duration(hours: 1)),
          isPriority: random.nextBool(),
          isCompleted: false,
          subTasks: [],
        ));
      }
    }

    // =========================================================================
    // 4. LƯU TẤT CẢ VÀO MÁY
    // =========================================================================
    await saveToPrefs(fakeTasks);
    print("Đã tạo xong ${fakeTasks.length} task giả lập!");
  }
}