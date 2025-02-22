import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {..._defaultHeaders, ...?headers},
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return responseData;
      } else if (response.statusCode == 401) {
        throw Exception(responseData['message'] ?? 'Unauthorized access');
      } else if (response.statusCode == 403) {
        throw Exception(responseData['message'] ?? 'Access denied');
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please try again later.');
      } else {
        throw Exception(responseData['message'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest error')) {
        throw Exception('CORS Error: Unable to connect to the server. Please ensure CORS is properly configured.');
      } else if (e.toString().contains('Connection refused')) {
        throw Exception('Server Connection Error: Please ensure the server is running.');
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {..._defaultHeaders, ...?headers},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}