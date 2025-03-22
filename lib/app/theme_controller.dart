import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;

    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
