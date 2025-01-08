import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';
import '../detail_page.dart';

class SearchItem extends StatelessWidget {
  final dynamic entry; // AVEntry hoặc VAEntry

  const SearchItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entry.word),
      subtitle: Text(entry.description),
      onTap: () {
        // Mở trang chi tiết
        Get.to(DetailPage(entry: entry));
      },
    );
  }
}