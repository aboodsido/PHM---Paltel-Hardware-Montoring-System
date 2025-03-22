import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

AppBar customAppBar({required String title}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () {
          Get.toNamed(AppRoutes.SETTINGS);
        },
        icon: const Icon(Icons.settings_outlined),
      )
    ],
  );
}
