import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/location_validation_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final LocationValidationService _locationService = LocationValidationService();
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _checkIn() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking location...';
    });

    try {
      final bool isEnabled = await _locationService.isLocationEnabled();
      if (!isEnabled) {
        setState(() {
          _statusMessage = 'Please enable location services';
          _isLoading = false;
        });
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final bool isAccurate = await _locationService.checkLocationAccuracy(position);
      if (!isAccurate) {
        setState(() {
          _statusMessage = 'Location accuracy is too low';
          _isLoading = false;
        });
        return;
      }

      // Example target location (should be fetched from configuration or API)
      final targetLocation = {
        'latitude': -6.175392,  // Example coordinates
        'longitude': 106.827153,
      };

      final result = await _locationService.validateLocation(position, targetLocation);

      setState(() {
        if (result.isValid) {
          _statusMessage = 'Check-in successful!';
        } else if (result.error != null) {
          _statusMessage = 'Error: ${result.error}';
        } else if (result.distance != null) {
          _statusMessage = 'You are ${result.distance!.toStringAsFixed(0)} meters away from the target location';
        } else {
          _statusMessage = 'You are not in the allowed area';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _checkIn,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Check In'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _statusMessage.contains('successful') 
                      ? Colors.green 
                      : _statusMessage.contains('Error') 
                          ? Colors.red 
                          : Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}