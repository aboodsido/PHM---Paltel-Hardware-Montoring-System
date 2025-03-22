import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../services/body_top_edge.dart';
import '../../services/custom_appbar.dart';
import 'change_password_page.dart';
import 'user_profile_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Profile'),
      body: Container(
        decoration: bodyTopEdge(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              TabBar(
                dividerHeight: 0,
                controller: _controller,
                indicator: const BoxDecoration(),
                tabs: [
                  Tab(child: _buildTab(label: 'General', tabIndex: 0)),
                  Tab(child: _buildTab(label: 'Change Password', tabIndex: 1)),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: const [UserDataTab(), ChangePasswordTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab({required String label, required int tabIndex}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                _controller.index == tabIndex
                    ? primaryColr
                    : Colors.transparent,
            border: Border.all(
              color:
                  _controller.index == tabIndex
                      ? Colors.transparent
                      : primaryColr,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          child: Text(
            label,
            style: TextStyle(
              color: _controller.index == tabIndex ? Colors.white : primaryColr,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
