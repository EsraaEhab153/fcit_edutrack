import 'package:flutter/foundation.dart';
import '../models/quiz_models.dart'; // Import the quiz models
import '../services/api_service.dart';
import 'course_provider.dart'; // Import CourseProvider

class QuizProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Quiz> _professorQuizzes = [];
  final ApiService _apiService = ApiService();
  CourseProvider? _courseProvider; // To access enrolled courses

  bool get isLoading => _isLoading;
  List<Quiz> get professorQuizzes => _professorQuizzes;

  // Method to update the internal CourseProvider reference (called by ProxyProvider)
  void update(CourseProvider courseProvider) {
    _courseProvider = courseProvider;
    // Optionally fetch quizzes immediately when course provider is available
    // fetchProfessorQuizzes(); // Avoid fetching automatically on update for now
  }

  // Fetch available quizzes for all enrolled courses
  Future<void> fetchProfessorQuizzes() async {
    if (_courseProvider == null) {
      print("QuizProvider: CourseProvider not available yet.");
      return; // Cannot fetch without enrolled courses
    }

    // Ensure enrolled courses are loaded in CourseProvider first
    // Use a short delay or check CourseProvider's loading state if necessary
    if (_courseProvider!.isLoading) {
      print("QuizProvider: Waiting for CourseProvider to finish loading...");
      // Listen to CourseProvider changes or use a callback if more robust handling is needed
      await Future.delayed(const Duration(
          milliseconds: 500)); // Simple wait, might need improvement
      if (_courseProvider!.isLoading) {
        print("QuizProvider: CourseProvider still loading after wait.");
        // Handle timeout or persistent loading state if necessary
        return;
      }
    }
    // Call ensureEnrolledCoursesFetched if it exists and handles its own loading state
    // If ensureEnrolledCoursesFetched doesn't exist or isn't sufficient, fetch directly
    if (_courseProvider!.enrolledCourses.isEmpty) {
      await _courseProvider!.fetchEnrolledCourses();
    }

    final enrolledCourses = _courseProvider!.enrolledCourses;
    if (enrolledCourses.isEmpty) {
      print("QuizProvider: No enrolled courses found for the user.");
      _professorQuizzes = [];
      _isLoading = false; // Ensure loading is false if returning early
      notifyListeners();
      return;
    }

    _isLoading = true;
    _professorQuizzes = []; // Clear previous quizzes before fetching new ones
    notifyListeners(); // Notify UI about loading start and cleared list

    List<Quiz> allQuizzes = [];
    Set<int> fetchedQuizIds = {}; // To avoid duplicates

    try {
      // Fetch quizzes for each enrolled course
      for (var course in enrolledCourses) {
        print("QuizProvider: Fetching quizzes for course ${course.id}");
        final response = await _apiService
            .getAvailableQuizzes(course.id); // Use getAvailableQuizzes

        if (response['success'] && response['data'] != null) {
          final List<dynamic> quizzesData = response['data'];
          for (var quizJson in quizzesData) {
            final quiz = Quiz.fromJson(quizJson);
            // Add only if not already added (handles quizzes linked to multiple courses)
            if (quiz.id != null && !fetchedQuizIds.contains(quiz.id!)) {
              allQuizzes.add(quiz);
              fetchedQuizIds.add(quiz.id!);
            }
          }
        } else {
          print(
              "QuizProvider: Failed to fetch quizzes for course ${course.id}: ${response['message']}");
          // Decide if one failure should stop the whole process or just skip
        }
      }
      _professorQuizzes = allQuizzes;
      print(
          "QuizProvider: Fetched total ${_professorQuizzes.length} unique quizzes.");
    } catch (e) {
      _professorQuizzes = []; // Clear list on error
      print('QuizProvider: Error fetching quizzes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new quiz
  Future<Map<String, dynamic>> createQuiz(Quiz quiz) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Convert the Quiz object to JSON using its toJson method
      final quizData = quiz.toJson();
      final response = await _apiService.createQuiz(quizData);

      if (response['success']) {
        // Refresh the list of quizzes after successful creation
        await fetchProfessorQuizzes();
      }
      return response; // Return the full response map (includes success, message, data)
    } catch (e) {
      print('Error creating quiz: $e');
      return {
        'success': false,
        'message': 'Network error or failed to create quiz.',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit Quiz Answers (Student)
  Future<Map<String, dynamic>> submitQuiz(
      int quizId, List<Map<String, dynamic>> answers) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.submitQuiz(quizId, answers);
      // No local state update needed typically, just return response
      return response;
    } catch (e) {
      print('Error submitting quiz: $e');
      return {
        'success': false,
        'message': 'Network error or failed to submit quiz.',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Start Quiz (Student)
  Future<Map<String, dynamic>> startQuiz(int quizId) async {
    // No need to set loading state for starting, as it's usually a quick call
    // before navigating or enabling the UI. If it fails, we handle it in the UI.
    try {
      final response = await _apiService.startQuiz(quizId);
      // The response might contain the attempt details, which could be stored
      // if needed, but for now, just return the success/failure.
      return response;
    } catch (e) {
      print('Error starting quiz: $e');
      return {
        'success': false,
        'message': 'Network error or failed to start quiz.',
      };
    }
    // No notifyListeners needed here unless we store attempt state
  }

  // TODO: Add methods for updating, deleting, publishing/unpublishing quizzes if needed
}
