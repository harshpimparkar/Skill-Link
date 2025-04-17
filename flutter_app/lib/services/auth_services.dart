// services/auth_services.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'dart:convert';

class AuthService {
  final ApiService apiService;
  final SharedPreferences sharedPrefs;

  AuthService({
    required this.apiService,
    required this.sharedPrefs,
  });

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = sharedPrefs.getString('token');
    debugPrint('Token found: ${token != null}');

    if (token == null) return false;

    try {
      final response = await apiService.get('auth/me');
      debugPrint('Auth check response code: ${response.statusCode}');
      debugPrint('Auth check response: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Auth check error: $e');
      return false;
    }
  }

  // Login with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      debugPrint('Attempting login for: $email');
      final response = await apiService.post('auth/login', {
        'email': email.trim(),
        'password': password,
      });

      debugPrint('Login response code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveAuthData(data);
        debugPrint('Login successful, token saved');
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body)['error'] ?? 'Login failed';
        debugPrint('Login failed: $error');
        return {'success': false, 'error': error};
      }
    } catch (e) {
      debugPrint('Login exception: $e');
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Register new user
  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    try {
      debugPrint('Attempting registration for: $email');
      final response = await apiService.post('auth/register', {
        'email': email.trim(),
        'password': password,
        'name': name,
      });

      debugPrint('Register response code: ${response.statusCode}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        await _saveAuthData(data);
        debugPrint('Registration successful, token saved');
        return {'success': true, 'data': data};
      } else {
        final responseBody = json.decode(response.body);
        final error = responseBody['error'] ?? 'Registration failed';
        debugPrint('Registration failed: $error');
        return {'success': false, 'error': error};
      }
    } catch (e) {
      debugPrint('Registration exception: $e');
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Logout
  Future<void> logout() async {
    debugPrint('Logging out');
    await sharedPrefs.remove('token');
    await sharedPrefs.remove('userId');
    debugPrint('Logout complete - token and userId removed');
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await apiService.get('auth/me');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      debugPrint('Get current user failed: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('Get current user exception: $e');
      return null;
    }
  }

  // Helper to save auth data
  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    await sharedPrefs.setString('token', data['token']);
    await sharedPrefs.setString('userId', data['userId']);
    debugPrint(
        'Auth data saved - token: ${data['token'].substring(0, 10)}... userId: ${data['userId']}');
  }
}
