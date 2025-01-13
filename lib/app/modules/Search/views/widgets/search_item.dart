// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';
import '../detail_page.dart';

class SearchItem extends StatelessWidget {
  final dynamic entry; // AVEntry hoặc VAEntry

  const SearchItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    final SearchWordController controller = Get.find<SearchWordController>();
    return ListTile(
      title: Text(entry.word),
      subtitle: Text(entry.description),
      onTap: () {
        controller.addToFlashcard(
          entry.word, // Từ vựng
          entry.description, // Mô tả
          entry.pronounce , // Phát âm (nếu có)
        );
        // Mở trang chi tiết
        Get.to(DetailPage(entry: entry));
      },
    );
  }
}
