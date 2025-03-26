import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../routes/app_routes.dart';
import '../services/connectivity_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ConnectivityService connectivityService = ConnectivityService();
  bool? isConnected;
  bool isChecking = true; // To track connection check status

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    bool status = await connectivityService.checkNow();
    setState(() {
      isConnected = status;
      isChecking = false;
    });

    if (status) {
      _navigateToNextScreen();
    }
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    bool hasToken = await storage.containsKey(key: 'auth_token');

    if (hasToken) {
      Get.offNamed(AppRoutes.HOME);
    } else {
      Get.offNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'assets/lottie/loading_animation.json',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
          ),
          const SizedBox(height: 20),
          if (isChecking)
            const Text(
              'Checking internet connection...',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 94, 94, 94),
              ),
            )
          else if (isConnected == false)
            noConnectionWidget()
          else
            const Text('Welcome!', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget noConnectionWidget() {
    return Column(
      children: [
        const Text(
          "No Internet Connection",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isChecking = true;
              _checkConnection();
            });
          },
          child: const Text("Retry"),
        ),
      ],
    );
  }
}
