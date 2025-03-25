class Device {
  final int id;
  final String name;
  final String ipAddress;
  final String lineCode;
  final String latitude;
  final String longitude;
  final String deviceType;
  final String status;
  final String responseTime;
  final String offlineSince;
  final String downtime;

  Device({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.lineCode,
    required this.latitude,
    required this.longitude,
    required this.deviceType,
    required this.status,
    required this.responseTime,
    required this.offlineSince,
    required this.downtime,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: int.tryParse(json['device_id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      ipAddress: json['ip_address']?.toString() ?? 'N/A',
      lineCode: json['line_code']?.toString() ?? 'N/A',
      latitude: json['latitude']?.toString() ?? '0.0',
      longitude: json['longitude']?.toString() ?? '0.0',
      deviceType: json['device_type']?.toString() ?? 'N/A',
      status: json['status']?.toString() ?? '0',
      responseTime: json['response_time']?.toString() ?? 'N/A',
      offlineSince: json['offline_since']?.toString() ?? 'N/A',
      downtime: json['downtime']?.toString() ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ip_address': ipAddress,
      'line_code': lineCode,
      'latitude': latitude,
      'longitude': longitude,
      'device_type': deviceType,
      'status': status,
      'response_time': responseTime,
      'offline_since': offlineSince,
      'downtime': downtime,
    };
  }
}
