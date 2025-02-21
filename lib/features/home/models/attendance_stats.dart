import 'package:equatable/equatable.dart';

class AttendanceStats extends Equatable {
  final int totalDays;
  final int presentDays;
  final int lateDays;
  final int absentDays;
  final double attendanceRate;
  final double punctualityRate;

  const AttendanceStats({
    required this.totalDays,
    required this.presentDays,
    required this.lateDays,
    required this.absentDays,
    required this.attendanceRate,
    required this.punctualityRate,
  });

  factory AttendanceStats.empty() {
    return const AttendanceStats(
      totalDays: 0,
      presentDays: 0,
      lateDays: 0,
      absentDays: 0,
      attendanceRate: 0.0,
      punctualityRate: 0.0,
    );
  }

  @override
  List<Object?> get props => [
    totalDays,
    presentDays,
    lateDays,
    absentDays,
    attendanceRate,
    punctualityRate,
  ];
}