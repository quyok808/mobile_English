// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text('Trang chủ')),
    Center(child: Text('Khóa Học')),
    Center(child: Text('Game')),
    Center(child: Text('Tài khoản')),
  ];

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "OnlyA English",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.black,
              fontFamily: 'JetBrains Mono',
              fontVariations: const [
                FontVariation('ital', 0),
                FontVariation('wght', 400),
                FontVariation('ital', 1),
                FontVariation('wght', 400)
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              // Gọi phương thức đăng xuất
              await authController.logout();
              // Chuyển hướng về LoginView sau khi đăng xuất
              Get.offAllNamed('/login');
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.blue[200],
            selectedItemColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                label: 'Trang Chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book, color: Colors.black),
                label: 'Khóa Học',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.gamepad,
                  color: Colors.black,
                ),
                label: 'Game',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                ),
                label: 'Tài Khoản',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
