import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';

class LocationValidationResult {
  final bool isValid;
  final double? distance;
  final String? error;

  LocationValidationResult({required this.isValid, this.distance, this.error});
}

class LocationValidationService {
  static const double _defaultRadius = 100.0; // meters
  final _logger = Logger('LocationValidationService');

  Future<LocationValidationResult> validateLocation(Position userLocation, Map<String, double> targetLocation) async {
    try {
      // Validate input parameters
      if (!targetLocation.containsKey('latitude') || !targetLocation.containsKey('longitude')) {
        return LocationValidationResult(
          isValid: false,
          error: 'Invalid target location coordinates',
        );
      }

      // Calculate distance between user and target location
      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        targetLocation['latitude']!,
        targetLocation['longitude']!,
      );

      // Check if user is within allowed radius
      return LocationValidationResult(
        isValid: distance <= _defaultRadius,
        distance: distance,
      );
    } catch (e) {
      // Log error with relevant details while protecting sensitive data
      _logger.warning('Location validation error: ${e.toString()} - Validation failed for coordinates check');
      return LocationValidationResult(
        isValid: false,
        error: 'Failed to validate location',
      );
    }
  }

  Future<bool> checkLocationAccuracy(Position position) async {
    // Verify if location accuracy is within acceptable range
    const double maxAcceptableAccuracy = 50.0; // meters
    return position.accuracy <= maxAcceptableAccuracy;
  }

  Future<bool> isLocationEnabled() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      return permission != LocationPermission.deniedForever;
    } catch (e) {
      _logger.warning('Location service error: ${e.toString()}');
      return false;
    }
  }
}