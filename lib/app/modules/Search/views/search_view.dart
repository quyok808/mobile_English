import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/search_controller.dart';
import 'widgets/search_item.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController homeController =
        Get.put(HomeController()); // Get HomeController
    final SearchWordController controller = Get.find<SearchWordController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // Gọi phương thức làm mới dữ liệu
          await homeController
              .refreshData(); // Lấy lại dữ liệu từ HomeController
          controller.results.clear(); // Xóa kết quả tìm kiếm cũ
        },
        child: Stack(
          children: [
            // AppBar
            Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    // Gọi phương thức làm mới dữ liệu
                    await homeController.refreshData();
                  },
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage('assets/images/appbar_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  child: Obx(() {
                    String displayName = homeController.displayName.value;

                    List<String> words = displayName.split(' '); // Tách các từ
                    List<Widget> lines = [];

                    // Chia các từ thành các nhóm 3 từ mỗi nhóm
                    for (int i = 0; i < words.length; i += 3) {
                      lines.add(Text(
                        words
                            .sublist(
                                i, i + 3 > words.length ? words.length : i + 3)
                            .join(' '),
                        style: AppTheme.ChuVietTay,
                      ));
                    }
                    return Container(
                      // decoration: BoxDecoration(
                      //   gradient: RadialGradient(
                      //     center: Alignment.center, // Bắt đầu từ trung tâm
                      //     radius: 1.5, // Phạm vi của gradient
                      //     colors: [
                      //       Colors.white.withOpacity(0.9), // Đậm dần ở giữa
                      //       Colors.white.withOpacity(0.0), // Trong suốt ở ngoài
                      //     ],
                      //   ),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Căn trái các phần tử trong Column
                          children: [
                            Text(
                              'Welcome, ',
                              style: AppTheme.literata,
                              textAlign: TextAlign.left,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: lines,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            // Nội dung chính: danh sách kết quả tìm kiếm
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(top: 300),
                child: controller.results.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.results.length,
                        itemBuilder: (context, index) {
                          final entry = controller.results[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchItem(entry: entry),
                                Divider(
                                    color: Color(0xFF1F4529), thickness: 0.5),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Không tìm thấy kết quả',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
              );
            }),

            // Floating search bar and action buttons
            Positioned(
              top: 200,
              left: 16,
              right: 16,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm từ...',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.blue[400]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
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
      ),
    );
  }
}
