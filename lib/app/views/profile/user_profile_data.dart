import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/user_controller.dart';

class UserDataTab extends StatelessWidget {
  const UserDataTab({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    return FutureBuilder<String?>(
      future: userController.storage.read(key: 'user_id'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user ID found'));
        }

        int userId = int.parse(snapshot.data!);
        userController.fetchProfile(userId);

        return Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userController.userProfile.value == null) {
            return const Center(child: Text('Failed to load profile'));
          }

          final profile = userController.userProfile.value!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profile.image),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard("Name", profile.name, primaryColr),
                  _buildInfoCard(
                    "Personal Email",
                    profile.personalEmail,
                    Colors.green,
                  ),
                  _buildInfoCard(
                    "Company Email",
                    profile.companyEmail,
                    Colors.orange,
                  ),
                  _buildInfoCard("Phone", profile.phone, Colors.purple),
                  _buildInfoCard(
                    "Marital Status",
                    profile.maritalStatus,
                    Colors.red,
                  ),
                  _buildInfoCard("Role", profile.role, Colors.teal),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
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
              color: color,
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
}
