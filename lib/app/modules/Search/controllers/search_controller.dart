import 'package:get/get.dart';
import '../../../../services/database_service.dart';

class SearchWordController extends GetxController {
  var results = <dynamic>[].obs;
  var selectedLanguage = 'AV'.obs;

  final DatabaseService _databaseService = Get.put(DatabaseService());

  // Hàm tìm kiếm
  void search(String query) async {
    if (selectedLanguage.value == 'AV') {
      results.value = await _databaseService.searchAV(query);
    } else {
      results.value = await _databaseService.searchVA(query);
    }
  }

  // Thay đổi ngôn ngữ dịch
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
  }
}
