// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/av_entry.dart';
import '../models/va_entry.dart';

class DatabaseService {
  Future<Database> initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, 'dict_hh.db');

    if (!await File(dbPath).exists()) {
      final data = await rootBundle.load('assets/database/dict_hh.db');
      final bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes);
    }

    return openDatabase(dbPath);
  }

  Future<List<AVEntry>> searchAV(String query) async {
    if (query.isEmpty) {
      return []; // Trả về danh sách rỗng nếu query rỗng
    }
    final db = await initDatabase();
    final maps = await db.query(
      'av',
      where: 'word LIKE ?',
      whereArgs: ['%$query%'],
    );
    List<AVEntry> results = List.generate(maps.length, (i) {
      return AVEntry.fromMap(maps[i]);
    });

    // Sắp xếp theo độ dài của từ (từ ngắn nhất đến dài nhất)
    results.sort((a, b) => a.word.length.compareTo(b.word.length));
    return results;
  }

  Future<List<VAEntry>> searchVA(String query) async {
    if (query.isEmpty) {
      return []; // Trả về danh sách rỗng nếu query rỗng
    }
    final db = await initDatabase();
    final maps = await db.query(
      'va',
      where: 'word LIKE ?',
      whereArgs: ['%$query%'],
    );

    List<VAEntry> results = List.generate(maps.length, (i) {
      return VAEntry.fromMap(maps[i]);
    });

    // Sắp xếp theo độ dài của từ (từ ngắn nhất đến dài nhất)
    results.sort((a, b) => a.word.length.compareTo(b.word.length));

    return results;
  }
}
