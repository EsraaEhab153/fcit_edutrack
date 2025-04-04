import 'package:flutter/foundation.dart';
import '../models/attendance_model.dart';
import '../services/api_service.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Attendance> _attendanceRecords = [];
  final ApiService _apiService = ApiService();

  bool get isLoading => _isLoading;
  List<Attendance> get attendanceRecords => _attendanceRecords;

  // Record attendance for a course
  Future<Map<String, dynamic>> recordAttendance(int courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Since wifi verification is disabled, we'll use a standard method
      final response =
          await _apiService.recordAttendance(courseId, "MANUAL", "MANUAL");

      if (response['success'] && response['data'] != null) {
        // Add the new attendance record to the list
        final newAttendance = Attendance.fromJson(response['data']);
        _attendanceRecords.add(newAttendance);
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
      final response = await _apiService.getUserAttendance(userId, courseId);

      if (response['success'] && response['data'] != null) {
        final List<dynamic> attendanceData = response['data'];
        _attendanceRecords = attendanceData
            .map((attendanceJson) => Attendance.fromJson(attendanceJson))
            .toList();
      }
    } catch (e) {
      print('Error fetching attendance records: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
