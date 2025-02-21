import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class AttendanceModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int userId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String? checkIn;

  @HiveField(4)
  final String? checkOut;

  @HiveField(5)
  final String status;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'check_in': checkIn,
      'check_out': checkOut,
      'status': status,
    };
  }

  factory AttendanceModel.empty() {
    return AttendanceModel(
      id: 0,
      userId: 0,
      date: DateTime.now(),
      status: 'absent',
    );
  }
}