import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';

class DailyDetailScreen extends StatefulWidget {
  final Task task;
  const DailyDetailScreen({super.key, required this.task});

  @override
  State<DailyDetailScreen> createState() => _DailyDetailScreenState();
}

class _DailyDetailScreenState extends State<DailyDetailScreen> {
  final TaskService _taskService = TaskService();
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.isCompleted;
  }

  Future<void> _handleFinish() async {
    // Cập nhật trạng thái thành true (Hoàn thành)
    final updatedTask = widget.task.copyWith(isCompleted: true);
    await _taskService.updateTask(updatedTask);

    setState(() {
      _isCompleted = true;
    });

    // Tùy chọn: Có thể quay về Home luôn hoặc ở lại
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header (Nút Close) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Spacer
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1967D2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  )
                ],
              ),

              // --- Title ---
              Text(
                widget.task.title,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1967D2)
                ),
              ),
              const SizedBox(height: 20),

              // --- Date ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateLabel("start", widget.task.startTime),
                  _buildDateLabel("end", widget.task.endTime, isEnd: true),
                ],
              ),
              const SizedBox(height: 20),

              // --- 2 Ô Countdown (Hours - Minutes) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildCountDownBoxes(),
              ),
              const SizedBox(height: 30),

              // --- Description ---
              const Text("Description", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Text(
                widget.task.description,
                style: const TextStyle(height: 1.5, color: Colors.black87),
              ),

              const Spacer(),

              // --- Nút FINISH to đùng ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isCompleted ? null : _handleFinish, // Nếu xong rồi thì disable nút
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1967D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _isCompleted ? "Completed" : "Finish",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateLabel(String label, DateTime date, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(DateFormat('d MMM yyyy').format(date), style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<Widget> _buildCountDownBoxes() {
    // Logic đếm ngược đơn giản cho daily task
    final now = DateTime.now();
    // Giả sử daily task kết thúc vào cuối ngày hôm nay (23:59) nếu endTime < now
    DateTime target = widget.task.endTime;
    if (target.isBefore(now)) {
      target = DateTime(now.year, now.month, now.day, 23, 59);
    }

    final diff = target.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    return [
      _timeBox(hours.toString(), "hours"),
      const SizedBox(width: 20),
      _timeBox(minutes.toString(), "minutes"),
    ];
  }

  Widget _timeBox(String val, String unit) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF1967D2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          Text(unit, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}