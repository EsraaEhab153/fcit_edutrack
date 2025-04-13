import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/quiz_provider.dart';
import '../../providers/course_provider.dart';
import '../../models/quiz_models.dart';
import '../../models/course_model.dart'; // Import Course model
import '../../style/my_app_colors.dart';
import 'quiz_taking_screen.dart'; // Import the Quiz Taking Screen

class StudentQuizListScreen extends StatefulWidget {
  static const String routeName = 'student_quiz_list';

  const StudentQuizListScreen({Key? key}) : super(key: key);

  @override
  _StudentQuizListScreenState createState() => _StudentQuizListScreenState();
}

class _StudentQuizListScreenState extends State<StudentQuizListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch quizzes when the screen initializes
    // The QuizProvider needs the CourseProvider, which is handled by ChangeNotifierProxyProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure courses are fetched first if needed, then fetch quizzes
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      courseProvider.ensureEnrolledCoursesFetched().then((_) {
        if (mounted) {
          // Check if still mounted after async gap
          quizProvider
              .fetchProfessorQuizzes(); // Re-use the same fetch logic for available quizzes
        }
      });
    });
  }

  Future<void> _refreshQuizzes() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    // Ensure courses are fetched before fetching quizzes on refresh
    await courseProvider.ensureEnrolledCoursesFetched();
    if (mounted) {
      await quizProvider.fetchProfessorQuizzes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Quizzes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: MyAppColors.primaryColor,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          return RefreshIndicator(
            onRefresh: _refreshQuizzes,
            // Also consume CourseProvider here to pass it down
            child: Consumer<CourseProvider>(
              builder: (context, courseProvider, _) =>
                  _buildQuizList(quizProvider, courseProvider),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuizList(
      QuizProvider quizProvider, CourseProvider courseProvider) {
    if (quizProvider.isLoading && quizProvider.professorQuizzes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final quizzes = quizProvider.professorQuizzes;

    if (quizzes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No quizzes available for your enrolled courses at the moment.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    // TODO: Potentially group quizzes by course later if needed
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final Quiz quiz = quizzes[index];
        // Get course name from CourseProvider's enrolledCourses list
        final course = courseProvider.enrolledCourses.firstWhere(
          (c) => c.id == quiz.courseId,
          orElse: () => Course(
              id: 0,
              courseCode: 'N/A',
              courseName: 'Unknown Course',
              description: '',
              startTime: '',
              endTime: '',
              days: []), // Provide a default Course object
        );
        final String courseName = course?.courseName ?? 'Unknown Course';
        String courseIdentifier = 'Course ID: ${quiz.courseId}'; // Placeholder

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              quiz.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Course: $courseName'), // Show actual course name
                const SizedBox(height: 4),
                Text('Description: ${quiz.description}'),
                const SizedBox(height: 4),
                Text('Questions: ${quiz.questions.length}'),
                const SizedBox(height: 4),
                Text('Duration: ${quiz.durationMinutes} minutes'),
                const SizedBox(height: 4),
                Text(
                    'Available until: ${DateFormat('MMM d, yyyy h:mm a').format(quiz.endDate)}'),
              ],
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.secondaryBlueColor,
              ),
              onPressed: () {
                // Navigate to Quiz Taking Screen, passing the quiz object
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizTakingScreen(quiz: quiz),
                  ),
                );
              },
              child: const Text('Start Quiz'),
            ),
          ),
        );
      },
    );
  }
}
