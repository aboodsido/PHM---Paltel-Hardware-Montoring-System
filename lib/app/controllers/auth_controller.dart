import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../services/device_utils.dart';
import '../services/permission_manager.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var forgetPassEmail = ''.obs;
  var password = ''.obs;
  var loginIndicator = false.obs;
  final storage = const FlutterSecureStorage();
  final String loginUrl = '$baseUrl/auth/login';
  final String logoutUrl = '$baseUrl/auth/logout';

  // Login method
  void login() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      loginIndicator.value = true;

      final String deviceId = await DeviceUtils.getDeviceId();
      print("Device ID: $deviceId");
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM Token: $fcmToken");

      Map<String, String> body = {
        'email': email.value,
        'password': password.value,
        'fcm_token': fcmToken ?? '',
        'device_id': deviceId,
      };

      try {
        var response = await http.post(Uri.parse(loginUrl), body: body);

        if (response.body.isNotEmpty) {
          var data = json.decode(response.body);

          if (response.statusCode == 200 && data['data'] != null) {
            String token = data['data']['token'] ?? '';

            await storage.write(key: 'auth_token', value: token);

            final permissions = List<String>.from(
              data['data']['permissions'] ?? [],
            );

            Get.find<PermissionManager>().setPermissions(permissions);

            await writeUserData(data);

            Get.offNamed('/home');
          } else {
            String errorMessage =
                data['message'] ?? 'Login failed. Please try again.';

            Get.snackbar(
              'Error',
              errorMessage,
              icon: const Icon(Icons.warning, color: Colors.red),
            );
          }
        } else {
          Get.snackbar(
            'Error',
            'Server returned an empty response. Please try again later.',
            icon: const Icon(Icons.warning, color: Colors.red),
          );
        }
      } catch (e) {
        if (e.toString().contains("SocketException")) {
          Get.snackbar(
            "No Internet",
            "You are offline. Please check your connection.",
          );
        } else {
          Get.snackbar("Error", "An error occurred: $e");
        }
      } finally {
        loginIndicator.value = false;
      }
    } else {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        icon: const Icon(Icons.warning, color: Colors.red),
      );
    }
  }

  Future<void> writeUserData(data) async {
    await storage.write(
      key: 'user_id',
      value: data['data']['user']?['id']?.toString() ?? '',
    );
    await storage.write(
      key: 'user_email',
      value: data['data']['user']?['company_email'] ?? '',
    );
    await storage.write(
      key: 'first_name',
      value: data['data']['user']?['first_name'] ?? '',
    );
    await storage.write(
      key: 'middle_name',
      value: data['data']['user']?['middle_name'] ?? '',
    );
    await storage.write(
      key: 'last_name',
      value: data['data']['user']?['last_name'] ?? '',
    );
    await storage.write(
      key: 'user_image',
      value: data['data']['user']?['image'] ?? '',
    );
  }

  // Logout method
  void logout() async {
    // Show confirmation dialog before logging out
    Get.dialog(
      AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final deviceId = await DeviceUtils.getDeviceId();
              print(deviceId);
              try {
                var response = await http.post(
                  Uri.parse(logoutUrl),
                  body: {'device_id': deviceId},
                  headers: {
                    "Authorization":
                        "Bearer ${await storage.read(key: 'auth_token')}",
                  },
                );

                if (response.statusCode == 200) {
                  print(response.statusCode);
                  print(response.body);
                  await storage.deleteAll();
                  Get.find<PermissionManager>().clearPermissions();
                  Get.offAllNamed('/login');
                  Get.back();
                } else {
                  print(response.statusCode);
                  print(response.body);
                  Get.snackbar(
                    'Error',
                    'Failed to logout: ${response.statusCode}',
                    icon: const Icon(Icons.error, color: Colors.red),
                  );
                }
              } catch (e) {
                if (e.toString().contains("SocketException")) {
                  Get.snackbar(
                    "No Internet",
                    "You are offline. Please check your connection.",
                  );
                } else {
                  Get.snackbar("Error", "An error occurred: $e");
                }
              }
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void forgetPassword() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forget-password'),
        body: {'email': forgetPassEmail.value},
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'A new password has been sent to your email.',
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
      } else {
        print(response.statusCode);
        print(response.body);
        Get.snackbar(
          'Error',
          'Failed to send new password: ${response.statusCode}',
          icon: const Icon(Icons.error, color: Colors.red),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        icon: const Icon(Icons.error, color: Colors.red),
      );
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    String? authToken = await storage.read(key: 'auth_token');

    final url = Uri.parse('$baseUrl/auth/change-password');
    final headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'old_password': oldPassword,
      'new_password': newPassword,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        Get.snackbar(
          'Success',
          '${jsonData['message']}, Redirecting to Sign In...',
        );
        Future.delayed(const Duration(seconds: 2)).then((value) async {
          await storage.deleteAll();
          Get.find<PermissionManager>().clearPermissions();
          Get.offAllNamed('/login');
        });
      } else {
        Get.snackbar('Error', jsonData['message']);
      }
    } else {
      Get.snackbar('Error', 'Error changing password');
    }
  }
}
