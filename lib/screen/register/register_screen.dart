import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 36),
                const Text(
                  'Create to your account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildRegisterForm(context),
                const SizedBox(height: 24),
                _buildSocialLogin(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
  Widget _buildRegisterForm(BuildContext context){
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: "Username",
            prefixIcon: Icon(Icons.person_outlined, color: Colors.blue[600]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Email",
            prefixIcon: Icon(Icons.email_outlined, color: Colors.blue[600]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Icon(Icons.lock_outlined, color: Colors.blue[600]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Confirm Password",
            prefixIcon: Icon(Icons.lock_outlined, color: Colors.blue[600]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 36,
          child: ElevatedButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/verify');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "Register",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSocialLogin(BuildContext context){
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("Or Login With"),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon('assets/images/google.png'),
            const SizedBox(width: 20),
            _socialIcon('assets/images/facebook.png'),
            const SizedBox(width: 20),
            _socialIcon('assets/images/twitter.png'),
          ],
        ),
      ],
    );
  }
  Widget _socialIcon(String path){
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey)
      ),
      child: Image.asset(path, height: 30, width: 30),
    );
  }
}
