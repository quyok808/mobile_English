// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String _displayName = 'Quý'; // Giá trị mặc định

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Hàm lấy tên người dùng từ Firestore
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
              userDoc['name'] ?? 'Quý'; // Cập nhật tên hiển thị từ Firestore
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi $_displayName!, How are you today ?',
          style: GoogleFonts.jetBrainsMono(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            height: 1.5, // Set line height to 1.5
          ),
          textAlign: TextAlign.justify, // Centers the text
          softWrap: true, // Enable text wrapping
          overflow:
              TextOverflow.visible, // Ensures the text is visible and wraps
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chào mừng $_displayName!', // Hiển thị tên người dùng trong phần nội dung
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
