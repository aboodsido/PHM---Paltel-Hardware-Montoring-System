import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/map_api_controller.dart';
import '../../controllers/map_settings_controller.dart';
import '../../services/custom_appbar.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;

  final MapApiController mapApiController = Get.find<MapApiController>();
  final MapSettingsController mapSettingsController =
      Get.put(MapSettingsController());

  @override
  void initState() {
    super.initState();
    ever<String>(mapSettingsController.zoomLevel, (newZoom) {
      final zoomValue = double.tryParse(newZoom) ?? 10.0;
      if (_controller != null) {
        _controller?.animateCamera(CameraUpdate.zoomTo(zoomValue));
      }
    });
    mapApiController.loadCustomIcons().then((_) {
      mapApiController.fetchDevices();
    });
  }

  MapType _getMapType(String mapLayer) {
    switch (mapLayer) {
      case 'satellite':
        return MapType.satellite;
      case 'terrain':
        return MapType.terrain;
      default:
        return MapType.normal; // road
    }
  }

  void _togglePlaces(bool show) async {
    if (_controller == null) return;
    if (!show) {
      String style =
          await rootBundle.loadString('assets/map_style_no_poi.json');
      _controller?.setMapStyle(style);
    } else {
      _controller?.setMapStyle(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Map'),
      body: Obx(() {
        if (!mapSettingsController.isLoaded.value) {
          return const Center(child: CircularProgressIndicator());
        }
        _togglePlaces(mapSettingsController.showPlaces.value);

        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
            },
            mapType: _getMapType(mapSettingsController.mapLayer.value),
            initialCameraPosition: CameraPosition(
              target: const LatLng(31.5225, 34.4531),
              zoom: double.parse(mapSettingsController.zoomLevel.value),
            ),
            markers: mapApiController.markers.value,
            zoomGesturesEnabled:
                !mapSettingsController.disableDoubleClickZoom.value,
            zoomControlsEnabled: mapSettingsController.showZoomControls.value,
            compassEnabled: mapSettingsController.showCompass.value,
          ),
        );
      }),
    );
  }
}
