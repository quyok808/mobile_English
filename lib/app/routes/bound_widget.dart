// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoundWidget extends StatelessWidget {
  final Bindings? binding;
  final Widget child;

  BoundWidget({required this.child, this.binding});

  @override
  Widget build(BuildContext context) {
    binding?.dependencies();
    return child;
  }
}
