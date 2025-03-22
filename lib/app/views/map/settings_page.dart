import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/map_settings_controller.dart';
import '../../services/dropdown_list_widget.dart';
import 'settings_container_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MapSettingsController mapSettingsController = Get.put(
      MapSettingsController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              mapSettingsController
                  .resetSettings()
                  .then((_) {
                    Get.snackbar('Success', 'Settings reset successfully.');
                  })
                  .catchError((error) {
                    Get.snackbar('Error', 'error resetting settings: $error');
                  });
            },
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Settings Title
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.map, size: 24, color: primaryColr),
                  SizedBox(width: 8),
                  Text(
                    'Map Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Zoom Setting
              buildSettingContainer(
                description:
                    'The amount of proximity and distance from the points',
                title: 'Zoom',
                child: Obx(
                  () => buildDropdownListWidget(
                    items: List.generate(
                      21,
                      (index) => DropdownMenuItem<String>(
                        value: '$index',
                        child: Text('$index'),
                      ),
                    ),
                    onChanged: (value) {
                      mapSettingsController.zoomLevel.value = value;
                    },
                    value: mapSettingsController.zoomLevel.value.toString(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Select Status Setting
              buildSettingContainer(
                title: 'Select Status',
                description: 'Select the device state that appears on the map',
                child: Obx(
                  () => buildDropdownListWidget(
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('Online')),
                      DropdownMenuItem(
                        value: '2',
                        child: Text('Offline Short Term'),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text('Offline Long Term'),
                      ),
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All Statuses'),
                      ),
                    ],
                    onChanged: (value) {
                      mapSettingsController.deviceStatus.value = value;
                    },
                    value: mapSettingsController.deviceStatus.value.toString(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Select Status Setting
              buildSettingContainer(
                title: 'Map Layer',
                description:
                    'Select the map view mode. Road map for standerd view, Satellite for imagery, or Terrain to see elevation details.',
                child: Obx(
                  () => buildDropdownListWidget(
                    items: const [
                      DropdownMenuItem(value: 'road', child: Text('Road Map')),
                      DropdownMenuItem(
                        value: 'satellite',
                        child: Text('Satellite Map'),
                      ),
                      DropdownMenuItem(
                        value: 'terrain',
                        child: Text('Terrain Map'),
                      ),
                    ],
                    onChanged: (value) {
                      mapSettingsController.mapLayer.value = value;
                    },
                    value: mapSettingsController.mapLayer.value.toString(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Disable Double Click Zoom
              buildSettingContainer(
                description: 'When you click twice, it zooms in on the map',
                title: 'Disable Double Click Zoom',
                child: Obx(
                  () => Switch(
                    value: mapSettingsController.disableDoubleClickZoom.value,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      mapSettingsController.disableDoubleClickZoom.value =
                          value;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Show Places Setting
              buildSettingContainer(
                description:
                    'The ability to see places, their names, and more details about them',
                title: 'Show Places',
                child: Obx(
                  () => Switch(
                    value: mapSettingsController.showPlaces.value,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      mapSettingsController.showPlaces.value = value;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.settings, size: 24, color: primaryColr),
                  SizedBox(width: 8),
                  Text(
                    'Control Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              buildSettingContainer(
                title: 'Show Compass',
                description:
                    'Enable or disable the compass on the map for easier navigation',
                child: Obx(
                  () => Switch(
                    value: mapSettingsController.showCompass.value,
                    activeColor: Colors.blue,
                    onChanged:
                        (value) =>
                            mapSettingsController.showCompass.value = value,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              buildSettingContainer(
                title: 'Show Zoom Controls',
                description:
                    'Enable or disable the zoom controls for the map interface',
                child: Obx(
                  () => Switch(
                    value: mapSettingsController.showZoomControls.value,
                    activeColor: Colors.blue,
                    onChanged:
                        (value) =>
                            mapSettingsController.showZoomControls.value =
                                value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
