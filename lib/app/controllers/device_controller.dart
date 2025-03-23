import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/device_model.dart';

class DeviceController extends GetxController {
  var devices = <Device>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var perPage = 10.obs;
  var isLoading = false.obs;
  var totalDevices = 0.obs;
  var onlineDeviceCount = 0.obs;
  var offlineShortDeviceCount = 0.obs;
  var offlineLongDeviceCount = 0.obs;
  var totalDeviceCount = 0.obs;

  // New reactive filter (null means no filter)
  RxnString currentFilter = RxnString();
  RxnString currentSearchQuery = RxnString();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> fetchDevicesAPI({
    bool isRefreshing = false,
    String? status,
    String? searchQuery,
  }) async {
    if (isLoading.value) return;

    if (status != null) {
      currentFilter.value = status;
      currentPage.value = 1;
    }
    if (searchQuery != null) {
      currentSearchQuery.value = searchQuery;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
    });

    try {
      String? authToken = await storage.read(key: 'auth_token');
      if (authToken == null) {
        Get.snackbar("Error", "No token found, please login again");
        return;
      }

      String filterQuery =
          (currentFilter.value != null && currentFilter.value!.isNotEmpty)
              ? "&status=${currentFilter.value}"
              : "";
      String searchQueryParam =
          (searchQuery != null && searchQuery.isNotEmpty)
              ? "&q=$searchQuery"
              : "";

      final url = Uri.parse(
        '$baseUrl/devices/list?page=${currentPage.value}$filterQuery$searchQueryParam',
      );

      final headers = {
        "Authorization": "Bearer $authToken",
        'Accept-Encoding': 'gzip, deflate, br',
        "Content-Type": "application/json",
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final devicesData = jsonData['data']['data'];

        if (isRefreshing) {
          devices.clear();
        }

        devices.clear();
        devices.addAll(
          devicesData
              .map((device) => Device.fromJson(device))
              .toList()
              .cast<Device>(),
        );

        totalDevices.value = jsonData['data']['total_records'];

        currentPage.value = jsonData['data']['current_page'];
        lastPage.value = (totalDevices.value / perPage.value).ceil();
      } else {
        Get.snackbar("Error", "Failed to fetch devices");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (currentPage.value < lastPage.value) {
      currentPage.value++;

      fetchDevicesAPI(
        isRefreshing: true,
        searchQuery: currentSearchQuery.value,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value = currentPage.value - 1;
      fetchDevicesAPI(
        isRefreshing: true,
        searchQuery: currentSearchQuery.value,
      );
    }
  }

  void refreshDevices() {
    currentPage.value = 1;
    fetchDevicesAPI(
      isRefreshing: true,
      status: currentFilter.value,
      searchQuery: currentSearchQuery.value,
    );
  }

  Future<void> fetchDeviceCountByStatus() async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken == null) {
        return;
      }

      final url = Uri.parse('$baseUrl/dashboard/statistics');
      final headers = {
        "Authorization": "Bearer $authToken",
        'Accept-Encoding': 'gzip, deflate, br',
        "Content-Type": "application/json",
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        onlineDeviceCount.value = jsonData['data']['online_count'] ?? 0;
        offlineShortDeviceCount.value =
            jsonData['data']['offline_short_term_count'] ?? 0;
        offlineLongDeviceCount.value =
            jsonData['data']['offline_long_term_count'] ?? 0;
        totalDeviceCount.value = jsonData['data']['total_count'] ?? 0;
      } else {
        Get.snackbar("Error", "Failed to fetch device statistics");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> addDevice(Map<String, dynamic> newDeviceData) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/devices/add'),
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
          body: json.encode(newDeviceData),
        );
        final responseBody = json.decode(response.body);
        final message = responseBody['message'].toString();

        if (response.statusCode == 200) {
          if (responseBody['success']) {
            Get.snackbar("Success", message);
            fetchDevicesAPI(isRefreshing: true);
          } else {
            Get.snackbar("Failed", message);
          }
        } else {
          Get.snackbar("Error", "Failed to add device.");
        }
      } else {
        // Get.snackbar("Error", "No token found, please login again.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> updateDevice(
    String deviceId,
    Map<String, dynamic> updatedDeviceData,
  ) async {
    try {
      // Get the token from secure storage
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken != null) {
        final response = await http.post(
          Uri.parse("$baseUrl/devices/edit/$deviceId"),
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
          body: json.encode(updatedDeviceData),
        );

        if (response.statusCode == 200) {
          Get.snackbar("Success", "Device updated successfully");
          // Refresh the devices list after the update
          fetchDevicesAPI(isRefreshing: true);
        } else {
          Get.snackbar("Error", "Failed to update device");
        }
      } else {
        // Get.snackbar("Error", "No token found, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken != null) {
        final response = await http.post(
          Uri.parse("$baseUrl/devices/delete/$deviceId"),
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          Get.snackbar("Success", "Device deleted successfully");
          // Refresh the devices list after deletion
          fetchDevicesAPI(isRefreshing: true);
        } else {
          Get.snackbar("Error", "Failed to delete device");
        }
      } else {
        // Get.snackbar("Error", "No token found, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
