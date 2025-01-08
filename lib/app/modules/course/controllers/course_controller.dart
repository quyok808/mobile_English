import 'package:get/get.dart';

class CourseController extends GetxController {
  var courses = [
    {"title": "Nghe", "description": "Khóa học luyện nghe", "imageUrl": "assets/images/listen.png"},
    {"title": "Nói", "description": "Khóa học luyện nói", "imageUrl": "assets/images/talk.png"},
    {"title": "Đọc", "description": "Khóa học luyện đọc", "imageUrl": "assets/images/read.png"},
    {"title": "Viết", "description": "Khóa học luyện viết", "imageUrl": "assets/images/write.png"},
  ].obs; // Sử dụng .obs để biến danh sách này thành dạng reactive
}
