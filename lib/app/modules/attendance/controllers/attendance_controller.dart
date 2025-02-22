import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/services/attendance_service.dart';
import '../../../data/models/attendance_model.dart';

class AttendanceController extends GetxController {
  final AttendanceService _attendanceService = AttendanceService();
  final isLoading = false.obs;
  final currentPosition = Rx<Position?>(null);
  final selectedImage = Rx<File?>(null);
  final notes = ''.obs;
  
  final checkIn = Rx<AttendanceModel?>(null);
  final checkOut = Rx<AttendanceModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadTodayAttendance();
    _getCurrentLocation();
  }

  Future<void> _loadTodayAttendance() async {
    try {
      isLoading.value = true;
      final result = await _attendanceService.getTodayAttendance();
      
      if (result['success']) {
        checkIn.value = result['checkIn'];
        checkOut.value = result['checkOut'];
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Gagal memuat data absensi',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied) {
          Get.snackbar(
            'Error',
            'Izin lokasi diperlukan untuk melakukan absensi',
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
          return;
        }
      }
      
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mendapatkan lokasi',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil foto',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> submitAttendance(String type) async {
    if (currentPosition.value == null) {
      Get.snackbar(
        'Error',
        'Lokasi tidak tersedia',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    if (selectedImage.value == null) {
      Get.snackbar(
        'Error',
        'Foto wajib diambil',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final result = await _attendanceService.submitAttendance(
        type: type,
        latitude: currentPosition.value!.latitude,
        longitude: currentPosition.value!.longitude,
        photoPath: selectedImage.value!.path,
        notes: notes.value.isNotEmpty ? notes.value : null,
      );

      if (result['success']) {
        Get.snackbar(
          'Sukses',
          'Berhasil melakukan ${type == 'check-in' ? 'check in' : 'check out'}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await _loadTodayAttendance();
        selectedImage.value = null;
        notes.value = '';
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
