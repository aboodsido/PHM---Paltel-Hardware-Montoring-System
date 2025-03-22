import 'package:get/get.dart';

import '../views/devices/devices_page.dart';
import '../views/home_page.dart';
import '../views/auth/login_page.dart';
import '../views/more_page.dart';
import '../views/profile/profile_page.dart';
import '../views/map/settings_page.dart';
import '../views/splash_page.dart';
import '../views/users/users_page.dart';

class AppRoutes {
  static const SPLASH = '/Splash';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const MORE = '/more';
  static const DEVICES = '/devices';
  static const USERS = '/users';
  static const SETTINGS = '/settings';
  static const DASHBOARD = '/dashboard';
  static const PROFILE = '/profile';

  static final routes = [
    GetPage(name: SPLASH, page: () => SplashPage()),
    GetPage(name: LOGIN, page: () => LoginPage()),
    GetPage(name: HOME, page: () => const HomePage()),
    GetPage(
      name: DEVICES,
      page: () => DevicesPage(),
    ),
    GetPage(name: USERS, page: () => const UsersPage()),
    GetPage(name: SETTINGS, page: () => const SettingsPage()),
    GetPage(name: MORE, page: () => const MorePage()),
    GetPage(name: PROFILE, page: () => const ProfilePage()),
  ];
}
