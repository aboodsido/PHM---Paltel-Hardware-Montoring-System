import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/device_controller.dart';
import '../../models/device_model.dart';

class UpdateDevicePage extends StatefulWidget {
  final Device device;

  const UpdateDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  _UpdateDevicePageState createState() => _UpdateDevicePageState();
}

class _UpdateDevicePageState extends State<UpdateDevicePage> {
  final DeviceController deviceController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController lineCodeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController deviceTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values from the device passed into the page
    nameController.text = widget.device.name;
    ipController.text = widget.device.ipAddress;
    lineCodeController.text = widget.device.lineCode;
    latitudeController.text = widget.device.latitude.toString();
    longitudeController.text = widget.device.longitude.toString();
    deviceTypeController.text = widget.device.deviceType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Device"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Collect updated data in the correct structure
              Map<String, dynamic> updatedDeviceData = {
                "name": nameController.text,
                "ip_address": ipController.text,
                "line_code": lineCodeController.text,
                "latitude": double.tryParse(latitudeController.text) ?? 0.0,
                "longitude": double.tryParse(longitudeController.text) ?? 0.0,
                "device_type": deviceTypeController.text,
              };

              // Update the device via the controller
              deviceController.updateDevice(
                  widget.device.id.toString(), updatedDeviceData);

              // Go back to the previous page after updating
              Get.back();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Device Name"),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(232, 240, 254, 1),
                ),
              ),
              const SizedBox(height: 10),
              const Text("IP Address"),
              TextField(
                controller: ipController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(232, 240, 254, 1),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Line Code"),
              TextField(
                controller: lineCodeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(232, 240, 254, 1),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Latitude"),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: latitudeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(232, 240, 254, 1),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Longitude"),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: longitudeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(232, 240, 254, 1),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Device Type"),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: deviceTypeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(232, 240, 254, 1),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: primaryColr,
                ),
                onPressed: () {
                  // Collect updated data in the correct structure
                  Map<String, dynamic> updatedDeviceData = {
                    "name": nameController.text,
                    "ip_address": ipController.text,
                    "line_code": lineCodeController.text,
                    "latitude": double.tryParse(latitudeController.text) ?? 0.0,
                    "longitude":
                        double.tryParse(longitudeController.text) ?? 0.0,
                    "device_type": deviceTypeController.text,
                  };

                  // Call the update function from the controller
                  deviceController.updateDevice(
                      widget.device.id.toString(), updatedDeviceData);

                  // Go back to the previous page after saving
                  Get.back();
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
