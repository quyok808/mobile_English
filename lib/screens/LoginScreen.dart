import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isSignUp = false; // Flag để chuyển giữa đăng nhập và đăng ký

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Lưu thông tin đăng nhập vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', userCredential.user?.email ?? '');

      // Chuyển đến màn hình chính
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Lưu thông tin vào Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': userCredential.user!.email,
        'name': _nameController.text.trim(),
        'avatar':
            'https://static-00.iconduck.com/assets.00/avatar-default-icon-2048x2048-h6w375ur.png', // Đường dẫn avatar mặc định
        'createdAt': DateTime.now(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Đăng ký thành công")));
      _isSignUp = false;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Đăng kí thất bại !!!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            if (_isSignUp)
              Column(
                children: [
                  SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Tên hiển thị'),
                  ),
                ],
              ),
            SizedBox(height: 16),
            _isSignUp
                ? ElevatedButton(
                    onPressed: _signUp,
                    child: Text('Đăng ký'),
                  )
                : ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Đăng nhập'),
                  ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignUp =
                      !_isSignUp; // Chuyển đổi giữa đăng ký và đăng nhập
                });
              },
              child: Text(
                _isSignUp
                    ? 'Đã có tài khoản? Đăng nhập'
                    : 'Chưa có tài khoản? Đăng ký',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
