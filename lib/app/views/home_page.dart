import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import 'dashboard/dashboard_page.dart';
import 'devices/devices_page.dart';
import 'map/map_page.dart';
import 'more_page.dart';
import 'users/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Updated to 5
    _tabController.addListener(() {
      setState(() {}); // Trigger UI update when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Updated to 5
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 5,
                blurRadius: 20,
                blurStyle: BlurStyle.normal,
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: TabBar(
            indicator: const BoxDecoration(),
            controller: _tabController, // Attach custom TabController
            tabs: [
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/home.svg', // Dashboard icon
                  color: _tabController.index == 0 ? primaryColr : Colors.black,
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/user.svg',
                  color: _tabController.index == 1 ? primaryColr : Colors.black,
                ),
              ),
              Transform.translate(
                offset:
                    const Offset(0, -10), // Move the entire container upwards
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _tabController.index == 2
                            ? primaryColr
                            : Colors.white,
                        width: 1.5),
                    shape: BoxShape.circle,
                    color:
                        _tabController.index == 2 ? Colors.white : primaryColr,
                    boxShadow: [
                      if (_tabController.index == 2)
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.map_outlined, // Map icon
                      color: _tabController.index == 2
                          ? primaryColr
                          : Colors.white, // Dynamic icon color
                      size: 28, // Icon size
                    ),
                  ),
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/device.svg',
                  color: _tabController.index == 3 ? primaryColr : Colors.black,
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/more.svg',
                  color: _tabController.index == 4 ? primaryColr : Colors.black,
                ),
              ),
            ],
            indicatorColor: primaryColr,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DashboardPage(),
            const UsersPage(),
            const MapPage(),
            DevicesPage(),
            const MorePage(),
          ],
        ),
      ),
    );
  }
}
