// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:onlya_english/screens/HomePage.dart';

import 'Account.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePageScreen(),
    Center(child: Text('Khóa Học')),
    Center(child: Text('Game')),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
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
              fontVariations: [
                FontVariation('ital', 0),
                FontVariation('wght', 400),
                FontVariation('ital', 1),
                FontVariation('wght', 400)
              ],
            ),
          ),
        ),
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
