import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/Search/bindings/search_binding.dart';
import 'app/modules/Search/views/search_view.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Từ điển Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialBinding: HomeBinding(),
      home: HomeView(),
    );
  }
}
