import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wapi/screens/Home.dart';
import 'package:wapi/screens/homme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( GetMaterialApp(
  home: Home(),
  debugShowCheckedModeBanner: false
  ));
}


