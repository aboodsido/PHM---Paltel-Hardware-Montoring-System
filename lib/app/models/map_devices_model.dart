class MapDevice {
  final int id;
  final String lineCode;
  final String name;
  final String ipAddress;
  final double latitude;
  final double longitude;
  final String deviceType;
  final String status;

  MapDevice({
    required this.id,
    required this.lineCode,
    required this.name,
    required this.ipAddress,
    required this.latitude,
    required this.longitude,
    required this.deviceType,
    required this.status,
  });

  factory MapDevice.fromJson(Map<String, dynamic> json) {
    return MapDevice(
      id: json['id'],
      lineCode: json['line_code'],
      name: json['name'],
      ipAddress: json['ip_address'],
      latitude: double.tryParse(json['latitude'].toString()) ?? 0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0,
      deviceType: json['device_type'],
      status: json['status'],
    );
  }
}
