import 'package:get/get.dart';
import 'package:onlya_english/services/flashcard_service.dart';
import '../../../../services/database_service.dart';



class SearchWordController extends GetxController {
  var results = <dynamic>[].obs;
  var selectedLanguage = 'AV'.obs;

  final DatabaseService _databaseService = Get.put(DatabaseService());
  final FlashcardService _flashcardService = FlashcardService();
  

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

  Future<void> addToFlashcard(String word, String description, String pronounce) async {
  await _flashcardService.addFlashcard(word, description, pronounce);
  }
}
