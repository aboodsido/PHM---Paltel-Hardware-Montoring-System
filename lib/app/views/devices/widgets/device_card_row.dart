import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/device_controller.dart';
import 'device_counter_card.dart';

RxBool isOnlineSelected = false.obs;
RxBool isOffLes24Selected = false.obs;
RxBool isOffMore24Selected = false.obs;
final deviceController = Get.find<DeviceController>();
Row buildCardRow() {
  return Row(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            if (isOnlineSelected.value) {
              isOnlineSelected.value = false;
              deviceController.fetchDevicesAPI(isRefreshing: true, status: "");
            } else {
              isOnlineSelected.value = true;
              isOffLes24Selected.value = false;
              isOffMore24Selected.value = false;
              deviceController.fetchDevicesAPI(status: '1');
            }
          },
          child: buildCountCard(
            '${deviceController.onlineDeviceCount} ',
            Colors.green,
            isOnlineSelected.value,
          ),
        ),
      ),
      Expanded(
        child: InkWell(
          onTap: () {
            if (isOffLes24Selected.value) {
              isOffLes24Selected.value = false;
              deviceController.fetchDevicesAPI(status: "");
            } else {
              isOnlineSelected.value = false;
              isOffLes24Selected.value = true;
              isOffMore24Selected.value = false;
              deviceController.fetchDevicesAPI(status: '2');
            }
          },
          child: buildCountCard(
            '${deviceController.offlineShortDeviceCount} ',
            Colors.orangeAccent,
            isOffLes24Selected.value,
          ),
        ),
      ),
      Expanded(
        child: InkWell(
          onTap: () {
            if (isOffMore24Selected.value) {
              isOffMore24Selected.value = false;
              deviceController.fetchDevicesAPI(status: "");
            } else {
              isOnlineSelected.value = false;
              isOffLes24Selected.value = false;
              isOffMore24Selected.value = true;
              deviceController.fetchDevicesAPI(status: '3');
            }
          },
          child: buildCountCard(
            '${deviceController.offlineLongDeviceCount} ',
            Colors.red,
            isOffMore24Selected.value,
          ),
        ),
      ),
    ],
  );
}
