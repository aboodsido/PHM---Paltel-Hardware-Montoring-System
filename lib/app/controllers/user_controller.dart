import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/profile_model.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  var users = <UserModel>[].obs; // Reactive list for user data
  var userProfile = Rxn<ProfileModel>();
  var isLoading = false.obs; // Track loading state
  final storage = const FlutterSecureStorage();

  // Fetch users from API
  Future<void> fetchUsers() async {
    try {
      String? authToken = await storage.read(
          key: 'auth_token'); // Replace with your storage method

      if (authToken == null) {
        // Get.snackbar("Error", "No token found, please login again.");
        return;
      }

      isLoading(true);

      final response = await http.get(
        Uri.parse('$baseUrl/users/list'),
        headers: {
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['data'] as List;
        users.value = data.map((user) => UserModel.fromJson(user)).toList();
      } else {
        Get.snackbar("Error", "Failed to load users");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }

  //Add User
  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken == null) {
        // Get.snackbar("Error", "No token found, please login again.");
        return;
      }

      var uri = Uri.parse('$baseUrl/users/add');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          "Authorization": "Bearer $authToken",
        });

      request.fields['first_name'] = userData["first_name"];
      request.fields['middle_name'] = userData["middle_name"];
      request.fields['last_name'] = userData["last_name"];
      request.fields['personal_email'] = userData["personal_email"];
      request.fields['company_email'] = userData["company_email"];
      request.fields['phone'] = userData["phone"];
      request.fields['marital_status'] = userData["marital_status"] ?? "";
      request.fields['role_id'] = userData["role_id"].toString();
      request.fields['receives_emails'] =
          userData["receives_emails"].toString();
      request.fields['email_frequency_hours'] = userData["email_frequency"];
      request.fields['address'] = userData["address"];

      if (userData["image"]?.isNotEmpty ?? false) {
        var imageFile = File(userData["image"]!);

        request.files
            .add(await http.MultipartFile.fromPath('file', imageFile.path));
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseJson = json.decode(responseBody);
        final message = responseJson['message'].toString();
        final success = responseJson['success'];
        Get.snackbar(success == false ? "Failed" : "Success", message);
        fetchUsers();
      } else {
        Get.snackbar("Error", "Failed to add user: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  // Update User
  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');
      if (authToken == null) {
        return;
      }
      var uri = Uri.parse('$baseUrl/users/edit/$userId');
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          "Authorization": "Bearer $authToken",
        });

      request.fields['first_name'] = userData["first_name"];
      request.fields['middle_name'] = userData["middle_name"];
      request.fields['last_name'] = userData["last_name"];
      request.fields['personal_email'] = userData["personal_email"];
      request.fields['company_email'] = userData["company_email"];
      request.fields['phone'] = userData["phone"];
      request.fields['marital_status'] = userData["marital_status"] ?? "";
      request.fields['role_id'] = userData["role_id"].toString();
      print(
          "Converted receives_emails: ${userData["receives_emails"] == true ? "true" : "false"}");

      request.fields['receives_emails'] =
          userData["receives_emails"] == true ? '1' : '2';

      request.fields['email_frequency_hours'] =
          userData["email_frequency_hours"];
      request.fields['address'] = userData["address"];

      // Only add file upload if a new local image is selected (i.e., the image field does NOT start with "http")
      if (userData["image"] != null &&
          !userData["image"].toString().startsWith("http")) {
        var imageFile = File(userData["image"]);
        request.files
            .add(await http.MultipartFile.fromPath('file', imageFile.path));
      }
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);

      if (response.statusCode == 200) {
        print(responseJson['message']);
        Get.snackbar("Success", responseJson['message']);
        fetchUsers(); // Refresh the users list
      } else {
        Get.snackbar("Error", "Failed to update user: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  // Delete a user
  Future<void> deleteUser(int userId) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken == null) {
        // Get.snackbar("Error", "No token found, please login again.");
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/users/delete/$userId'),
        headers: {
          "Authorization": "Bearer $authToken",
        },
      );

      final responseBody = json.decode(response.body);
      final message = responseBody['message'].toString();

      if (response.statusCode == 200) {
        Get.snackbar("Success", message);
        fetchUsers(); // Refresh the users list after deletion
      } else {
        print(message);
        Get.snackbar("Error", message);
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  // Fetch the user profile data
  Future<void> fetchProfile(int userId) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken == null) {
        // Get.snackbar("Error", "No token found, please login again.");
        return;
      }

      isLoading(true);

      final response = await http.get(
        Uri.parse('$baseUrl/users/profile/$userId'),
        headers: {
          "Authorization": "Bearer $authToken",
        },
      );

      final responseBody = json.decode(response.body);
      final message = responseBody['message'] ?? "Unknown error";

      if (response.statusCode == 200) {
        userProfile.value = ProfileModel.fromJson(responseBody);
        // Get.snackbar("Success", message);
      } else {
        Get.snackbar("Error", message);
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }
}
