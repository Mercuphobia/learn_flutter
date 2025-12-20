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
  bool _isPriorityTab = true;

  // 1. Controller để điều khiển vị trí cuộn của lịch
  final ScrollController _scrollController = ScrollController();

  // 2. Mốc thời gian bắt đầu (Ví dụ: từ năm 2020)
  final DateTime _startDate = DateTime(2020, 1, 1);

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks();

    // 3. Tự động cuộn đến ngày hôm nay khi mở màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToDate(_selectedDate);
    });
  }

  // Hàm tính toán và cuộn dải lịch đến ngày mong muốn
  void _scrollToDate(DateTime date) {
    // Tính số ngày chênh lệch từ mốc bắt đầu
    final int daysDiff = date.difference(_startDate).inDays;

    // Tính toán vị trí pixel (Mỗi ô rộng 60 + margin 12 = 72px)
    // Trừ đi nửa màn hình để ngày chọn nằm chính giữa
    final double offset = (daysDiff * 72.0) - (MediaQuery.of(context).size.width / 2) + 30;

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _showFullCalendar() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1967D2),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // Khi chọn từ lịch to xong -> Cuộn dải lịch bên dưới đến ngày đó
      _scrollToDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        List<Task> allTasks = [];
        state.whenOrNull(loaded: (tasks) => allTasks = tasks);

        return Scaffold(
          backgroundColor: bgPink,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _showFullCalendar,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month, color: primaryBlue),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat('MMM, yyyy').format(_selectedDate),
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.arrow_drop_down, color: primaryBlue),
                            ],
                          ),
                        ),
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

                  _buildCalendarStrip(primaryBlue, allTasks),
                  const SizedBox(height: 25),

                  // TAB SWITCHER
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

                  // LIST VIEW
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final filteredTasks = allTasks.where((task) {
                          final isSameDay = task.startTime.year == _selectedDate.year &&
                              task.startTime.month == _selectedDate.month &&
                              task.startTime.day == _selectedDate.day;
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
                            return _isPriorityTab
                                ? _buildPriorityTaskCard(task, primaryBlue)
                                : _buildDailyTaskCard(task, primaryBlue);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET: Dải lịch ngang (Logic mới: Dùng ScrollController) ---
  Widget _buildCalendarStrip(Color primaryColor, List<Task> allTasks) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        // Gắn controller vào để điều khiển vị trí
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // Tạo ra 5000 ngày (hơn 10 năm) để cuộn thoải mái
        itemCount: 365 * 15,
        itemBuilder: (context, index) {
          // Tính ngày dựa trên mốc cố định _startDate (2020) + index
          final date = _startDate.add(Duration(days: index));

          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          // Đếm số task
          final int taskCount = allTasks.where((t) {
            final isSameDate = t.startTime.year == date.year &&
                t.startTime.month == date.month &&
                t.startTime.day == date.day;
            final isSameType = t.isPriority == _isPriorityTab;
            return isSameDate && isSameType;
          }).length;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
              _scrollToDate(date); // Cuộn mượt đến ngày vừa bấm
            },
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
                  const SizedBox(height: 5),

                  // Chấm hiển thị số lượng
                  if (taskCount > 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        taskCount > 9 ? "9+" : taskCount.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? primaryColor : Colors.white,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 14),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Các Widget phụ giữ nguyên ---
  Widget _buildTabButton(String title, bool isTabPriority, Color color) {
    final bool isActive = _isPriorityTab == isTabPriority;
    return GestureDetector(
      onTap: () => setState(() => _isPriorityTab = isTabPriority),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isActive ? const Color(0xFF0640EC) : Colors.black)),
          const SizedBox(height: 6),
          AnimatedContainer(duration: const Duration(milliseconds: 300), height: 4, width: isActive ? 40 : 0, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10))),
        ],
      ),
    );
  }

  Widget _buildPriorityTaskCard(Task task, Color color) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditPriorityTaskScreen(task: task))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.design_services, color: color), const SizedBox(width: 10), Expanded(child: Text(task.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color))), Icon(Icons.more_horiz, color: Colors.grey[400])]),
            const SizedBox(height: 10),
            Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5)),
            const SizedBox(height: 15),
            Align(alignment: Alignment.centerRight, child: Text("${DateFormat('MMM dd').format(task.startTime)} - ${DateFormat('MMM dd').format(task.endTime)}", style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)))
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTaskCard(Task task, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(children: [Expanded(child: Text(task.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87.withOpacity(0.7))))]),
    );
  }
}