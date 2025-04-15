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
  static const String enrolledCoursesUrl = '$baseUrl/api/courses/enrolled';
  static const String sampleCoursesUrl = '$baseUrl/api/courses/sample';

  // Attendance endpoints
  static const String enrollUrl = '$baseUrl/api/attendance/enroll';
  static const String recordAttendanceUrl = '$baseUrl/api/attendance/record';
  static const String getUserAttendanceUrl = '$baseUrl/api/attendance/user';
  static const String getUserAttendanceByUsernameUrl =
      '$baseUrl/api/attendance/user/username';
  static const String getCurrentUserAttendanceUrl =
      '$baseUrl/api/attendance/user/current';
  static const String createSessionUrl =
      '$baseUrl/api/attendance/sessions/create';
  static const String activeSessionsUrl =
      '$baseUrl/api/attendance/sessions/active'; // Added
  static const String sessionAttendeesBaseUrl =
      '$baseUrl/api/attendance/sessions'; // Added (base for /sessionId/attendees)
  static const String dailyAttendeesBaseUrl =
      '$baseUrl/api/attendance/course'; // Added (base for /courseId/date/YYYY-MM-DD/attendees)
  static const String downloadSpreadsheetBaseUrl =
      '$baseUrl/api/attendance/course'; // Added (base for /courseId/spreadsheet)

  // Quiz endpoints
  static const String quizzesUrl = '$baseUrl/api/quizzes'; // Base for CRUD
  static const String availableQuizzesUrl =
      '$baseUrl/api/quizzes/available'; // Base URL for available quizzes (add ?courseId=X)
  static const String myQuizzesUrl =
      '$baseUrl/api/quizzes/my-quizzes'; // Base URL for professor's quizzes
  static const String quizSubmissionsUrl =
      '$baseUrl/api/quizzes'; // Base URL for /{quizId}/submissions
  static const String downloadQuizSubmissionsUrl =
      '$baseUrl/api/quizzes'; // Base URL for /{quizId}/submissions/download
  static const String quizSubmissionDetailsUrl =
      '$baseUrl/api/quizzes'; // Base URL for /{quizId}/submissions/{submissionId}
  // Note: Start and Submit use the base quizzesUrl + quizId + /action
  static const String startQuizBaseUrl =
      '$baseUrl/api/quizzes'; // Base for /<quizId>/start
  static const String submitQuizBaseUrl =
      '$baseUrl/api/quizzes'; // Base for /<quizId>/submit

  // Assignment endpoints
  static const String assignmentsUrl = '$baseUrl/api/assignments';

  // File upload endpoint
  static const String fileUploadUrl = '$baseUrl/api/upload';
  static const String publicFileUploadUrl = '$baseUrl/api/upload/public';

  // Professor request endpoint
  static const String professorRequestUrl = '$baseUrl/api/professor-requests';
}
