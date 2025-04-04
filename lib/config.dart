class Config {
  // Base URL for the backend API
  static const String baseUrl =
      'https://edutrack-backend-orms.onrender.com/api';

  // Authentication endpoints
  static const String registerUrl = '$baseUrl/api/auth/register';
  static const String verifyEmailUrl = '$baseUrl/api/auth/verify-email';
  static const String loginUrl = '$baseUrl/api/auth/login';

  // Course endpoints
  static const String coursesUrl = '$baseUrl/api/courses';
  static const String currentCoursesUrl = '$baseUrl/api/courses/current';

  // Attendance endpoints
  static const String enrollUrl = '$baseUrl/api/attendance/enroll';
  static const String recordAttendanceUrl = '$baseUrl/api/attendance/record';
  static const String getUserAttendanceUrl = '$baseUrl/api/attendance/user';

  // Quiz endpoints
  static const String quizzesUrl = '$baseUrl/api/quizzes';

  // Assignment endpoints
  static const String assignmentsUrl = '$baseUrl/api/assignments';

  // File upload endpoint
  static const String fileUploadUrl = '$baseUrl/api/upload';
}
