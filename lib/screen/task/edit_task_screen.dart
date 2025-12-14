import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../models/task/task_model.dart';
import '../../screen/task/bloc/task_bloc.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _startTime;
  late DateTime _endTime;
  late bool _isPriority;
  late List<SubTask> _subTasks;
  final TextEditingController _subTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 3. Điền dữ liệu cũ vào form khi mở màn hình
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _startTime = widget.task.startTime;
    _endTime = widget.task.endTime;
    _isPriority = widget.task.isPriority;
    _subTasks = List.from(widget.task.subTasks); // Tạo bản sao danh sách để tránh lỗi tham chiếu
  }

  // 4. Hàm xử lý logic Update
  Future<void> _handleUpdateTask() async {
    if (!_formKey.currentState!.validate()) return;

    // Tạo object Task mới với thông tin đã sửa (nhưng giữ nguyên ID cũ)
    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descController.text,
      startTime: _startTime,
      endTime: _endTime,
      isPriority: _isPriority,
      isCompleted: widget.task.isCompleted,
      subTasks: _subTasks,
    );

    // --- QUAN TRỌNG: Gọi Cubit để cập nhật UI & Service ---
    context.read<TaskCubit>().editTask(widget.task.id, updatedTask);
    // -----------------------------------------------------

    if (mounted) Navigator.pop(context); // Quay về màn hình trước
  }

  // Hàm chọn ngày giờ
  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startTime : _endTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1967D2)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => isStart ? _startTime = picked : _endTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return Scaffold(
      backgroundColor: primaryBlue, // Nền xanh chủ đạo cho Header
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- HEADER (Nút Back + Title) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: primaryBlue, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Edit Task",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 45), // Spacer cân đối
                ],
              ),
            ),

            // --- BODY (Phần cong màu hồng) ---
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: bgPink,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- ICON TO & TITLE ---
                        Center(
                          child: Column(
                            children: [
                              const Icon(Icons.design_services, size: 40, color: primaryBlue),
                              const SizedBox(height: 10),
                              Text(
                                _titleController.text.isEmpty ? "Task Name" : _titleController.text,
                                style: const TextStyle(
                                  color: primaryBlue,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // --- DATE PICKERS ---
                        Row(
                          children: [
                            Expanded(child: _buildDatePicker("Start", _startTime, true)),
                            const SizedBox(width: 20),
                            Expanded(child: _buildDatePicker("Ends", _endTime, false)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- TITLE INPUT ---
                        _buildLabel("Title"),
                        TextFormField(
                          controller: _titleController,
                          onChanged: (v) => setState(() {}), // Update UI real-time
                          decoration: _inputStyle("Task Name"),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 20),

                        // --- CATEGORY ---
                        _buildLabel("Category"),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              _buildCategoryBtn("Priority Task", true),
                              _buildCategoryBtn("Daily Task", false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- DESCRIPTION ---
                        _buildLabel("Description"),
                        TextFormField(
                          controller: _descController,
                          maxLines: 5,
                          decoration: _inputStyle("Task description..."),
                        ),
                        const SizedBox(height: 20),

                        // --- TO DO LIST (SUBTASKS) ---
                        if (_isPriority) ...[
                          _buildLabel("To do list"),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _subTaskController,
                                  decoration: _inputStyle("Add new item"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  if (_subTaskController.text.isNotEmpty) {
                                    setState(() {
                                      _subTasks.add(SubTask(title: _subTaskController.text));
                                      _subTaskController.clear();
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: primaryBlue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.add, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          ..._subTasks.map((s) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(s.title)),
                                InkWell(
                                  onTap: () => setState(() => _subTasks.remove(s)),
                                  child: const Icon(Icons.close, color: Colors.redAccent, size: 18),
                                )
                              ],
                            ),
                          )),
                        ],

                        const SizedBox(height: 40),

                        // --- NÚT SAVE ---
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _handleUpdateTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1967D2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        InkWell(
          onTap: () => _pickDate(isStart),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat('MMM-dd-yyyy').format(date),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCategoryBtn(String title, bool val) {
    bool isSelected = _isPriority == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isPriority = val),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1967D2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}


