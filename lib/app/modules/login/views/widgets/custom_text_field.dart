// ignore_for_file: prefer_const_constructors, use_super_parameters, no_leading_underscores_for_local_identifiers, avoid_init_to_null, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool suffixIcon_Password;
  final bool obscureText;
  final RxBool? isPasswordVisible;
  final Function()? toggleVisibility;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.suffixIcon_Password,
    this.obscureText = false,
    this.isPasswordVisible,
    this.toggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon_Password
            ? Obx(() {
                return IconButton(
                  icon: Icon(
                    isPasswordVisible!.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: toggleVisibility,
                );
              })
            : null,
      ),
    );
  }
}
