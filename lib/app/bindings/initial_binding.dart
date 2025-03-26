import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/device_controller.dart';
import '../controllers/map_api_controller.dart';
import '../controllers/user_controller.dart';
import '../services/permission_manager.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    print("InitialBinding executed");
    Get.put<AuthController>(AuthController());
    Get.lazyPut<DeviceController>(() => DeviceController());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<MapApiController>(() => MapApiController());
    Get.put<PermissionManager>(PermissionManager());
    // Get.put<MapApiController>(MapApiController());
  }
}
