import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/device_controller.dart';
import '../../controllers/user_controller.dart';
import '../../services/body_top_edge.dart';
import '../../services/custom_appbar.dart';
import 'dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  final TabController tabController;
  DashboardPage({super.key, required this.tabController});

  final DeviceController deviceController = Get.find();
  final UserController userController = Get.find();

  final RxList<bool> cardVisibility = [false, false, false, false, false].obs;

  void animateCards() {
    Future.delayed(const Duration(milliseconds: 300), () {
      cardVisibility[4] = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      cardVisibility[0] = true;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      cardVisibility[1] = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      cardVisibility[2] = true;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      cardVisibility[3] = true;
    });
  }

  void navigateToDevices(String? status) {
    deviceController.currentPage.value = 1;
    deviceController.fetchDevicesAPI(status: status);
    tabController.animateTo(3);
    // Get.toNamed(AppRoutes.DEVICES, arguments: {'status': status});
  }

  @override
  Widget build(BuildContext context) {
    deviceController.fetchDeviceCountByStatus();
    userController.fetchUsers();
    animateCards();

    return Scaffold(
      appBar: customAppBar(title: 'Dashboard'),
      body: Container(
        decoration: bodyTopEdge(),
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () {
              deviceController.fetchDeviceCountByStatus();
              userController.fetchUsers();
              return Future.value();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: cardVisibility[4] ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: GestureDetector(
                      onTap: () {
                        tabController.animateTo(1);
                      },
                      child: buildCard(
                        title: "USERS",
                        number: "${userController.users.length}",
                        icon: Icons.people_rounded,
                        color: const Color.fromARGB(255, 227, 211, 248),
                        circleColor: const Color.fromARGB(255, 134, 0, 211),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: cardVisibility[0] ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: GestureDetector(
                      onTap: () {
                        navigateToDevices(null);
                      },
                      child: buildCard(
                        title: "DEVICES",
                        number: "${deviceController.totalDeviceCount}",
                        icon: Icons.wifi_rounded,
                        color: const Color(0xFFD8ECF7),
                        circleColor: const Color(0xFF00A1D3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: cardVisibility[1] ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: GestureDetector(
                      onTap: () {
                        navigateToDevices('1');
                      },
                      child: buildCard(
                        title: "ONLINE",
                        number: "${deviceController.onlineDeviceCount}",
                        icon: Icons.wifi_rounded,
                        color: const Color(0xFFE0F8E0),
                        circleColor: const Color(0xFF3CD653),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: cardVisibility[2] ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: GestureDetector(
                      onTap: () {
                        navigateToDevices('2');
                      },
                      child: buildCard(
                        title: "OFFLINE SHORT TERM",
                        number: "${deviceController.offlineShortDeviceCount}",
                        icon: Icons.wifi_off_rounded,
                        color: const Color(0xFFFFEBE4),
                        circleColor: const Color(0xFFFC9375),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: cardVisibility[3] ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: GestureDetector(
                      onTap: () {
                        navigateToDevices('3');
                      },
                      child: buildCard(
                        title: "OFFLINE LONG TERM",
                        number: "${deviceController.offlineLongDeviceCount}",
                        icon: Icons.wifi_off_rounded,
                        color: const Color(0xFFFFE0E5),
                        circleColor: const Color(0xFFF95979),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
