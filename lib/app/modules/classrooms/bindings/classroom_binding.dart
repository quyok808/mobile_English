import 'package:get/get.dart';
import '../controllers/classroom_controller.dart';

class ClassroomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassroomController>(() => ClassroomController());
  }
}
