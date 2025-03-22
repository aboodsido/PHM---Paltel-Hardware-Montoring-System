import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/device_controller.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final DeviceController deviceController = Get.find();

  // Controllers for the text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController lineCodeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController deviceTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Device"),
        centerTitle: true,
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
                  if (nameController.text.isNotEmpty &&
                      ipController.text.isNotEmpty &&
                      lineCodeController.text.isNotEmpty &&
                      latitudeController.text.isNotEmpty &&
                      longitudeController.text.isNotEmpty &&
                      deviceTypeController.text.isNotEmpty) {
                    // Collect data from the form
                    Map<String, dynamic> newDeviceData = {
                      "name": nameController.text,
                      "ip_address": ipController.text,
                      "line_code": lineCodeController.text,
                      "latitude":
                          double.tryParse(latitudeController.text) ?? 0.0,
                      "longitude":
                          double.tryParse(longitudeController.text) ?? 0.0,
                      "device_type": deviceTypeController.text,
                    };

                    deviceController.addDevice(newDeviceData);
                    Get.back();
                  } else {
                    Get.snackbar(
                        'Empty Fields!', 'Fill all the fields to add device!');
                  }
                },
                child: const Text(
                  "Add Device",
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
