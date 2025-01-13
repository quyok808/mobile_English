import 'package:get/get.dart';
import '../controllers/essay_controller.dart';

class EssayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EssayController());
  }
}