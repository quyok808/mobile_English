// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Thư viện để format ngày tháng
import 'package:onlya_english/app/themes/theme.dart';
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
        title: Text(
          'Cập nhật thông tin',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.color_appbar,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg-changepass.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white.withOpacity(0.92),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Obx(() {
                    // Load thông tin hiện tại từ controller
                    displayNameController.text = controller.displayName.value;
                    dateOfBirthController.text = controller.dateOfBirth.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Họ và tên:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: displayNameController,
                          decoration:
                              const InputDecoration(hintText: 'Họ và tên'),
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
                            suffixIcon: Icon(Icons.calendar_month),
                          ),
                          onTap: () async {
                            // Hiển thị DatePicker
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              helpText: 'Chọn ngày sinh',
                              locale: const Locale('vi', 'VN'),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: Colors
                                        .blueAccent, // Màu tiêu đề và các nút
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blueAccent, // Màu chính
                                      onSurface: Colors.black, // Màu text
                                    ),
                                    dialogBackgroundColor:
                                        Colors.white, // Màu nền của DatePicker
                                  ),
                                  child: child!,
                                );
                              },
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
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)), // Bo tròn góc
                              elevation: 3,
                              backgroundColor: Colors.yellow,
                            ),
                            child: Text(
                              'Cập nhật',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
