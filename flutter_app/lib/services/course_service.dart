import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import './api_service.dart';

class CourseService {
  final ApiService _apiService;

  CourseService({required ApiService apiService}) : _apiService = apiService;

  // Get all courses (optionally filtered by category)
  Future<List<Map<String, dynamic>>> getAllCourses({String? category}) async {
    try {
      final endpoint = category != null
          ? 'courses?category=${Uri.encodeComponent(category)}'
          : 'courses';

      final response = await _apiService.get(endpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting courses: $e');
      rethrow;
    }
  }

  // Get courses by category
  Future<List<Map<String, dynamic>>> getCoursesByCategory(
      String category) async {
    try {
      final endpoint = 'courses/category/${Uri.encodeComponent(category)}';
      final response = await _apiService.get(endpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting courses by category: $e');
      rethrow;
    }
  }

  // Get course details by ID
  Future<Map<String, dynamic>> getCourseDetails(String courseId) async {
    try {
      final response = await _apiService.get('courses/$courseId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception(
            'Failed to load course details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting course details: $e');
      rethrow;
    }
  }

  // Get lecture details by course ID and lecture ID
  Future<Map<String, dynamic>> getLectureDetails(
      String courseId, String lectureId) async {
    try {
      final response =
          await _apiService.get('courses/$courseId/lectures/$lectureId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception(
            'Failed to load lecture details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting lecture details: $e');
      rethrow;
    }
  }

  // Enroll in a course
  Future<Map<String, dynamic>> enrollInCourse(String courseId) async {
    try {
      final response =
          await _apiService.post('enrollments', {'courseId': courseId});

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to enroll in course');
      }
    } catch (e) {
      debugPrint('Error enrolling in course: $e');
      rethrow;
    }
  }

  // Get all enrolled courses
  Future<List<Map<String, dynamic>>> getEnrolledCourses() async {
    try {
      final response = await _apiService.get('enrollments');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception(
            'Failed to load enrolled courses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting enrolled courses: $e');
      rethrow;
    }
  }

  // Get enrollment details with lecture progress
  Future<Map<String, dynamic>> getEnrollmentDetails(String courseId) async {
    try {
      final response = await _apiService.get('enrollments/$courseId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception(
            'Failed to load enrollment details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting enrollment details: $e');
      rethrow;
    }
  }

  // Update lecture progress
  Future<Map<String, dynamic>> updateLectureProgress(
      String courseId, String lectureId,
      {double? position, bool? completed}) async {
    try {
      final Map<String, dynamic> data = {};
      if (position != null) data['position'] = position;
      if (completed != null) data['completed'] = completed;

      final response = await _apiService.put(
          'enrollments/$courseId/lectures/$lectureId/progress', data);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        throw Exception(
            'Failed to update lecture progress: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating lecture progress: $e');
      rethrow;
    }
  }

  // Update payment status
  Future<Map<String, dynamic>> updatePaymentStatus(String courseId) async {
    try {
      final response =
          await _apiService.put('enrollments/$courseId/payment', {});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception(
            'Failed to update payment status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating payment status: $e');
      rethrow;
    }
  }
}
