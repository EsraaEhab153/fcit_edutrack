import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
      // No token needed for professor requests
      final response = await http.post(
        Uri.parse(Config.professorRequestUrl),
        headers: _headers(), // No token
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
      print("Uploading file to ${Config.publicFileUploadUrl}");
      print("File path: ${file.path}");

      // Determine content type based on file extension
      String extension = file.path.split('.').last.toLowerCase();
      String contentType;

      switch (extension) {
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        case 'png':
          contentType = 'image/png';
          break;
        case 'pdf':
          contentType = 'application/pdf';
          break;
        case 'doc':
          contentType = 'application/msword';
          break;
        case 'docx':
          contentType =
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
          break;
        default:
          contentType = 'image/jpeg'; // Default to jpeg if unknown
      }

      print("Determined content type: $contentType for extension: $extension");

      var request =
          http.MultipartRequest('POST', Uri.parse(Config.publicFileUploadUrl));

      // Add the file with explicit content type
      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(contentType),
      );

      request.files.add(multipartFile);

      print(
          "Created multipart request with file: ${multipartFile.filename}, contentType: ${multipartFile.contentType}");
      print("Sending file upload request...");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("File upload response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          print("Warning: Empty response body");
          return {'success': false, 'message': 'Empty response from server'};
        }

        try {
          return jsonDecode(response.body);
        } catch (parseError) {
          print("Error parsing JSON response: $parseError");
          print("Response body was: '${response.body}'");
          return {
            'success': false,
            'message': 'Failed to parse server response',
            'details': parseError.toString()
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server returned status code ${response.statusCode}',
          'details': response.body
        };
      }
    } catch (e) {
      print("Exception in file upload: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get pending professor requests (admin only)
  Future<dynamic> getPendingProfessorRequests() async {
    try {
      final token = await _getToken();
      print(
          "Getting pending professor requests from: ${Config.professorRequestUrl}");
      print("Token: ${token != null ? "Valid token present" : "No token"}");

      final response = await http.get(
        Uri.parse(Config.professorRequestUrl),
        headers: _headers(token: token),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("Error fetching professor requests: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // Review professor request (admin only)
  Future<dynamic> reviewProfessorRequest(String requestId, bool isApproved,
      {String? rejectionReason}) async {
    try {
      final token = await _getToken();

      print("Reviewing professor request: ID=$requestId, approved=$isApproved");
      print("Using URL: ${Config.professorRequestUrl}/$requestId/review");

      final payload = {
        'approved': isApproved,
        'reviewedBy': 'admin',
        'rejectionReason': rejectionReason,
      };

      print("Request payload: $payload");

      final response = await http.put(
        Uri.parse('${Config.professorRequestUrl}/$requestId/review'),
        headers: _headers(token: token),
        body: jsonEncode(payload),
      );

      print("Review request response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("Error reviewing professor request: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // Create a new course (admin only)
  Future<dynamic> createCourse(Map<String, dynamic> courseData) async {
    try {
      final token = await _getToken();

      print("Creating course with data: $courseData");
      print("Using URL: ${Config.coursesUrl}");

      final response = await http.post(
        Uri.parse(Config.coursesUrl),
        headers: _headers(token: token),
        body: jsonEncode(courseData),
      );

      print("Create course response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("Error creating course: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // Update an existing course (admin only)
  Future<dynamic> updateCourse(
      int courseId, Map<String, dynamic> courseData) async {
    try {
      final token = await _getToken();

      print("Updating course $courseId with data: $courseData");
      print("Using URL: ${Config.coursesUrl}/$courseId");

      final response = await http.put(
        Uri.parse('${Config.coursesUrl}/$courseId'),
        headers: _headers(token: token),
        body: jsonEncode(courseData),
      );

      print("Update course response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("Error updating course: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // Delete a course (admin only)
  Future<dynamic> deleteCourse(int courseId) async {
    try {
      final token = await _getToken();

      print("Deleting course $courseId");
      print("Using URL: ${Config.coursesUrl}/$courseId");

      final response = await http.delete(
        Uri.parse('${Config.coursesUrl}/$courseId'),
        headers: _headers(token: token),
      );

      print("Delete course response status: ${response.statusCode}");
      if (response.statusCode == 204 || response.body.isEmpty) {
        return {'success': true, 'message': 'Course deleted successfully'};
      }

      return jsonDecode(response.body);
    } catch (e) {
      print("Error deleting course: $e");
      return {'success': false, 'message': e.toString()};
    }
  }
}
