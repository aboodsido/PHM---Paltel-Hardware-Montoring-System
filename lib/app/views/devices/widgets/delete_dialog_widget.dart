import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paltel/app/controllers/device_controller.dart';

void showDeleteConfirmationDialog(int deviceId) {
  final deviceController = Get.find<DeviceController>();
  Get.dialog(
    AlertDialog(
      title: const Text("Delete Confirm"),
      content: const Text("Are you sure you want to delete this device?"),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog and do nothing
            Get.back();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            deviceController.deleteDevice(deviceId.toString());
            Get.back();
          },
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
