import 'dart:convert';
import 'dart:io';
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

  // Login with email
  Future<Map<String, dynamic>> loginWithEmail(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(Config.loginUrl),
      headers: _headers(),
      body: jsonEncode({
        'email': email,
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

    print("Getting current courses from URL: ${Config.currentCoursesUrl}");
    print(
        "Using authorization token: ${token != null ? 'Valid token' : 'No token'}");

    final response = await http.get(
      Uri.parse(Config.currentCoursesUrl),
      headers: _headers(token: token),
    );

    print("Current courses response status: ${response.statusCode}");
    if (response.statusCode != 200) {
      print("Error response body: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  // Get enrolled courses
  Future<Map<String, dynamic>> getEnrolledCourses() async {
    final token = await _getToken();

    print("Getting enrolled courses from URL: ${Config.enrolledCoursesUrl}");
    print(
        "Using authorization token: ${token != null ? 'Valid token' : 'No token'}");

    final response = await http.get(
      Uri.parse(Config.enrolledCoursesUrl),
      headers: _headers(token: token),
    );

    print("Enrolled courses response status: ${response.statusCode}");
    if (response.statusCode != 200) {
      print("Error response body: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  // Create sample courses
  Future<Map<String, dynamic>> createSampleCourses() async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse(Config.sampleCoursesUrl),
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

    // If userId is empty or null, return an error
    if (userId.isEmpty) {
      print('Error: Cannot fetch attendance with empty user ID');
      return {
        'success': false,
        'message': 'User ID is required to fetch attendance',
      };
    }

    final response = await http.get(
      Uri.parse('${Config.getUserAttendanceUrl}/$userId/course/$courseId'),
      headers: _headers(token: token),
    );

    return jsonDecode(response.body);
  }

  // Get user attendance by username for a course
  Future<Map<String, dynamic>> getUserAttendanceByUsername(
      String username, int courseId) async {
    final token = await _getToken();

    // If username is empty or null, return an error
    if (username.isEmpty) {
      print('Error: Cannot fetch attendance with empty username');
      return {
        'success': false,
        'message': 'Username is required to fetch attendance',
      };
    }

    print("Getting attendance by username: $username for course: $courseId");
    final response = await http.get(
      Uri.parse(
          '${Config.getUserAttendanceByUsernameUrl}/$username/course/$courseId'),
      headers: _headers(token: token),
    );

    print("Response status: ${response.statusCode}");
    if (response.statusCode != 200) {
      print("Error response: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  // Get current user's attendance for a course
  Future<Map<String, dynamic>> getCurrentUserAttendance(int courseId) async {
    final token = await _getToken();

    print("Getting attendance for current user for course: $courseId");
    final response = await http.get(
      Uri.parse('${Config.getCurrentUserAttendanceUrl}/course/$courseId'),
      headers: _headers(token: token),
    );

    print("Response status: ${response.statusCode}");
    if (response.statusCode != 200) {
      print("Error response: ${response.body}");
    }

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

  // Submit professor request
  Future<dynamic> submitProfessorRequest(
    String fullName,
    String email,
    String department,
    String idImageUrl,
    String additionalInfo,
  ) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(Config.professorRequestUrl),
        headers: _headers(token: token),
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'department': department,
          'idImageUrl': idImageUrl,
          'additionalInfo': additionalInfo,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Upload file
  Future<dynamic> uploadFile(File file) async {
    try {
      final token = await _getToken();

      var request =
          http.MultipartRequest('POST', Uri.parse(Config.fileUploadUrl));

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get pending professor requests (admin only)
  Future<dynamic> getPendingProfessorRequests() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${Config.professorRequestUrl}/pending'),
        headers: _headers(token: token),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Review professor request (admin only)
  Future<dynamic> reviewProfessorRequest(
      String requestId, bool isApproved) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('${Config.professorRequestUrl}/$requestId/review'),
        headers: _headers(token: token),
        body: jsonEncode({
          'approved': isApproved,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
