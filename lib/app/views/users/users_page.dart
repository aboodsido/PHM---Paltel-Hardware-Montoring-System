import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:paltel/app/services/list_shimmer_loading.dart';

import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';
import '../../services/body_top_edge.dart';
import '../../services/custom_appbar.dart';
import '../../services/permission_manager.dart';
import 'add_user_page.dart';
import 'update_user_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final PermissionManager permissionManager = Get.find<PermissionManager>();
    const storage = FlutterSecureStorage();

    Future<dynamic> deleteUserConfirmationDialog(
      UserController userController,
      UserModel user,
    ) async {
      String? loggedInUserId = await storage.read(key: 'user_id');

      return Get.dialog(
        AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await userController.deleteUser(user.id);
                // Check if the deleted user is the logged-in user
                if (loggedInUserId == user.id.toString()) {
                  await storage.deleteAll();
                  Get.offAllNamed('/login');
                }
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }

    userController.fetchUsers();

    return Scaffold(
      appBar: customAppBar(title: 'Users'),
      body: Container(
        decoration: bodyTopEdge(),
        child: Obx(() {
          if (userController.isLoading.value) {
            return listShimmerLoading(100);
          }
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: userController.users.length,
              itemBuilder: (context, index) {
                final user = userController.users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.image),
                          radius: 30,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user.companyEmail,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.phone,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            if (permissionManager.hasPermission('EDIT_USER'))
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    final userData = {
                                      "id": user.id,
                                      "first_name": user.firstName,
                                      "middle_name": user.middleName,
                                      "last_name": user.lastName,
                                      "personal_email": user.personalEmail,
                                      "company_email": user.companyEmail,
                                      "phone": user.phone,
                                      "marital_status": user.maritalStatus,
                                      "receives_emails": user.receivesEmails,
                                      "email_frequency":
                                          user.emailFrequencyHours,
                                      "address": user.address,
                                      "image": user.image,
                                    };

                                    Get.to(
                                      () => UpdateUserPage(
                                        userData: userData,
                                        onUpdate: (updatedUserData) async {
                                          await userController.updateUser(
                                            user.id,
                                            updatedUserData,
                                          );
                                        },
                                        title: 'Update User Data',
                                        buttonText: 'Update',
                                      ),
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/edit.svg',
                                    width: 17,
                                    height: 17,
                                  ),
                                  tooltip: "Edit User",
                                ),
                              ),
                            const SizedBox(width: 5),
                            if (permissionManager.hasPermission('DELETE_USER'))
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    deleteUserConfirmationDialog(
                                      userController,
                                      user,
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/delete.svg',
                                    width: 17,
                                    height: 17,
                                  ),
                                  tooltip: "Delete User",
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
      floatingActionButton:
          permissionManager.hasPermission('ADD_USER')
              ? FloatingActionButton(
                backgroundColor: const Color(0xFF00A1D3),
                onPressed: () {
                  Get.to(
                    () => AddUserPage(
                      title: "Add New User",
                      buttonText: "Add User",
                      onSave: (userData) async {
                        await userController.addUser(userData);
                      },
                    ),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }
}
