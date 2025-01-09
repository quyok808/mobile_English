// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/middleware/auth/controllers/auth_controller.dart';
import 'package:onlya_english/app/modules/account/views/widgets/louout_button.dart';
import 'package:onlya_english/app/themes/theme.dart';

import '../../../../../models/CustomUser.dart';
import 'CustomText.dart';

class ListManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.find<AuthController>();
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.light_blue,
                  child: Icon(
                    Icons.email_outlined,
                    size: 30,
                  ),
                ),
                SizedBox(width: 10),
                Customtext(NoiDung: _authController.currentUser.value!.email!),
              ],
            ),
          ),
          //Line 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.light_blue,
                  child: Icon(
                    Icons.cake_outlined,
                    size: 30,
                  ),
                ),
                SizedBox(width: 10),
                Obx(
                  () {
                    final user = _authController.currentUser.value;
                    return user == null
                        ? Customtext(NoiDung: "Không có thông tin")
                        : FutureBuilder<CustomUser?>(
                            future: _authController.getUserInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (snapshot.hasData) {
                                return Customtext(
                                    NoiDung: snapshot.data!.dateOfBirth ??
                                        "Không có thông tin");
                              } else {
                                return Customtext(
                                    NoiDung: "Không có thông tin");
                              }
                            },
                          );
                  },
                )
              ],
            ),
          ),
          //line 3
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.light_blue,
                  child: Icon(
                    Icons.male_outlined,
                    size: 30,
                  ),
                ),
                SizedBox(width: 10),
                Obx(
                  () {
                    final user = _authController.currentUser.value;
                    return user == null
                        ? Customtext(NoiDung: "Không có thông tin")
                        : FutureBuilder<CustomUser?>(
                            future: _authController.getUserInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (snapshot.hasData) {
                                return Customtext(
                                    NoiDung: snapshot.data!.sex ??
                                        "Không có thông tin");
                              } else {
                                return Customtext(
                                    NoiDung: "Không có thông tin");
                              }
                            },
                          );
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: ElevatedButton(
                onPressed: () {},
                child: Customtext(NoiDung: 'Chỉnh sửa thông tin')),
          ),
          LogoutButton(),
        ],
      ),
    );
  }
}
