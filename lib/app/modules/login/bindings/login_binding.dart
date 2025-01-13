import 'package:get/get.dart';
import 'package:onlya_english/app/modules/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
