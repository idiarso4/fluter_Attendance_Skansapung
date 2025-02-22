import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio;

  AuthService() : _dio = Dio(BaseOptions(
    baseUrl: 'https://app.sijasmkn1punggelan.org',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    validateStatus: (status) {
      return status! < 500;
    },
    contentType: 'application/json',
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        developer.log('Request: ${options.method} ${options.path}');
        developer.log('Request data: ${options.data}');
        developer.log('Request headers: ${options.headers}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        developer.log('Response: ${response.statusCode}');
        developer.log('Response data: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        developer.log('Error: ${error.message}', error: error);
        return handler.next(error);
      },
    ));
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      developer.log('Attempting login with email: $email');
      
      final response = await _dio.post('/api/login', data: {
        'email': email,
        'password': password,
      });

      developer.log('Login response status: ${response.statusCode}');
      developer.log('Login response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final userData = data['data']['user'];
          final token = data['data']['token'];
          
          final user = UserModel.fromJson(userData);
          
          return {
            'success': true,
            'user': user,
            'token': token,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Login gagal',
          };
        }
      } else if (response.statusCode == 401) {
        developer.log('Unauthorized: ${response.data}');
        return {
          'success': false,
          'message': 'Email atau password salah',
        };
      } else if (response.statusCode == 422) {
        developer.log('Validation error: ${response.data}');
        final errors = response.data['errors'];
        String errorMessage = '';
        if (errors != null) {
          if (errors['email'] != null) {
            errorMessage = errors['email'][0];
          } else if (errors['password'] != null) {
            errorMessage = errors['password'][0];
          }
        }
        return {
          'success': false,
          'message': errorMessage.isNotEmpty ? errorMessage : 'Data yang dimasukkan tidak valid',
        };
      }
      
      developer.log('Unexpected status code: ${response.statusCode}');
      return {
        'success': false,
        'message': 'Terjadi kesalahan pada server',
      };
    } on DioException catch (e) {
      developer.log('DioException: ${e.type}', error: e);
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
      } else if (e.error is SocketException) {
        return {
          'success': false,
          'message': 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda',
        };
      }
      
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat menghubungi server',
      };
    } catch (e) {
      developer.log('Unexpected error', error: e);
      return {
        'success': false,
        'message': 'Terjadi kesalahan yang tidak diketahui',
      };
    }
  }
}
