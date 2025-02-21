import 'package:geolocator/geolocator.dart';

class LocationValidationService {
  static const double _defaultRadius = 100.0; // meters

  Future<bool> validateLocation(Position userLocation, Map<String, double> targetLocation) async {
    try {
      // Calculate distance between user and target location
      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        targetLocation['latitude']!,
        targetLocation['longitude']!,
      );

      // Check if user is within allowed radius
      return distance <= _defaultRadius;
    } catch (e) {
      // Log error and return false for safety
      print('Location validation error: $e');
      return false;
    }
  }

  Future<bool> checkLocationAccuracy(Position position) async {
    // Verify if location accuracy is within acceptable range
    const double maxAcceptableAccuracy = 50.0; // meters
    return position.accuracy <= maxAcceptableAccuracy;
  }

  Future<bool> isLocationEnabled() async {
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
  }
}