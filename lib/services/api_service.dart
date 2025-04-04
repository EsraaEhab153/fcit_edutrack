import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ApiService {
  // Headers with content type
  Map<String, String> _headers({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Get token from shared preferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Save token to shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Clear token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Register user
  Future<Map<String, dynamic>> register(
      String username, String password, String fullName, String email) async {
    final response = await http.post(
      Uri.parse(Config.registerUrl),
      headers: _headers(),
      body: jsonEncode({
        'username': username,
        'password': password,
        'fullName': fullName,
        'email': email,
      }),
    );

    return jsonDecode(response.body);
  }

  // Verify email
  Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    final response = await http.post(
      Uri.parse(Config.verifyEmailUrl),
      headers: _headers(),
      body: jsonEncode({
        'email': email,
        'code': code,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (responseData['success'] && responseData['data']['token'] != null) {
      await saveToken(responseData['data']['token']);
    }

    return responseData;
  }

  // Login user
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(Config.loginUrl),
      headers: _headers(),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (responseData['success'] && responseData['data']['token'] != null) {
      await saveToken(responseData['data']['token']);
    }

    return responseData;
  }

  // Get all courses
  Future<Map<String, dynamic>> getCourses() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(Config.coursesUrl),
      headers: _headers(token: token),
    );

    return jsonDecode(response.body);
  }

  // Get current courses
  Future<Map<String, dynamic>> getCurrentCourses() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(Config.currentCoursesUrl),
      headers: _headers(token: token),
    );

    return jsonDecode(response.body);
  }

  // Enroll in a course
  Future<Map<String, dynamic>> enrollInCourse(int courseId) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('${Config.enrollUrl}/$courseId'),
      headers: _headers(token: token),
    );

    return jsonDecode(response.body);
  }

  // Record attendance
  Future<Map<String, dynamic>> recordAttendance(
      int courseId, String networkIdentifier, String verificationMethod) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse(Config.recordAttendanceUrl),
      headers: _headers(token: token),
      body: jsonEncode({
        'courseId': courseId,
        'networkIdentifier': networkIdentifier,
        'verificationMethod': verificationMethod,
      }),
    );

    return jsonDecode(response.body);
  }

  // Get user attendance for a course
  Future<Map<String, dynamic>> getUserAttendance(
      String userId, int courseId) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${Config.getUserAttendanceUrl}/$userId/course/$courseId'),
      headers: _headers(token: token),
    );

    return jsonDecode(response.body);
  }

  // Get available quizzes for a course
  Future<Map<String, dynamic>> getAvailableQuizzes(int courseId) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${Config.quizzesUrl}/available?courseId=$courseId'),
      headers: _headers(token: token),
    );

    return jsonDecode(response.body);
  }

  // Get active assignments for a course
  Future<Map<String, dynamic>> getActiveAssignments(int courseId) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${Config.assignmentsUrl}/active?courseId=$courseId'),
      headers: _headers(token: token),
    );

    return jsonDecode(response.body);
  }
}
