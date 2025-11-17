import 'package:flutter/material.dart';

// 1. Lớp mô hình để chứa dữ liệu cho mỗi trang
class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

// 2. Dữ liệu cho 3 trang
final List<OnboardingContent> contents = [
  OnboardingContent(
    image: 'assets/images/anh.jpg', // Thay bằng ảnh của bạn
    title: 'Easy Time Management',
    description:
    "With this tool, you can easily manage all your task in one place and boost your productivity.",
  ),
  OnboardingContent(
    image: 'assets/images/anh.jpg', // Thay bằng ảnh của bạn
    title: 'Increase Work Effectiveness',
    description:
    "Time management and determination and daily tasks. It will give convenience to your job statistics.",
  ),
  OnboardingContent(
    image: 'assets/images/anh.jpg', // Thay bằng ảnh của bạn
    title: 'Set & Manage Your Goals',
    description:
    "You can manage your goals and keep track of them. Set your goals to achieve them easily.",
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Hàm để điều hướng đến Home
  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. Nút Skip và các dấu chấm
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 56.0, // Chiều cao cố định cho thanh trên
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Các dấu chấm
                  Row(
                    children: List.generate(
                      contents.length,
                          (index) => buildDot(index, context),
                    ),
                  ),
                  // Nút Skip
                  TextButton(
                    onPressed: _navigateToHome,
                    child: const Text(
                      'skip',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            // 2. PageView cho nội dung
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Ảnh minh họa
                        Image.asset(
                          contents[i].image,
                          height: 300, // Điều chỉnh chiều cao nếu cần
                        ),
                        const SizedBox(height: 40),
                        // Tiêu đề
                        Text(
                          contents[i].title,
                          style: textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Mô tả
                        Text(
                          contents[i].description,
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 3. Nút "Get Started"
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Nếu là trang cuối cùng, thì điều hướng đến Home
                    if (_currentPage == contents.length - 1) {
                      _navigateToHome();
                    } else {
                      // Nếu không, chuyển sang trang tiếp theo
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Text của nút thay đổi ở trang cuối
                  child: Text(
                    _currentPage == contents.length - 1
                        ? 'Get Started'
                        : 'Next', // THAY ĐỔI: "Next" cho các trang trước
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget để vẽ các dấu chấm (page indicator)
  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 10,
      width: _currentPage == index ? 20 : 10, // Dấu chấm active dài hơn
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue[600] : Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}