import 'package:get/get.dart';

import '../controllers/edit_infomation_controller.dart';

class EditinfomationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditInfomationController>(() => EditInfomationController());
  }
}
