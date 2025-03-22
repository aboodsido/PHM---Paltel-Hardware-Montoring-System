import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class PermissionManager extends GetxService {
  final RxList<String> _permissions = <String>[].obs;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _permissionKey = 'user_permissions';

  @override
  void onInit() {
    super.onInit();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    String? storedPermissions = await _storage.read(key: _permissionKey);
    if (storedPermissions != null) {
      List<String> permissionsList =
          List<String>.from(jsonDecode(storedPermissions));
      _permissions.assignAll(permissionsList);
    }
  }

  Future<void> setPermissions(List<String> permissions) async {
    _permissions.assignAll(permissions);
    await _storage.write(key: _permissionKey, value: jsonEncode(permissions));
  }

  bool hasPermission(String permission) {
    return _permissions.contains(permission);
  }

  Future<void> clearPermissions() async {
    _permissions.clear();
    await _storage.delete(key: _permissionKey);
  }
}
