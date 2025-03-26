import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_routes.dart';
import 'app/services/fcm_service.dart';
import 'app/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMService().initialize();
  Get.put(ThemeController());
  runApp(const EttisalatApp());
}

class EttisalatApp extends StatelessWidget {
  const EttisalatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        title: 'Paltel - HM',
        theme: ThemeData(
          textTheme: GoogleFonts.tajawalTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(243, 243, 249, 1),
          ),
        ),
        darkTheme: ThemeData.dark(),
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.SPLASH,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
