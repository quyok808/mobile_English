import 'package:get/get.dart';
import 'package:onlya_english/app/modules/game/controllers/fish_game_controller.dart';


class FishGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FishGameController>(() => FishGameController());
  }
}