class AttendanceModel {
  final int? id;
  final String userId;
  final String type; // check-in atau check-out
  final DateTime timestamp;
  final String? photo;
  final double latitude;
  final double longitude;
  final String? notes;
  final String status; // pending, approved, rejected
  
  AttendanceModel({
    this.id,
    required this.userId,
    required this.type,
    required this.timestamp,
    this.photo,
    required this.latitude,
    required this.longitude,
    this.notes,
    required this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
      photo: json['photo'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      notes: json['notes'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'photo': photo,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'status': status,
    };
  }
}
