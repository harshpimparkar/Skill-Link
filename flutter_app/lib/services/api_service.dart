// services/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:7000/api';
  final SharedPreferences sharedPrefs;

  ApiService({required this.sharedPrefs});

  // Helper method to get headers with auth
  Future<Map<String, String>> _getHeaders() async {
    final token = sharedPrefs.getString('token');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();

    debugPrint('GET request to: $baseUrl/$endpoint');
    debugPrint('Headers: $headers');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      _logResponse(response);
      return response;
    } catch (e) {
      debugPrint('GET request error: $e');
      rethrow;
    }
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    final headers = await _getHeaders();
    final encodedData = json.encode(data);

    debugPrint('POST request to: $baseUrl/$endpoint');
    debugPrint('Headers: $headers');
    debugPrint('Body: $encodedData');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: encodedData,
      );

      _logResponse(response);
      return response;
    } catch (e) {
      debugPrint('POST request error: $e');
      rethrow;
    }
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    final headers = await _getHeaders();

    debugPrint('PUT request to: $baseUrl/$endpoint');
    debugPrint('Headers: $headers');
    debugPrint('Body: $data');

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      _logResponse(response);
      return response;
    } catch (e) {
      debugPrint('PUT request error: $e');
      rethrow;
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();

    debugPrint('DELETE request to: $baseUrl/$endpoint');
    debugPrint('Headers: $headers');

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      _logResponse(response);
      return response;
    } catch (e) {
      debugPrint('DELETE request error: $e');
      rethrow;
    }
  }

  void _logResponse(http.Response response) {
    debugPrint('Response status: ${response.statusCode}');
    if (response.statusCode >= 400) {
      debugPrint('Error response: ${response.body}');
    } else {
      debugPrint('Response body: ${response.body}');
    }
  }
}
