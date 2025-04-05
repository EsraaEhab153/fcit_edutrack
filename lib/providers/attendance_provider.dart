import 'package:flutter/foundation.dart';
import '../models/attendance_model.dart';
import '../services/api_service.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _isLoading = false;
  // Store attendance records by course ID
  Map<int, List<Attendance>> _attendanceRecordsByCourse = {};

  final ApiService _apiService = ApiService();

  bool get isLoading => _isLoading;
  Map<int, List<Attendance>> get attendanceRecordsByCourse =>
      _attendanceRecordsByCourse;
  List<Attendance> getAttendanceForCourse(int courseId) =>
      _attendanceRecordsByCourse[courseId] ?? [];

  // Record attendance for a course
  Future<Map<String, dynamic>> recordAttendance(int courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Since wifi verification is disabled, we'll use a standard method
      final response =
          await _apiService.recordAttendance(courseId, "MANUAL", "MANUAL");

      if (response['success'] && response['data'] != null) {
        // Add the new attendance record to the list for this course
        final newAttendance = Attendance.fromJson(response['data']);

        // Initialize the list if it doesn't exist
        _attendanceRecordsByCourse[courseId] ??= [];

        // Add the new record to this course's list
        _attendanceRecordsByCourse[courseId]!.add(newAttendance);
      }

      return response;
    } catch (e) {
      print('Error recording attendance: $e');
      return {
        'success': false,
        'message': 'Network error, please try again later',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch attendance records for a user in a specific course
  Future<void> fetchUserAttendance(String userId, int courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Use the current user endpoint instead of user ID
      final response = await _apiService.getCurrentUserAttendance(courseId);
      print("Response for course $courseId: ${response['success']}");

      if (response['success'] && response['data'] != null) {
        final List<dynamic> attendanceData = response['data'];
        final records = attendanceData
            .map((attendanceJson) => Attendance.fromJson(attendanceJson))
            .toList();

        // Store these records specifically for this course
        _attendanceRecordsByCourse[courseId] = records;
        print(
            "Loaded ${records.length} attendance records for course $courseId");
      } else {
        // If failed, initialize with empty list
        _attendanceRecordsByCourse[courseId] = [];
        print("No attendance records found for course $courseId");
      }
    } catch (e) {
      // If error, initialize with empty list
      _attendanceRecordsByCourse[courseId] = [];
      print('Error fetching attendance records for course $courseId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear all attendance records
  void clearAttendanceRecords() {
    _attendanceRecordsByCourse.clear();
    notifyListeners();
  }
}
