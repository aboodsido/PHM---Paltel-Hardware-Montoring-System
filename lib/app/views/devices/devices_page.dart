import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/device_controller.dart';
import '../../services/body_top_edge.dart';
import '../../services/custom_appbar.dart';
import '../../services/list_shimmer_loading.dart';
import '../../services/permission_manager.dart';
import 'add_device_page.dart';
import 'widgets/device_bottom_sheet_widget.dart';
import 'widgets/device_card_row.dart';
import 'widgets/pagination_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/trailing_actions_device.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final DeviceController deviceController = Get.find();

  final TextEditingController searchController = TextEditingController();

  final RxString searchQuery = ''.obs;

  final PermissionManager permissionManager = Get.find<PermissionManager>();

  String? status;

  @override
  void initState() {
    super.initState();
    // Check if a status filter was passed via Get.arguments.
    final args = Get.arguments;

    if (args != null && args['status'] != null) {
      status = args['status'];
    }
    // If a status is provided, fetch with that filter; otherwise, fetch all devices.
    if (status != null) {
      deviceController.fetchDevicesAPI(status: status);
    } else {
      deviceController.refreshDevices();
    }
  }

  @override
  void dispose() {
    deviceController.currentFilter.value = null;
    deviceController.currentSearchQuery.value = null;
    deviceController.refreshDevices();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Devices'),
      body: Container(
        decoration: bodyTopEdge(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SearchBarWidget(
                searchController: searchController,
                searchQuery: searchQuery,
                onChanged: (query) {
                  searchQuery.value = query.toLowerCase();
                  deviceController.fetchDevicesAPI(searchQuery: query);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Obx(() => buildCardRow()),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Devices',
                style: TextStyle(
                  color: primaryColr,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (deviceController.isLoading.value) {
                  return listShimmerLoading(75);
                } else if (deviceController.devices.isEmpty) {
                  return const Center(
                    child: Text(
                      'No devices found.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      deviceController.refreshDevices();
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      itemCount: deviceController.devices.length,
                      itemBuilder: (context, index) {
                        final device = deviceController.devices[index];
                        return GestureDetector(
                          onTap: () => deviceBottomSheet(device),
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 10),
                            color: const Color.fromARGB(241, 243, 243, 249),
                            child: ListTile(
                              leading: buildDeviceIdBadge(
                                device.id,
                                device.status == '1'
                                    ? Colors.green
                                    : device.status == '2'
                                    ? Colors.orangeAccent
                                    : Colors.red,
                              ),
                              title: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      device.name,
                                      style: const TextStyle(
                                        color: primaryColr,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'IP: ${device.ipAddress}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                "${device.lineCode}      Type: ${device.deviceType}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: buildTrailingActions(device.id),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
            paginationWidget(deviceController: deviceController),
          ],
        ),
      ),
      floatingActionButton:
          permissionManager.hasPermission('ADD_DEVICE')
              ? FloatingActionButton(
                backgroundColor: primaryColr,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Get.to(const AddDevicePage());
                },
              )
              : null,
    );
  }

  Widget buildDeviceIdBadge(int id, Color color) {
    return CircleAvatar(radius: 7, backgroundColor: color);
  }
}
