import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

class UpdateUserPage extends StatefulWidget {
  final String title;
  final String buttonText;
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onUpdate;

  const UpdateUserPage({
    super.key,
    required this.title,
    required this.buttonText,
    required this.userData,
    required this.onUpdate,
  });

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  // Controllers
  final controllers = {
    'firstName': TextEditingController(),
    'middleName': TextEditingController(),
    'lastName': TextEditingController(),
    'personalEmail': TextEditingController(),
    'companyEmail': TextEditingController(),
    'phone': TextEditingController(),
    'emailFrequency': TextEditingController(),
    'address': TextEditingController(),
  };

  // State Variables
  File? selectedImage;
  String? selectedMaritalStatus;
  int? selectedRoleId;
  bool? selectedReceiveEmails;

  List<Map<String, dynamic>> roles = [];
  bool isLoadingRoles = true;

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchRoles();
    _fetchAdminDetails(); // Pre-fill fields with existing user data
  }

  // Pre-fill fields with existing user data
  Future<void> _fetchAdminDetails() async {
    try {
      String? authToken = await storage.read(key: 'auth_token');
      if (authToken == null) {
        Get.snackbar("Error", "No token found, please login again.");
        return;
      }
      // Assuming widget.userData contains an 'id' field.
      int userId = widget.userData['id'];
      final response = await http.get(
        Uri.parse('$baseUrl/users/details/$userId'),
        headers: {
          "Authorization": "Bearer $authToken",
        },
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final adminDetails = responseBody["data"];
        setState(() {
          controllers['firstName']!.text = adminDetails['first_name'] ?? '';
          controllers['middleName']!.text = adminDetails['middle_name'] ?? '';
          controllers['lastName']!.text = adminDetails['last_name'] ?? '';
          controllers['personalEmail']!.text =
              adminDetails['personal_email'] ?? '';
          controllers['companyEmail']!.text =
              adminDetails['company_email'] ?? '';
          controllers['phone']!.text = adminDetails['phone'] ?? '';
          // Note: the API returns "email_frequency_hours", so we fill the controller accordingly.
          controllers['emailFrequency']!.text =
              adminDetails['email_frequency_hours'] ?? '';
          controllers['address']!.text = adminDetails['address'] ?? '';
          selectedMaritalStatus = adminDetails['marital_status'] ?? "Single";
          // Convert role_id to int (and ensure a fallback if roles are not yet loaded)
          selectedRoleId = int.tryParse(adminDetails['role_id'].toString()) ??
              (roles.isNotEmpty ? roles.first['id'] : null);
          // Convert receives_emails: if "1" then true, else false.
          selectedReceiveEmails =
              adminDetails['receives_emails'].toString() == "1" ? true : false;
          // For image, the _buildImagePicker will handle showing the existing image.
        });
      } else {
        Get.snackbar(
            "Error", "Failed to load admin details: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar(
          "Error", "An error occurred while fetching admin details: $e");
    }
  }

  Future<void> fetchRoles() async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken == null) {
        Get.snackbar("Error", "No token found, please login again.");
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/roles/list'),
        headers: {
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final rolesData = responseBody['data']['data'] as List;

        setState(() {
          roles = rolesData
              .map((role) => {"id": role['id'], "name": role['name']})
              .toList();
          isLoadingRoles = false;
        });
      } else {
        Get.snackbar("Error", "Failed to load roles: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching roles: $e");
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick an image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildInput("First Name", 'firstName', TextInputType.text),
              _buildInput("Middle Name", 'middleName', TextInputType.text),
              _buildInput("Last Name", 'lastName', TextInputType.text),
              _buildInput("Personal Email", 'personalEmail',
                  TextInputType.emailAddress),
              _buildInput(
                  "Company Email", 'companyEmail', TextInputType.emailAddress),
              _buildInput("Phone Number", 'phone', TextInputType.number),
              _buildDropdown("Select Marital Status", ["Single", "Married"],
                  (value) {
                setState(() {
                  selectedMaritalStatus = value;
                });
              }, selectedMaritalStatus),
              _buildRoleDropdown(),
              _buildDropdown("Receives Emails", [true, false], (value) {
                setState(() {
                  selectedReceiveEmails = value;
                });
              }, selectedReceiveEmails),
              _buildInput("Email Frequency (Hours)", 'emailFrequency',
                  TextInputType.number),
              _buildInput("Address", 'address', TextInputType.streetAddress),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
      String label, String controllerKey, TextInputType inputType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controllers[controllerKey],
          keyboardType: inputType,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<dynamic> items,
    Function(dynamic) onChanged,
    dynamic value,
  ) {
    // Ensure the value exists in the items list
    if (!items.contains(value)) {
      value = items.isNotEmpty ? items.first : null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        DropdownButtonFormField<dynamic>(
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item.toString()),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    if (isLoadingRoles) {
      return const CircularProgressIndicator(); // Show a loader while roles are loading
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Select Role"),
        DropdownButtonFormField<dynamic>(
          value: selectedRoleId ?? roles.first['id'],
          items: roles
              .map((role) => DropdownMenuItem(
                    value: role['id'],
                    child: Text(role['name']),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedRoleId = value;
            });
          },
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: Color.fromRGBO(232, 240, 254, 1),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none),
    );
  }

  Widget _buildImagePicker() {
    // Determine the image provider:
    // If a new image was picked, display that.
    // Otherwise, check if the user data has an image (assumed to be a URL here).
    ImageProvider? imageProvider;
    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!);
    } else if (widget.userData['image'] != null &&
        (widget.userData['image'] as String).isNotEmpty) {
      imageProvider = NetworkImage(widget.userData['image']);
    }

    return Center(
      child: GestureDetector(
        onTap: pickImage,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: imageProvider,
          child: Container(
            margin: const EdgeInsets.only(left: 50, top: 65),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColr,
            ),
            width: 40,
            height: 40,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: primaryColr,
      ),
      onPressed: () {
        if (_validateFields()) {
          final userData = {
            "first_name": controllers['firstName']!.text,
            "middle_name": controllers['middleName']!.text,
            "last_name": controllers['lastName']!.text,
            "personal_email": controllers['personalEmail']!.text,
            "company_email": controllers['companyEmail']!.text,
            "phone": controllers['phone']!.text,
            "marital_status": selectedMaritalStatus,
            "role_id": selectedRoleId,
            "receives_emails": selectedReceiveEmails,
            "email_frequency_hours": controllers['emailFrequency']!.text,
            "address": controllers['address']!.text,
            // If no new image selected, use the prefilled URL from widget.userData
            "image": selectedImage?.path ?? widget.userData['image']?.toString() ?? '',
          };
          widget.onUpdate(userData);
          Get.back();
        } else {
          Get.snackbar("Validation Error", "Please fill all fields correctly.");
        }
      },
      child: Text(widget.buttonText,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  bool _validateFields() {
    return true; // Since all fields are prefilled and updating is optional.
  }
}
