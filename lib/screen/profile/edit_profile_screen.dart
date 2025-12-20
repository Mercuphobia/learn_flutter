import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user; // Nhận user hiện tại để điền vào form
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers quản lý text
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _emailController;
  late DateTime _dob; // Ngày sinh

  @override
  void initState() {
    super.initState();
    // 1. Điền dữ liệu cũ vào các ô input
    _nameController = TextEditingController(text: widget.user.name);
    _professionController = TextEditingController(text: widget.user.profession);
    _emailController = TextEditingController(text: widget.user.email);
    _dob = widget.user.dateOfBirth;
  }

  // Hàm chọn ngày sinh
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dob,
        firstDate: DateTime(1950), // Cho phép chọn từ năm 1950
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFF1967D2)),
            ),
            child: child!,
          );
        }
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  // Hàm Lưu (Save)
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // 2. Tạo user mới từ dữ liệu đã sửa
      final updatedUser = widget.user.copyWith(
        name: _nameController.text,
        profession: _professionController.text,
        email: _emailController.text,
        dateOfBirth: _dob,
      );

      // TODO: Gọi Cubit để update user vào database ở đây
      // context.read<UserCubit>().updateUser(updatedUser);

      print("Đã lưu: ${updatedUser.name}"); // Test log
      Navigator.pop(context); // Quay về màn hình Profile
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1967D2);
    const Color bgPink = Color(0xFFFFF0F0);

    return Scaffold(
      backgroundColor: primaryBlue, // Nền gốc màu xanh
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
                    child: Text(
                        "My Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ),
                  const SizedBox(width: 40), // Dummy spacer để cân giữa tiêu đề
                ],
              ),
            ),

            // --- BODY (Nền hồng bo góc) ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bgPink,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // --- AVATAR EDIT SECTION ---
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(widget.user.avatarUrl),
                              ),
                              // Nút sửa ảnh nhỏ (hình cái bút)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    // TODO: Mở thư viện ảnh để chọn avatar mới
                                    print("Change Avatar Clicked");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: primaryBlue,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // --- FORM FIELDS ---

                        // 1. Name
                        _buildLabel("Name"),
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputStyle("Enter your name"),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 20),

                        // 2. Profession
                        _buildLabel("Profession"),
                        TextFormField(
                          controller: _professionController,
                          decoration: _inputStyle("Enter profession"),
                        ),
                        const SizedBox(height: 20),

                        // 3. Date of Birth (Click để chọn lịch)
                        _buildLabel("Date of Birth"),
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                                const SizedBox(width: 10),
                                Text(
                                    DateFormat('MMM-dd-yyyy').format(_dob),
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 4. Email
                        _buildLabel("Email"),
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputStyle("Enter email"),
                          validator: (v) => v!.contains("@") ? null : "Invalid email",
                        ),
                        const SizedBox(height: 40),

                        // --- SAVE BUTTON ---
                        SizedBox(
                          width: double.infinity, height: 55,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                            ),
                            child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20), // Padding đáy
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

  // Nhãn màu xanh phía trên ô input
  Widget _buildLabel(String text) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Text(
            text,
            style: const TextStyle(color: Color(0xFF1967D2), fontWeight: FontWeight.bold)
        )
    );
  }

  // Style chung cho các ô nhập liệu (Nền trắng, không viền)
  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    );
  }
}