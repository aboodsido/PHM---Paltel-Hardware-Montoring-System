import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../routes/app_routes.dart';
import '../services/fcm_service.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: storage.containsKey(key: 'auth_token'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lottie/loading_animation.json',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          Future.delayed(const Duration(seconds: 4), () {
            Get.offNamed(AppRoutes.LOGIN);
          });
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
                const Center(
                  child: Text('Welcome!', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          );
        }

        Future.delayed(const Duration(seconds: 4), () {
          Get.offNamed(AppRoutes.HOME);
        });

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
              const Center(
                child: Text('Welcome Again!', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        );
      },
    );
  }
}
