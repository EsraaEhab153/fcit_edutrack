import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../services/api_service.dart';

class CourseProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Course> _courses = [];
  List<Course> _currentCourses = [];
  final ApiService _apiService = ApiService();

  bool get isLoading => _isLoading;
  List<Course> get courses => _courses;
  List<Course> get currentCourses => _currentCourses;

  // Fetch all courses
  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCourses();

      if (response['success'] && response['data'] != null) {
        final List<dynamic> coursesData = response['data'];
        _courses = coursesData
            .map((courseJson) => Course.fromJson(courseJson))
            .toList();
      }
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch current active courses
  Future<void> fetchCurrentCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCurrentCourses();

      if (response['success'] && response['data'] != null) {
        final List<dynamic> coursesData = response['data'];
        _currentCourses = coursesData
            .map((courseJson) => Course.fromJson(courseJson))
            .toList();
      }
    } catch (e) {
      print('Error fetching current courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Enroll in a course
  Future<Map<String, dynamic>> enrollInCourse(int courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.enrollInCourse(courseId);

      if (response['success']) {
        // Refresh the courses list
        await fetchCurrentCourses();
      }

      return response;
    } catch (e) {
      print('Error enrolling in course: $e');
      return {
        'success': false,
        'message': 'Network error, please try again later',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
