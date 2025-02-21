import 'package:flutter/material.dart';
import '../../models/attendance_stats.dart';

class AttendanceStatsCard extends StatelessWidget {
  final AttendanceStats monthlyStats;
  final AttendanceStats weeklyStats;

  const AttendanceStatsCard({
    Key? key,
    required this.monthlyStats,
    required this.weeklyStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsSection('Monthly Overview', monthlyStats),
            const Divider(height: 32),
            _buildStatsSection('Weekly Overview', weeklyStats),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(String title, AttendanceStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem('Present', stats.presentDays, Colors.green),
            _buildStatItem('Late', stats.lateDays, Colors.orange),
            _buildStatItem('Absent', stats.absentDays, Colors.red),
          ],
        ),
        const SizedBox(height: 16),
        _buildProgressBar(
          'Attendance Rate',
          stats.attendanceRate,
          Colors.blue,
        ),
        const SizedBox(height: 8),
        _buildProgressBar(
          'Punctuality Rate',
          stats.punctualityRate,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${(value * 100).toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}