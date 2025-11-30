import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task/task_model.dart';
import '../../services/task_service.dart';


class UiDesign extends StatefulWidget {
  final Task task;
  const UiDesign({super.key, required this.task});

  @override
  State<UiDesign> createState() => _UiDesignState();
}

class _UiDesignState extends State<UiDesign> {
  late Task _task;
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  // Hàm xử lý khi tick vào subtask
  void _toggleSubTask(int index) async {
    // 1. Tạo bản sao danh sách subtasks
    List<SubTask> newSubTasks = List.from(_task.subTasks);

    // 2. Đảo ngược trạng thái của item được chọn
    final currentStatus = newSubTasks[index].isCompleted;
    newSubTasks[index] = newSubTasks[index].copyWith(isCompleted: !currentStatus);

    // 3. Cập nhật UI và lưu xuống máy
    final updatedTask = _task.copyWith(subTasks: newSubTasks);

    setState(() {
      _task = updatedTask;
    });

    await _taskService.updateTask(_task);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2); // Màu xanh chủ đạo
    const Color bgPink = Color(0xFFFFF0F0);      // Màu nền hồng nhạt

    return Scaffold(
      backgroundColor: bgPink,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER & TIMER SECTION ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Title + Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon + Title
                      Row(
                        children: [
                          const Icon(Icons.language, color: primaryBlue, size: 28), // Giả lập icon quả cầu
                          const SizedBox(width: 10),
                          Text(
                            _task.title,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primaryBlue
                            ),
                          ),
                        ],
                      ),
                      // Close Button
                      InkWell(
                        onTap: () => Navigator.pop(context), // Quay lại màn hình trước
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Row: Start Date & End Date Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDateLabel("start", _task.startTime),
                      _buildDateLabel("end", _task.endTime, isEnd: true),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Row: 3 ô đếm ngược (Months, Days, Hours)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildCountDownBoxes(_task.endTime),
                  ),
                ],
              ),
            ),

            // --- SCROLLABLE CONTENT (Description, Progress, To-Do List) ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      _task.description,
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                    ),

                    const SizedBox(height: 25),

                    // Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("${_task.progress}%", style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _task.progress / 100,
                        minHeight: 12,
                        backgroundColor: Colors.grey[300],
                        color: primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // To do List
                    const Text("To do List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 15),

                    // List SubTasks
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _task.subTasks.length,
                      itemBuilder: (context, index) {
                        return _buildSubTaskItem(index, _task.subTasks[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS PHỤ ---

  Widget _buildDateLabel(String label, DateTime date, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          DateFormat('d MMM yyyy').format(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Hàm tạo 3 ô đếm ngược
  List<Widget> _buildCountDownBoxes(DateTime endTime) {
    final now = DateTime.now();
    final diff = endTime.difference(now);

    if (diff.isNegative) {
      return [const Text("Expired", style: TextStyle(color: Colors.red))];
    }

    // Tính toán đơn giản (Giả sử 1 tháng = 30 ngày)
    int months = (diff.inDays / 30).floor();
    int days = diff.inDays % 30;
    int hours = diff.inHours % 24;

    return [
      _timeBox(months.toString(), "months"),
      _timeBox(days.toString(), "days"),
      _timeBox(hours.toString(), "hours"),
    ];
  }

  Widget _timeBox(String value, String unit) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF1967D2), // Màu xanh
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            unit,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTaskItem(int index, SubTask subTask) {
    return GestureDetector(
      onTap: () => _toggleSubTask(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5), // Nền trắng mờ
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                subTask.title,
                style: TextStyle(
                  color: const Color(0xFF1967D2),
                  fontWeight: FontWeight.w500,
                  decoration: subTask.isCompleted ? TextDecoration.lineThrough : null, // Gạch ngang nếu xong
                ),
              ),
            ),
            // Custom Radio Button/Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: subTask.isCompleted ? const Color(0xFF1967D2) : Colors.transparent,
                  border: Border.all(
                      color: const Color(0xFF1967D2),
                      width: 2
                  )
              ),
              child: subTask.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
