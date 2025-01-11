import 'package:get/get.dart';
import '../../../../services/listening_service.dart';

class ListeningController extends GetxController {
  final ListeningService _service = ListeningService();
  var lessons = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLessons();
  }

  void loadLessons() async {
    isLoading.value = true;
    lessons.value = await _service.getLessons();
    isLoading.value = false;
  }
}
