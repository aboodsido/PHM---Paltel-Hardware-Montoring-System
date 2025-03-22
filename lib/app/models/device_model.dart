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
      id: json['id'],
      name: json['name'],
      ipAddress: json['ip_address'],
      lineCode: json['line_code'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      deviceType: json['device_type'],
      status: json['status'],
      responseTime: json['response_time'],
      offlineSince: json['offline_since'] ?? "N/A",
      downtime: json['downtime'] ?? "-",
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
