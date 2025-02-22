import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/attendance_model.dart';
import 'storage_service.dart';

class AttendanceService {
  final Dio _dio;
  final StorageService _storageService;

  AttendanceService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://app.sijasmkn1punggelan.org',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        )),
        _storageService = StorageService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token to request
        final token = _storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> submitAttendance({
    required String type,
    required double latitude,
    required double longitude,
    required String photoPath,
    String? notes,
  }) async {
    try {
      developer.log('Submitting attendance: $type');
      
      // Create form data
      final formData = FormData.fromMap({
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
        if (photoPath.isNotEmpty)
          'photo': await MultipartFile.fromFile(photoPath),
      });

      final response = await _dio.post(
        '/api/attendance/submit',
        data: formData,
      );

      developer.log('Attendance response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return {
            'success': true,
            'message': data['message'],
            'attendance': AttendanceModel.fromJson(data['data']),
          };
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal melakukan absensi',
        };
      }

      return {
        'success': false,
        'message': 'Terjadi kesalahan pada server',
      };
    } on DioException catch (e) {
      developer.log('DioException:', error: e);
      if (e.type == DioExceptionType.connectionTimeout) {
        return {
          'success': false,
          'message': 'Koneksi timeout. Periksa koneksi internet Anda',
        };
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return {
          'success': false,
          'message': 'Server tidak merespon. Coba lagi nanti',
        };
      }
      
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat menghubungi server',
      };
    } catch (e) {
      developer.log('Error submitting attendance:', error: e);
      return {
        'success': false,
        'message': 'Terjadi kesalahan yang tidak diketahui',
      };
    }
  }

  Future<Map<String, dynamic>> getTodayAttendance() async {
    try {
      developer.log('Getting today attendance');
      
      final response = await _dio.get('/api/attendance/today');

      developer.log('Today attendance response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return {
            'success': true,
            'checkIn': data['data']['check_in'] != null
                ? AttendanceModel.fromJson(data['data']['check_in'])
                : null,
            'checkOut': data['data']['check_out'] != null
                ? AttendanceModel.fromJson(data['data']['check_out'])
                : null,
          };
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mendapatkan data absensi',
        };
      }

      return {
        'success': false,
        'message': 'Terjadi kesalahan pada server',
      };
    } on DioException catch (e) {
      developer.log('DioException:', error: e);
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat menghubungi server',
      };
    } catch (e) {
      developer.log('Error getting today attendance:', error: e);
      return {
        'success': false,
        'message': 'Terjadi kesalahan yang tidak diketahui',
      };
    }
  }
}
