import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task/task_model.dart';
import '../../screen/task/bloc/task_bloc.dart';
import '../../screen/task/bloc/task_state.dart';
import '../../screen/task/edit_task_screen.dart';


class UiDesign extends StatelessWidget {
  final Task task;
  const UiDesign({super.key, required this.task});


  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {

        // Logic tìm task mới nhất
        Task currentTask = task;
        state.whenOrNull(loaded: (tasks) {
          final found = tasks.where((t) => t.id == task.id);
          if (found.isNotEmpty) {
            currentTask = found.first;
          }
        });

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
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title & Icon
                          Row(
                            children: [
                              const Icon(Icons.language, color: primaryBlue, size: 28),
                              const SizedBox(width: 10),
                              Text(
                                currentTask.title.length > 15
                                    ? "${currentTask.title.substring(0, 15)}..."
                                    : currentTask.title,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryBlue
                                ),
                              ),
                            ],
                          ),

                          // Action Buttons (Edit & Close)
                          Row(
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => EditTaskScreen(task: currentTask),
                              //       ),
                              //     );
                              //   },
                              //   // Thêm phần hiển thị Icon Edit
                              //   child: Container(
                              //     padding: const EdgeInsets.all(8),
                              //     decoration: const BoxDecoration(
                              //       color: Colors.white, // Nền trắng cho nổi bật
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Icon(Icons.edit, color: primaryBlue, size: 20),
                              //   ),
                              // ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditTaskScreen(task: currentTask),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.edit, color: primaryBlue, size: 20),
                                ),
                              ),


                              const SizedBox(width: 10),

                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Date Labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDateLabel("start", currentTask.startTime),
                          _buildDateLabel("end", currentTask.endTime, isEnd: true),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Countdown Boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _buildCountDownBoxes(currentTask.endTime),
                      ),
                    ],
                  ),
                ),

                // --- SCROLLABLE CONTENT ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          currentTask.description,
                          style: TextStyle(color: Colors.grey[600], height: 1.5),
                        ),
                        const SizedBox(height: 25),

                        // Progress Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("${currentTask.progress}%", style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: currentTask.progress / 100,
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
                          itemCount: currentTask.subTasks.length,
                          itemBuilder: (context, index) {
                            return _buildSubTaskItem(
                                context,
                                currentTask.id,
                                index,
                                currentTask.subTasks[index]
                            );
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
      },
    );
  }

  // --- WIDGETS CON ---

  Widget _buildSubTaskItem(BuildContext context, String taskId, int index, SubTask subTask) {
    return GestureDetector(
      onTap: () {
        context.read<TaskCubit>().toggleSubTask(taskId, index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
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
                  decoration: subTask.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
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

  List<Widget> _buildCountDownBoxes(DateTime endTime) {
    final now = DateTime.now();
    final diff = endTime.difference(now);

    if (diff.isNegative) {
      return [const Text("Expired", style: TextStyle(color: Colors.red, fontSize: 18))];
    }

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
        color: const Color(0xFF1967D2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.padLeft(2, '0'),
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
}