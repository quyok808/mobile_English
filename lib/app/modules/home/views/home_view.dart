// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:onlya_english/app/modules/Search/bindings/search_binding.dart';
import 'package:onlya_english/app/modules/Search/views/search_view.dart';
import 'package:onlya_english/app/modules/account/views/account_view.dart';
import 'package:onlya_english/app/modules/classrooms/bindings/classroom_binding.dart';
import 'package:onlya_english/app/modules/classrooms/view/classroom_view.dart';
import 'package:onlya_english/app/modules/flashcard/bindings/flashcard_binding.dart';
import 'package:onlya_english/app/modules/flashcard/views/flashcard_view.dart';
import 'package:onlya_english/app/modules/listening/bindings/listening_binding.dart';
import 'package:onlya_english/app/modules/listening/views/listening_view.dart';
import '../../../routes/bound_widget.dart';
import '../../../themes/theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BoundWidget(
      binding: SearchBinding(),
      child: SearchView(),
    ),
    BoundWidget(
      binding: ClassroomBinding(),
      child: ClassroomView(),
    ),
    BoundWidget(
      binding: FlashcardBinding(),
      child: FlashcardView(),
    ),
    Center(child: AccountView()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            selectedItemColor: Colors.blue,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
                label: 'Trang Chủ',
                backgroundColor: Colors.white,
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.book, color: Colors.blue),
                label: 'Khóa Học',
                backgroundColor: Colors.white,
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.gamepad,
                  color: Colors.blue,
                ),
                label: 'Flashcards',
                backgroundColor: Colors.white,
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                ),
                label: 'Tài Khoản',
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
