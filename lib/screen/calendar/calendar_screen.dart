import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task/task_model.dart';
import '../../screen/task/bloc/task_bloc.dart';
import '../../screen/task/bloc/task_state.dart';
import '../../screen/task/priority_task/add_priority_task_screen.dart';
import '../../screen/task/priority_task/edit_priority_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isPriorityTab = true; // true = Priority Task Tab, false = Daily Task Tab

  @override
  void initState() {
    super.initState();
    // Load lại task khi vào màn hình này để đảm bảo dữ liệu mới nhất
    context.read<TaskCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return Scaffold(
      backgroundColor: bgPink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // --- 1. HEADER (Month + Add Button) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: primaryBlue),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('MMM, yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPriorityTaskScreen()),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Add Task"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // --- 2. WEEK CALENDAR STRIP ---
              _buildCalendarStrip(primaryBlue),
              const SizedBox(height: 25),

              // --- 3. TAB SWITCHER (Priority | Daily) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTabButton("Priority Task", true, primaryBlue),
                    const SizedBox(width: 25),
                    _buildTabButton("Daily Task", false, primaryBlue),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- 4. TASK LIST (BlocBuilder) ---
              Expanded(
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loaded: (allTasks) {
                        // LỌC DỮ LIỆU
                        final filteredTasks = allTasks.where((task) {
                          // 1. Lọc theo ngày
                          final isSameDay = task.startTime.year == _selectedDate.year &&
                              task.startTime.month == _selectedDate.month &&
                              task.startTime.day == _selectedDate.day;

                          // 2. Lọc theo Tab (Priority hay Daily)
                          // Lưu ý: task.isPriority == true (Priority), false (Daily)
                          final isMatchingType = task.isPriority == _isPriorityTab;

                          return isSameDay && isMatchingType;
                        }).toList();

                        if (filteredTasks.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.event_busy, size: 60, color: Colors.grey[400]),
                                const SizedBox(height: 10),
                                Text("No tasks on this day", style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            // Tùy theo Tab mà hiển thị kiểu Card khác nhau
                            return _isPriorityTab
                                ? _buildPriorityTaskCard(task, primaryBlue)
                                : _buildDailyTaskCard(task, primaryBlue);
                          },
                        );
                      },
                      orElse: () => const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET: Dải lịch ngang ---
  Widget _buildCalendarStrip(Color primaryColor) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // Hiển thị 2 tuần (giả lập)
        itemBuilder: (context, index) {
          // Logic ngày: Bắt đầu từ 3 ngày trước
          final date = DateTime.now().subtract(const Duration(days: 3)).add(Duration(days: index));
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: isSelected
                    ? [BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET: Tab Title ---
  Widget _buildTabButton(String title, bool isTabPriority, Color color) {
    final bool isActive = _isPriorityTab == isTabPriority;
    return GestureDetector(
      onTap: () => setState(() => _isPriorityTab = isTabPriority),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.blue : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          // Dấu gạch chân xanh
          AnimatedContainer(
            duration: const Duration(microseconds: 300),
            height: 4,
            width: isActive ? 40 : 0,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD 1: Style cho Priority Task (Chi tiết, có Description) ---
  Widget _buildPriorityTaskCard(Task task, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditPriorityTaskScreen(task: task))
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.design_services, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                Icon(Icons.more_horiz, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${DateFormat('MMM dd').format(task.startTime)} - ${DateFormat('MMM dd').format(task.endTime)}",
                style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- CARD 2: Style cho Daily Task (Đơn giản, gọn nhẹ) ---
  Widget _buildDailyTaskCard(Task task, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87.withOpacity(0.7),
              ),
            ),
          ),
          // Nếu muốn có thể thêm checkbox hoặc giờ ở đây
        ],
      ),
    );
  }
}