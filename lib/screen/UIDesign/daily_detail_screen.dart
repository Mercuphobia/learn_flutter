import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task/task_model.dart';
import '../../screen/task/bloc/task_bloc.dart';

class DailyDetailScreen extends StatelessWidget {
  final Task task;

  const DailyDetailScreen({super.key, required this.task});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
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
                task.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1967D2),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateLabel("Start", task.startTime),
                  _buildDateLabel("End", task.endTime, isEnd: true),
                ],
              ),
              const SizedBox(height: 20),

              // --- Countdown Boxes ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildCountDownBoxes(),
              ),
              const SizedBox(height: 30),

              // --- Description ---
              const Text("Description", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Text(
                task.description,
                style: const TextStyle(height: 1.5, color: Colors.black87),
              ),

              const Spacer(),

              // --- Finish Button ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  // Nếu task đã hoàn thành (isCompleted == true) thì disable nút (null)
                  // Ngược lại thì gọi hàm _handleFinish
                  onPressed: task.isCompleted
                      ? null
                      : () => _handleFinish(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1967D2),
                    disabledBackgroundColor: Colors.grey, // Màu khi nút bị disable
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    task.isCompleted ? "Completed" : "Finish",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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

  // --- LOGIC XỬ LÝ FINISH BẰNG CUBIT ---
  void _handleFinish(BuildContext context) {
    // Gọi hàm toggleTaskCompletion đã viết trong Cubit
    // Hàm này sẽ cập nhật state, lưu xuống máy và UI ở Home sẽ tự đổi màu
    context.read<TaskCubit>().toggleTaskCompletion(task.id);

    Navigator.pop(context);
  }


  Widget _buildDateLabel(String label, DateTime date, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          DateFormat('d MMM yyyy').format(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<Widget> _buildCountDownBoxes() {
    final now = DateTime.now();
    DateTime target = task.endTime;

    // Logic cũ của bạn: Nếu quá hạn hoặc endTime nhỏ hơn hiện tại thì tính tới cuối ngày
    if (target.isBefore(now)) {
      target = DateTime(now.year, now.month, now.day, 23, 59);
    }

    final diff = target.difference(now);
    // Đảm bảo không hiển thị số âm
    final hours = diff.isNegative ? 0 : diff.inHours;
    final minutes = diff.isNegative ? 0 : diff.inMinutes % 60;

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
          Text(
            val.padLeft(2, '0'), // Thêm số 0 đằng trước nếu < 10 (VD: 05)
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(unit, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}