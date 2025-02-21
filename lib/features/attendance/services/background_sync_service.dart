import 'dart:async';
import 'dart:io';
import 'package:hive/hive.dart';
import '../models/offline_attendance.dart';
import '../repositories/attendance_repository.dart';
import '../../core/services/logging_service.dart';

class BackgroundSyncService {
  final AttendanceRepository _repository;
  final Duration _syncInterval = const Duration(minutes: 15);
  Timer? _syncTimer;

  BackgroundSyncService({AttendanceRepository? repository})
      : _repository = repository ?? AttendanceRepository();

  void startSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(_syncInterval, (_) => _syncOfflineAttendance());
    _syncOfflineAttendance(); // Initial sync
  }

  void stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> _syncOfflineAttendance() async {
    try {
      final box = await Hive.openBox<OfflineAttendance>('offline_queue');
      
      for (var i = 0; i < box.length; i++) {
        final item = box.getAt(i);
        if (item == null || item.isProcessed) continue;

        final file = File(item.photoPath);
        if (!await file.exists()) {
          LoggingService.logWarning('Photo file not found: ${item.photoPath}');
          continue;
        }

        try {
          await _repository.submitAttendance(
            file,
            item.location,
          );
          
          // Mark as processed and save
          final updatedItem = item.copyWith(isProcessed: true);
          await box.putAt(i, updatedItem);
          LoggingService.logInfo('Successfully synced attendance record');
        } catch (e) {
          LoggingService.logError('Failed to sync attendance: $e');
        }
      }

      // Clean up processed items
      await _cleanupProcessedItems(box);
    } catch (e) {
      LoggingService.logError('Background sync error: $e');
    }
  }

  Future<void> _cleanupProcessedItems(Box<OfflineAttendance> box) async {
    final keys = box.keys.toList();
    for (final key in keys) {
      final item = box.get(key);
      if (item?.isProcessed ?? false) {
        await box.delete(key);
      }
    }
  }
}