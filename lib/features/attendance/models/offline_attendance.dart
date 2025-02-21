import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';

@HiveType(typeId: 2)
class OfflineAttendance extends HiveObject {
  @HiveField(0)
  final String photoPath;

  @HiveField(1)
  final Position location;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final bool isProcessed;

  OfflineAttendance({
    required this.photoPath,
    required this.location,
    required this.timestamp,
    this.isProcessed = false,
  });

  OfflineAttendance copyWith({
    String? photoPath,
    Position? location,
    DateTime? timestamp,
    bool? isProcessed,
  }) {
    return OfflineAttendance(
      photoPath: photoPath ?? this.photoPath,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      isProcessed: isProcessed ?? this.isProcessed,
    );

    return OfflineAttendance(
      photoPath: photoPath ?? this.photoPath,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      isProcessed: isProcessed ?? this.isProcessed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo_path': photoPath,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'accuracy': location.accuracy,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// Generate the Hive adapter in a separate file