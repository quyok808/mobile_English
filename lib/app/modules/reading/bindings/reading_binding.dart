import 'package:get/get.dart';
import '../controllers/reading_controller.dart';

class ReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadingController>(() => ReadingController());
  }
}
