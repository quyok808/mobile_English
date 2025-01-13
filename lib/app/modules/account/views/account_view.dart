// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:onlya_english/app/modules/account/views/widgets/infomation_widget.dart';

import 'widgets/button_management.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Thông tin tài khoản',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 215,
                color: Colors.blue,
                child: InfomationWidget(),
              ),
              Expanded(
                child: Container(), // mục đích chỉ để mở rộng màn hình
              )
            ],
          ),
          Positioned(
            top: 170, // Đẩy Container trắng lên 50px vào Container trên
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height -
                  190, // Đặt chiều cao cụ thể
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), // Bo góc trên bên trái
                  topRight: Radius.circular(50), // Bo góc trên bên phải
                ),
              ),
              child: ListManagement(),
            ),
          ),
        ],
      ),
    );
  }
}
