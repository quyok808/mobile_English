import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EditProfile.dart';
import 'LoginScreen.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _displayName = 'Nguyễn Văn A'; // Giá trị mặc định
  String _avatarUrl =
      'https://static-00.iconduck.com/assets.00/avatar-default-icon-2048x2048-h6w375ur.png'; // Avatar mặc định

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Hàm lấy tên và avatar người dùng từ Firestore
  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _displayName =
              userDoc['name'] ?? 'Nguyễn Văn A'; // Cập nhật tên hiển thị
          _avatarUrl = userDoc['avatar'] ?? _avatarUrl; // Cập nhật avatar
        });
      }
    }
  }

  // Hàm đăng xuất
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  // Mở màn hình chỉnh sửa thông tin
  void _editUserInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: _displayName,
          currentAvatarUrl: _avatarUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(_avatarUrl), // Hiển thị avatar từ Firestore
              ),
              SizedBox(height: 16),
              Text(
                _displayName, // Hiển thị tên người dùng từ Firestore
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? 'Email chưa có',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _editUserInfo, // Chỉnh sửa thông tin
                child: Text('Cập nhật thông tin'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _signOut(context),
                child: Text('Đăng xuất'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
