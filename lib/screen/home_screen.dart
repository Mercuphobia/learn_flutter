import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Ẩn nút back
      ),
      body: const Center(
        child: Text(
          'Chào mừng bạn đến với TASK-WAN!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}