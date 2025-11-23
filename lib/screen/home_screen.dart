import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';
import '../screen/calendar/calendar_screen.dart';
import '../screen/profile/profile_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();

  // 1. Thêm biến để theo dõi Tab hiện tại
  int _selectedIndex = 0;

  List<Task> _priorityTasks = [];
  List<Task> _dailyTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _taskService.initFakeData();
    final tasks = await _taskService.getTasks();
    setState(() {
      _priorityTasks = tasks.where((t) => t.isPriority).toList();
      _dailyTasks = tasks.where((t) => !t.isPriority).toList();
      _isLoading = false;
    });
  }

  // 2. Hàm xử lý khi bấm vào BottomBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình tương ứng với từng tab
    final List<Widget> pages = [
      _buildHomeContent(),
      const CalendarScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: _selectedIndex == 0 ? const Color(0xFFFFF0F0) : Colors.white,

      // 3. Dùng IndexedStack để giữ trạng thái trang Home khi chuyển tab
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- CÁC WIDGET CŨ CỦA BẠN ĐƯỢC GOM VÀO ĐÂY ---
  Widget _buildHomeContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildPrioritySection(),
              const SizedBox(height: 30),
              _buildDailyTaskSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String dateStr = DateFormat('EEEE, MMM d yyyy').format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateStr, style: TextStyle(color: Colors.grey[600])),
            const Icon(Icons.notifications, color: Colors.blue),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Welcome Phillip",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Text(
          "Have a nice day!",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Priority Task",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _priorityTasks.length,
            itemBuilder: (context, index) {
              final task = _priorityTasks[index];
              final colors = [Colors.blue, Colors.deepPurple, Colors.red];
              final color = colors[index % colors.length];
              return _buildPriorityCard(task, color);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityCard(Task task, Color color) {
    final daysLeft = task.endTime.difference(DateTime.now()).inDays;
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$daysLeft days",
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          const Spacer(),
          const Icon(Icons.design_services, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text(
            task.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Progress", style: TextStyle(color: Colors.white70, fontSize: 10)),
              Text("${task.progress}%", style: const TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: task.progress / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          )
        ],
      ),
    );
  }

  Widget _buildDailyTaskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Daily Task",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _dailyTasks.length,
          itemBuilder: (context, index) {
            return _buildDailyTaskItem(_dailyTasks[index]);
          },
        ),
      ],
    );
  }

  Widget _buildDailyTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          InkWell(
            onTap: () async {
              final updated = task.copyWith(isCompleted: !task.isCompleted);
              await _taskService.updateTask(updated);
              _loadData();
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
                color: task.isCompleted ? Colors.blue : Colors.transparent,
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          )
        ],
      ),
    );
  }

  // 4. Cập nhật BottomNavigationBar để nhận sự kiện click
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex, // Xác định tab đang active
      onTap: _onItemTapped,         // Hàm xử lý khi click

      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
      backgroundColor: _selectedIndex == 0 ? const Color(0xFFFFF0F0) : Colors.white,
      selectedItemColor: Colors.blue, // Màu icon khi được chọn
      unselectedItemColor: Colors.grey, // Màu icon khi không được chọn
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}