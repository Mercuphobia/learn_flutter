// screens/verification_screen.dart
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart'; // Import thư viện pinput

// 1. Chuyển thành StatefulWidget
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // 2. Biến để lưu mã PIN người dùng nhập
  String _currentPin = "";

  // 3. Hàm để kiểm tra mã PIN
  void _verifyPin(String pin) {
    if (pin == '000000') {
      // Nếu ĐÚNG: Quay về trang Login và xóa hết các trang cũ
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login', // Đi đến màn hình Đăng nhập
            (route) => false, // Xóa tất cả các route trước đó khỏi stack
      );
    } else {
      // Nếu SAI: Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã xác thực không đúng. Vui lòng thử lại.'),
          backgroundColor: Colors.red, // Màu đỏ cho dễ nhận biết
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Style cho ô Pinput
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue.shade600),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[600]),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Verification Code - Task Management",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 40),
                _buildLogo(), // Hàm _buildLogo vẫn ở dưới
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "Verify Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/images/anh.jpg',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "Please enter the verification number\nwe send to your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Pinput(
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    // 4. Cập nhật Pinput
                    onChanged: (pin) {
                      // Cập nhật giá trị pin mỗi khi người dùng gõ
                      _currentPin = pin;
                    },
                    onCompleted: (pin) {
                      // Tự động kiểm tra khi nhập xong 6 số
                      _verifyPin(pin);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't receive a code? "),
                    GestureDetector(
                      onTap: () {
                        // Xử lý gửi lại code
                      },
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // 5. Cập nhật nút "Confirm"
                    onPressed: () {
                      // Kiểm tra mã PIN hiện tại khi bấm nút
                      _verifyPin(_currentPin);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Confirm", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm _buildLogo được di chuyển vào trong class State
  Widget _buildLogo() {
    return Center(
      child: Column(
        children: [
          Text(
            'TASK-WAN',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue[600],
            ),
          ),
          const Text(
            'Management App',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}