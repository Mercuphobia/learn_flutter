import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/task/task_model.dart';
import '../../screen/task/bloc/task_bloc.dart';
import '../../screen/task/bloc/task_state.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int _selectedYear = DateTime.now().year; // Mặc định chọn năm nay

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        // 1. LẤY DỮ LIỆU TỪ CUBIT
        List<Task> allTasks = [];
        state.whenOrNull(loaded: (tasks) => allTasks = tasks);

        // 2. TÍNH TOÁN DỮ LIỆU CHO NĂM ĐANG CHỌN
        // Lọc task của năm đang chọn
        final yearTasks = allTasks.where((t) => t.startTime.year == _selectedYear).toList();

        // Tổng số task trong năm
        final totalTasksYear = yearTasks.length;
        // Tổng số task đã xong trong năm
        final completedTasksYear = yearTasks.where((t) => t.isCompleted).length;

        // 3. TÍNH TOÁN DỮ LIỆU CHI TIẾT 12 THÁNG
        List<Map<String, dynamic>> monthlyStats = List.generate(12, (index) {
          final monthIndex = index + 1; // Tháng 1 -> 12

          // Lọc task của tháng này
          final monthTasks = yearTasks.where((t) => t.startTime.month == monthIndex).toList();

          final total = monthTasks.length;
          final completed = monthTasks.where((t) => t.isCompleted).length;

          // Tính % (Tránh chia cho 0)
          final double percent = total == 0 ? 0.0 : (completed / total);

          return {
            'month': DateFormat('MMMM').format(DateTime(0, monthIndex)), // Lấy tên tháng (January,...)
            'percent': percent,
            'total': total, // Lưu thêm để debug nếu cần
          };
        });

        return Scaffold(
          backgroundColor: primaryBlue,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.arrow_back, color: primaryBlue, size: 20),
                        ),
                      ),
                      const Expanded(
                        child: Text("Statistic", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // --- BODY ---
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: bgPink,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // YEAR SELECTOR (Chọn năm để xem lại lịch sử)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => setState(() => _selectedYear--),
                                icon: const Icon(Icons.arrow_back_ios, size: 16)
                            ),
                            Text("$_selectedYear", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                                onPressed: () => setState(() => _selectedYear++),
                                icon: const Icon(Icons.arrow_forward_ios, size: 16)
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // SUMMARY CARDS (Số liệu thật)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              _buildSummaryCard("Total Tasks", "$totalTasksYear"),
                              const SizedBox(width: 20),
                              _buildSummaryCard("Completed Tasks", "$completedTasksYear"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // GRID MONTHS (Biểu đồ thật)
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: monthlyStats.length,
                            itemBuilder: (context, index) {
                              final item = monthlyStats[index];
                              final double percent = item['percent'];

                              return Column(
                                children: [
                                  Text(item['month'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Vòng tròn nền (màu xám nhạt)
                                        SizedBox(
                                          width: 100, height: 100,
                                          child: CircularProgressIndicator(
                                            value: 1.0,
                                            strokeWidth: 8,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[300]!),
                                          ),
                                        ),
                                        // Vòng tròn tiến độ (màu xanh - dữ liệu thật)
                                        SizedBox(
                                          width: 100, height: 100,
                                          child: CircularProgressIndicator(
                                            value: percent, // Giá trị từ 0.0 đến 1.0
                                            strokeWidth: 8,
                                            strokeCap: StrokeCap.round,
                                            valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
                                          ),
                                        ),
                                        // Số % ở giữa
                                        Text(
                                          "${(percent * 100).toInt()}%",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 10),
            Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}