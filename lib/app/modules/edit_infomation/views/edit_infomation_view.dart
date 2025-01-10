import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Thư viện để format ngày tháng
import '../controllers/edit_infomation_controller.dart';

class EditInfomationView extends StatelessWidget {
  final EditInfomationController controller =
      Get.put(EditInfomationController());

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final List<String> genders = ['Nam', 'Nữ', 'Khác'];

  EditInfomationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Cập nhật thông tin',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Load thông tin hiện tại từ controller
          displayNameController.text = controller.displayName.value;
          dateOfBirthController.text = controller.dateOfBirth.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Họ và tên:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(hintText: 'Họ và tên'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ngày sinh:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: dateOfBirthController,
                readOnly: true, // Không cho nhập tay
                decoration: const InputDecoration(
                  hintText: 'Chọn ngày sinh',
                ),
                onTap: () async {
                  // Hiển thị DatePicker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    // Format ngày sinh
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    dateOfBirthController.text = formattedDate;
                    controller.dateOfBirth.value = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Giới tính:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: controller.sex.value.isNotEmpty
                    ? controller.sex.value
                    : null, // Giá trị hiện tại
                items: genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.sex.value = value;
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Chọn giới tính',
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.dialog(
                      Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );
                    controller.updateUserInfo(
                      displayNameController.text,
                      dateOfBirthController.text,
                      controller.sex.value,
                    );
                  },
                  child: const Text('Cập nhật'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
