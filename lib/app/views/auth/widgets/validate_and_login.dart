import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paltel/app/controllers/auth_controller.dart';

void validateAndLogin() {
  final controller = Get.find<AuthController>();

  String email = controller.email.value.trim();
  String password = controller.password.value.trim();

  // Email validation
  if (email.isEmpty) {
    Get.snackbar(
      'Error',
      'Please enter your email',
      icon: const Icon(Icons.warning, color: Colors.red),
    );
    return;
  }

  if (!RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  ).hasMatch(email)) {
    Get.snackbar(
      'Error',
      'Please enter a valid email address',
      icon: const Icon(Icons.warning, color: Colors.red),
    );
    return;
  }

  // Password validation
  if (password.isEmpty) {
    Get.snackbar(
      'Error',
      'Please enter your password',
      icon: const Icon(Icons.warning, color: Colors.red),
    );
    return;
  }

  if (password.length < 6) {
    Get.snackbar(
      'Error',
      'Password must be at least 6 characters long',
      icon: const Icon(Icons.warning, color: Colors.red),
    );
    return;
  }

  controller.login();
}
