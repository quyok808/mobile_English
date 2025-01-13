// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import '../../../../services/listening_service.dart';

class ListeningController extends GetxController {
  final ListeningService _service = ListeningService();
  var lessons = [].obs;
  var isLoading = false.obs;
  RxInt indexQuestion = 1.obs;

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

  int GetIndexQuestion() {
    return indexQuestion.value;
  }

  void countupIndex() {
    indexQuestion++;
  }

  void countdownIndex() {
    indexQuestion--;
  }
}
