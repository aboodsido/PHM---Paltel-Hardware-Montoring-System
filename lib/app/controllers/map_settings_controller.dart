import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapSettingsController extends GetxController {
  RxString zoomLevel = '10'.obs;
  RxString deviceStatus = 'all'.obs;
  RxString mapLayer = 'road'.obs; // road, satellite, terrain
  RxBool disableDoubleClickZoom = false.obs;
  RxBool showPlaces = true.obs;
  RxBool showCompass = false.obs;
  RxBool showZoomControls = true.obs;

  var isLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();

    ever(zoomLevel, (_) => saveSettings());
    ever(deviceStatus, (_) => saveSettings());
    ever(mapLayer, (_) => saveSettings());
    ever(disableDoubleClickZoom, (_) => saveSettings());
    ever(showPlaces, (_) => saveSettings());
    ever(showCompass, (_) => saveSettings());
    ever(showZoomControls, (_) => saveSettings());
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zoomLevel', zoomLevel.value);
    await prefs.setString('hostStatus', deviceStatus.value);
    await prefs.setString('mapLayer', mapLayer.value);
    await prefs.setBool('disableDoubleClickZoom', disableDoubleClickZoom.value);
    await prefs.setBool('showPlaces', showPlaces.value);
    await prefs.setBool('showCompass', showCompass.value);
    await prefs.setBool('showZoomControls', showZoomControls.value);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    zoomLevel.value = prefs.getString('zoomLevel') ?? '10';
    deviceStatus.value = prefs.getString('hostStatus') ?? 'all';
    mapLayer.value = prefs.getString('mapLayer') ?? 'road';
    disableDoubleClickZoom.value =
        prefs.getBool('disableDoubleClickZoom') ?? false;
    showPlaces.value = prefs.getBool('showPlaces') ?? true;
    showCompass.value = prefs.getBool('showCompass') ?? false;
    showZoomControls.value = prefs.getBool('showZoomControls') ?? false;

    isLoaded.value = true;
  }

  Future<void> resetSettings() async {
    zoomLevel.value = '10';
    deviceStatus.value = 'all';
    mapLayer.value = 'road';
    disableDoubleClickZoom.value = false;
    showPlaces.value = true;
    showCompass.value = false;
    showZoomControls.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored settings
  }
}
