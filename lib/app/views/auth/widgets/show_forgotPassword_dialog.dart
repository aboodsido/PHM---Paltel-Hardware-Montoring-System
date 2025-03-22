import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paltel/app/constants.dart';

import '../../../controllers/auth_controller.dart';

void showForgotPasswordDialog() {
  final controller = Get.find<AuthController>();

  Get.dialog(
    AlertDialog(
      title: const Text("Enter your email to reset the password"),
      content: TextField(
        onChanged: (value) => controller.email.value = value,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          hintText: "example@xyz.com",
          filled: true,
          fillColor: Color.fromRGBO(232, 240, 254, 1),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        TextButton(
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(primaryColr),
          ),
          onPressed: () {
            if (controller.email.value.isEmpty) {
              Get.snackbar(
                'Error',
                'Please enter your email',
                icon: const Icon(Icons.warning, color: Colors.red),
              );
            } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            ).hasMatch(controller.email.value)) {
              Get.snackbar(
                'Error',
                'Please enter a valid email address',
                icon: const Icon(Icons.warning, color: Colors.red),
              );
            } else {
              controller.forgetPassword();
              Get.back();
            }
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}
