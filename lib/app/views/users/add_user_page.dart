import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

class AddUserPage extends StatefulWidget {
  final String title;
  final String buttonText;
  final Function(Map<String, dynamic>) onSave;

  const AddUserPage({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onSave,
  });

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
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
        print("Image selected: ${pickedFile.path}");
      } else {
        print("No image selected.");
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

  Widget _buildDropdown(String label, List<dynamic> items,
      Function(dynamic) onChanged, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        DropdownButtonFormField<dynamic>(
          value: value,
          items: items
              .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item.toString())))
              .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Select Role"),
        DropdownButtonFormField<dynamic>(
          value: selectedRoleId,
          items: roles
              .map((role) => DropdownMenuItem(
                  value: role['id'], child: Text(role['name'])))
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
    return Center(
      child: GestureDetector(
        onTap: pickImage,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              selectedImage != null ? FileImage(selectedImage!) : null,
          child: selectedImage == null
              ? const Icon(Icons.add_a_photo, color: Colors.white, size: 30)
              : null,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: primaryColr,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
              "email_frequency": controllers['emailFrequency']!.text,
              "address": controllers['address']!.text,
              "image": selectedImage?.path ?? "",
            };
            widget.onSave(userData);
            Get.back();
          } else {
            Get.snackbar(
                "Validation Error", "Please fill all fields correctly.");
          }
        },
        child: Text(
          widget.buttonText,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  bool _validateFields() {
    return controllers.values
            .every((controller) => controller.text.isNotEmpty) &&
        selectedMaritalStatus != null &&
        selectedRoleId != null &&
        selectedReceiveEmails != null;
  }
}
