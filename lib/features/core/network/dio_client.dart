import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    _dio.options.baseUrl = 'https://api.sijasmkn1punggelan.org';
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };

    // Add certificate validation options
    _dio.options.followRedirects = true;
    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Making request to: ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Received response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('Request error: ${error.message}');
        if (error.response?.statusCode == 401) {
          throw Exception('Unauthorized access. Please login again.');
        } else if (error.response?.statusCode == 404) {
          throw Exception('API endpoint not found. Please check the URL or contact support.');
        }
        return handler.next(error);
      },
    ));
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
          throw Exception('Authentication failed. Please check your credentials.');
        }
        throw Exception(e.response?.data?['message'] ?? 'Request failed: ${e.response?.statusMessage}');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server is not responding. Please try again later.');
      }
      throw Exception('Network request failed: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
          throw Exception('Authentication failed. Please check your credentials.');
        }
        throw Exception(e.response?.data?['message'] ?? 'Request failed: ${e.response?.statusMessage}');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server is not responding. Please try again later.');
      }
      throw Exception('Network request failed: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}