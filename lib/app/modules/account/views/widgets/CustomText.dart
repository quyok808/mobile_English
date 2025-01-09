// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Customtext extends StatelessWidget {
  final String NoiDung;

  const Customtext({super.key, required this.NoiDung});

  @override
  Widget build(BuildContext context) {
    return Text(NoiDung,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
        ));
  }
}
