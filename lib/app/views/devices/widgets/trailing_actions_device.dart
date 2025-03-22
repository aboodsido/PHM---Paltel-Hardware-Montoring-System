import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controllers/device_controller.dart';
import '../update_device_page.dart';
import 'delete_dialog_widget.dart';
import '../../../services/permission_manager.dart';

Widget buildTrailingActions(int id) {
  final PermissionManager permissionManager = Get.find<PermissionManager>();
  final DeviceController deviceController = Get.find();

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (permissionManager.hasPermission('EDIT_DEVICE'))
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            tooltip: 'Edit Device',
            icon: SvgPicture.asset(
              'assets/icons/edit.svg',
              width: 15,
              height: 15,
            ),
            onPressed: () {
              final device = deviceController.devices.firstWhere(
                (device) => device.id == id,
              );
              // Navigate to the Update Device page with the selected device's data
              Get.to(UpdateDevicePage(device: device));
            },
          ),
        ),
      const SizedBox(width: 5),
      if (permissionManager.hasPermission('DELETE_DEVICE'))
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            tooltip: 'Delete Device',
            icon: SvgPicture.asset(
              'assets/icons/delete.svg',
              width: 15,
              height: 15,
            ),
            onPressed: () {
              showDeleteConfirmationDialog(id);
            },
          ),
        ),
    ],
  );
}
