// lib/controllers/theme_controller.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  var isDarkMode = false.obs;

  @override
  void onInit() {
    isDarkMode.value = _loadThemeFromBox();
    super.onInit();
  }

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _box.write(_key, value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}