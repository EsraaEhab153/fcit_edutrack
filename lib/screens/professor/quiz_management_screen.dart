import 'package:flutter/material.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/providers/auth_provider.dart'; // Keep if needed for permissions later
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart'; // Import QuizProvider
import '../../models/quiz_models.dart';
import '../../models/course_model.dart'; // Import Course model
import '../../providers/course_provider.dart'; // Import CourseProvider
import 'quiz_creation_screen.dart'; // Import the creation screen
import 'quiz_submissions_screen.dart'; // Import the submissions screen
import 'package:intl/intl.dart'; // Import intl for date formatting

class QuizManagementScreen extends StatefulWidget {
  static const String routeName = 'quiz_management';

  const QuizManagementScreen({Key? key}) : super(key: key);

  @override
  State<QuizManagementScreen> createState() => _QuizManagementScreenState();
}

class _QuizManagementScreenState extends State<QuizManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchQuizzes();
    });
  }

  Future<void> _fetchQuizzes() async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    await quizProvider.fetchProfessorQuizzes();
  }

  Future<void> _downloadSubmissions(Quiz quiz) async {
    try {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      final result = await quizProvider.downloadQuizSubmissions(quiz.id!);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submissions downloaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(result['message'] ?? 'Failed to download submissions'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading submissions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewSubmissions(Quiz quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizSubmissionsScreen(
          quizId: quiz.id!,
          quizTitle: quiz.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Management',
          style: TextStyle(
            color: MyAppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: MyAppColors.primaryColor),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading && quizProvider.professorQuizzes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!quizProvider.isLoading &&
              quizProvider.professorQuizzes.isEmpty) {
            return _buildEmptyState();
          }
          return Consumer<CourseProvider>(
            builder: (context, courseProvider, _) =>
                _buildQuizList(quizProvider, courseProvider),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyAppColors.primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, QuizCreationScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.quiz_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No quizzes yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first quiz by tapping the + button',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, QuizCreationScreen.routeName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyAppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Create Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizList(
      QuizProvider quizProvider, CourseProvider courseProvider) {
    final quizzes = quizProvider.professorQuizzes;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final Quiz quiz = quizzes[index];
        final course = courseProvider.enrolledCourses.firstWhere(
          (c) => c.id == quiz.courseId,
          orElse: () => Course(
              id: 0,
              courseCode: 'N/A',
              courseName: 'Unknown Course',
              description: '',
              startTime: '',
              endTime: '',
              days: []),
        );

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  quiz.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.school, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Course: ${course.courseName}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.question_answer,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Questions: ${quiz.questions.length}'),
                        const SizedBox(width: 16),
                        const Icon(Icons.timer, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${quiz.durationMinutes} minutes'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Ends: ${_formatDateTime(quiz.endDate)}'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Submissions'),
                      onPressed: () => _viewSubmissions(quiz),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('Download CSV'),
                      onPressed: () => _downloadSubmissions(quiz),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: MyAppColors.primaryColor),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Edit quiz coming soon!')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(quiz),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy h:mm a').format(date.toLocal());
  }

  void _showDeleteConfirmation(Quiz quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: Text(
          'Are you sure you want to delete "${quiz.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Delete quiz "${quiz.title}" coming soon!')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
