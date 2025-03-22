import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants.dart';
import '../../../models/device_model.dart';

Future<dynamic> deviceBottomSheet(Device device) {
  return Get.bottomSheet(
    backgroundColor: Colors.white,
    isDismissible: true,
    isScrollControlled: true,
    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: buildDeviceDetail(
                    title: 'Device Name',
                    value: device.name,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: buildDeviceDetail(
                    title: 'IP Address',
                    value: device.ipAddress,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildDeviceDetail(
                    title: 'Line Code',
                    value: device.lineCode,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: buildDeviceDetail(
                    title: 'Device Type',
                    value: device.deviceType,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildDeviceDetail(
                    title: 'Device Status',
                    value:
                        device.status == '1'
                            ? 'Online'
                            : device.status == '2'
                            ? 'Offline Short Term'
                            : 'Offline Long Term',
                  ),
                ),
              ],
            ),
            if (device.status != '1')
              Row(
                children: [
                  Expanded(
                    child: buildDeviceDetail(
                      title: 'Offline Since',
                      value: device.offlineSince.split('T').first,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: buildDeviceDetail(
                      title: 'Downtime',
                      value: device.downtime,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 5),
            SizedBox(
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(device.latitude),
                      double.parse(device.longitude),
                    ),
                    zoom: 13,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(device.id.toString()),
                      position: LatLng(
                        double.parse(device.latitude),
                        double.parse(device.longitude),
                      ),
                    ),
                  },
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Container buildDeviceDetail({required String title, required String value}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: primaryColr.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,

          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
