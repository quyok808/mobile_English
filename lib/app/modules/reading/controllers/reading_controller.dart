import 'package:get/get.dart';
import '../../../../services/reading_service.dart';

class ReadingController extends GetxController {
  final ReadingService _service = ReadingService();
  var readings = [].obs;
  var isLoading = false.obs;

  @override
  void onInit(){
    super.onInit();
    loadReadings();
  }

  void loadReadings() async{
    isLoading.value = true;
    readings.value = await _service.getReadings();
    isLoading.value = false;
  }
}