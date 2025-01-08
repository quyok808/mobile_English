// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';
// import 'detail_page.dart';
import '../../../middleware/auth/controllers/auth_controller.dart';
import '../controllers/search_controller.dart';
import 'widgets/search_item.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final SearchWordController controller = Get.find<SearchWordController>();
    return Scaffold(
      body: Stack(
        children: [
          // AppBar
          Stack(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/appbar_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                // Sử dụng Positioned để định vị Text
                top: 50, // Khoảng cách từ đỉnh (tùy chỉnh)
                left: 20, // Khoảng cách từ bên trái (tùy chỉnh)
                child: Obx(() {
                  String displayName = authController.displayName ?? 'User';
                  return Column(
                    children: [
                      Text(
                        'Welcome, ',
                        style: AppTheme.literata,
                      ),
                      Text(
                        displayName,
                        style: AppTheme.ChuVietTay,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),

          // Nội dung chính: danh sách kết quả tìm kiếm
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 300), // Chừa khoảng trống phía trên cho khung nổi
              child: controller.results.isNotEmpty // Kiểm tra nếu có kết quả
                  ? ListView.builder(
                      itemCount: controller.results.length,
                      itemBuilder: (context, index) {
                        final entry = controller.results[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0), // Thêm lề
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SearchItem(entry: entry),
                              Divider(
                                color: Color(0xFF1F4529), // Màu divider
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      // Nếu không có kết quả, hiển thị thông báo
                      child: Text(
                        'Không tìm thấy kết quả',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            );
          }),

          // Khung nổi chứa ô tìm kiếm và các nút
          Positioned(
            top:
                200, // Cách trên (đặt trong khoảng giữa AppBar và nội dung chính)
            left: 16, // Cách trái
            right: 16, // Cách phải
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Hai nút chọn chế độ dịch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => TextButton(
                            onPressed: () => controller.changeLanguage('AV'),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  controller.selectedLanguage.value == 'AV'
                                      ? Colors.blue[400]
                                      : Colors.white,
                              foregroundColor:
                                  controller.selectedLanguage.value == 'AV'
                                      ? Colors.white
                                      : Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text('Anh - Việt'),
                          )),
                      const SizedBox(width: 8),
                      Obx(() => TextButton(
                            onPressed: () => controller.changeLanguage('VA'),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  controller.selectedLanguage.value == 'VA'
                                      ? Colors.blue[400]
                                      : Colors.white,
                              foregroundColor:
                                  controller.selectedLanguage.value == 'VA'
                                      ? Colors.white
                                      : Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text('Việt - Anh'),
                          )),
                    ],
                  ),

                  // Ô tìm kiếm
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm từ...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.blue[400]),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      onChanged: (query) => controller.search(query),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
