// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // color
  static final lightTheme = ThemeData.light();
  static final darkTheme = ThemeData.dark();
  static final blue = Colors.blue[200];
  static final orange = Color(0xFFF2C18D);
  static final green = Colors.greenAccent[400];
  static final light_blue = Color(0xFFBBEEFA);
  static final purple = Color(0xFF624E88);
  static final light_purple = Color(0xFFB1AFFF);
  static final color_appbar = Color(0xFF5FBDFF);

  //font chữ
  static final lobsterFont =
      GoogleFonts.lobster(fontWeight: FontWeight.bold, fontSize: 24);
  static final jetBrainsMono =
      GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold);
  static final ChuVietTay = GoogleFonts.fleurDeLeah(
      fontSize: 30, color: Colors.red[400], fontWeight: FontWeight.bold);
  static final literata = GoogleFonts.literata(fontSize: 24);
}
