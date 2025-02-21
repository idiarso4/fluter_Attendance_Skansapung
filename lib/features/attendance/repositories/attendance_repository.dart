import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';
import '../models/attendance_model.dart';
import '../models/offline_attendance.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/image_processor.dart';
import '../exceptions/attendance_exception.dart';
import '../../core/services/logging_service.dart';

class AttendanceRepository {
  final DioClient _client;
  final HiveInterface _hive;

  AttendanceRepository({
    DioClient? client,
    HiveInterface? hive,
  }) : _client = client ?? DioClient(),
       _hive = hive ?? Hive;

  Future<void> submitAttendance(File photo, Position location) async {
    try {
      // Process photo for optimal quality and size
      final processedPhoto = await ImageProcessor.processAttendancePhoto(photo);

      // Create form data for API request
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(processedPhoto.path),
        'latitude': location.latitude,
        'longitude': location.longitude,
        'accuracy': location.accuracy,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Send to server
      final response = await _client.post('/api/store-attendance', data: formData);

      // Cache successful attendance locally
      await _saveToLocalCache(response.data);
    } catch (e) {
      // Save to offline queue if request fails
      await _saveToOfflineQueue(photo, location);
      throw AttendanceException('Failed to submit attendance: $e');
    }
  }

  Future<AttendanceModel?> getAttendanceToday() async {
    try {
      final response = await _client.get('/api/get-attendance-today');
      if (response.data['success']) {
        return AttendanceModel.fromJson(response.data['data']['attendance']);
      }
      return null;
    } catch (e) {
      // Check local cache if server request fails
      return _getAttendanceFromCache();
    }
  }

  Future<void> _saveToLocalCache(Map<String, dynamic> data) async {
    final box = await _hive.openBox<AttendanceModel>('attendance');
    await box.add(AttendanceModel.fromJson(data));
  }

  Future<void> _saveToOfflineQueue(File photo, Position location) async {
    final box = await _hive.openBox<OfflineAttendance>('offline_queue');
    await box.add(OfflineAttendance(
      photoPath: photo.path,
      location: location,
      timestamp: DateTime.now(),
    ));
  }

  Future<AttendanceModel?> _getAttendanceFromCache() async {
    final box = await _hive.openBox<AttendanceModel>('attendance');
    final today = DateTime.now();
    return box.values.firstWhere(
      (attendance) => attendance.date.year == today.year &&
                      attendance.date.month == today.month &&
                      attendance.date.day == today.day,
      orElse: () => AttendanceModel.empty(),
    );
  }

  Future<void> syncOfflineAttendance() async {
    final box = await _hive.openBox<OfflineAttendance>('offline_queue');
    for (var item in box.values) {
      try {
        await submitAttendance(
          File(item.photoPath),
          item.location,
        );
        await box.delete(item.key);
      } catch (e) {
        // Log error but continue with next item
        LoggingService.logError('Failed to sync offline attendance: $e');
      }
    }
  }
}