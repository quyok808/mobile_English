import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemClassroom extends StatelessWidget {
  ItemClassroom({
    super.key,
    required this.imagelink,
    required this.content,
    required this.path,
  });
  final double size = 50;
  final String imagelink;
  final String content;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 16, right: 16),
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(path);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)), // Bo tròn góc
        ),
        child: Card(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      imagelink,
                      width: size,
                      height: size,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
