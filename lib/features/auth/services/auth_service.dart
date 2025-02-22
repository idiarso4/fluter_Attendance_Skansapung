import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();
  final _client = DioClient();
  
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<void> login(String email, String password) async {
    try {
      final response = await _client.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final userData = response.data['user'];
      
      if (token == null) {
        throw Exception('Invalid server response: missing token');
      }
      
      await Future.wait([
        _storage.write(key: _tokenKey, value: token),
        _storage.write(key: _userKey, value: userData.toString()),
      ]);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Account is locked. Please contact support');
      }
      throw Exception(e.response?.data?['message'] ?? 'Login failed: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    try {
      await _client.post('/api/auth/logout');
    } finally {
      await Future.wait([
        _storage.delete(key: _tokenKey),
        _storage.delete(key: _userKey),
      ]);
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _storage.read(key: _userKey);
    if (userData != null) {
      return Map<String, dynamic>.from(userData as Map);
    }
    return null;
  }
}