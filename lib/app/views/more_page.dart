import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/auth_controller.dart';
import '../services/body_top_edge.dart';
import '../services/custom_appbar.dart';
import '../theme_controller.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final storage = const FlutterSecureStorage();
  String? _userId;
  String? _userEmail;
  String? _firstName;
  String? _middleName;
  String? _lastName;
  String? _userImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    _userId = await storage.read(key: 'user_id');
    _userEmail = await storage.read(key: 'user_email');
    _firstName = await storage.read(key: 'first_name');
    _middleName = await storage.read(key: 'middle_name');
    _lastName = await storage.read(key: 'last_name');
    _userImage = await storage.read(key: 'user_image');

    setState(() {}); // Update the UI with the loaded data
  }

  final AuthController authController = Get.find();

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'More'),
      body: Container(
        decoration: bodyTopEdge(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/profile');
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryColr.withOpacity(.5),
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(_userImage ?? ''),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$_firstName $_middleName $_lastName',
                                    style: const TextStyle(
                                      color: primaryColr,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$_userEmail',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                buildMoreListTile(
                  leadingIcon: const Icon(Icons.info_outlined, size: 27),
                  onTap: () {},
                  title: 'App Information',
                  trailingIcon: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const SizedBox(height: 10),
                buildMoreListTile(
                  leadingIcon: const Icon(Icons.share, size: 27),
                  onTap: () {},
                  title: 'Share App',
                  trailingIcon: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const SizedBox(height: 10),
                buildMoreListTile(
                  leadingIcon: const Icon(Icons.dark_mode, size: 27),
                  onTap: () {},
                  title: 'Dark Mode',
                  trailingIcon: Obx(
                    () => Switch(
                      value: themeController.isDarkMode.value,
                      onChanged: (value) {
                        themeController.toggleTheme(value);
                      },
                      activeColor: primaryColr,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                buildMoreListTile(
                  leadingIcon: const Icon(Icons.logout, size: 27),
                  onTap: () {
                    authController.logout();
                  },
                  title: 'Log Out',
                  trailingIcon: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
                const Spacer(),
                Text(
                  '© ${DateTime.now().year} Abdullah AboSido. All rights reserved.',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card buildMoreListTile({
    required Icon leadingIcon,
    required GestureTapCallback onTap,
    required String title,
    required Widget trailingIcon,
  }) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.titleHeight,
          iconColor: primaryColr,
          leading: leadingIcon,
          onTap: onTap,
          title: Text(
            title,
            style: const TextStyle(color: primaryColr, fontSize: 17),
          ),
          trailing: trailingIcon,
        ),
      ),
    );
  }
}
