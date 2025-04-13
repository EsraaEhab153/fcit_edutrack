import 'package:flutter/material.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/providers/auth_provider.dart'; // Keep if needed for permissions later
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart'; // Import QuizProvider
import '../../models/quiz_models.dart';
import 'quiz_creation_screen.dart'; // Import the creation screen
import 'package:intl/intl.dart'; // Import intl for date formatting

class QuizManagementScreen extends StatefulWidget {
  static const String routeName = 'quiz_management';

  const QuizManagementScreen({Key? key}) : super(key: key);

  @override
  State<QuizManagementScreen> createState() => _QuizManagementScreenState();
}

class _QuizManagementScreenState extends State<QuizManagementScreen> {
  // isLoading state will be handled by the provider
  // List<Map<String, dynamic>> quizzes = []; // Remove mock list

  @override
  void initState() {
    super.initState();
    // Fetch quizzes when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchQuizzes();
    });
  }

  Future<void> _fetchQuizzes() async {
    // Access provider without listening here, Consumer will handle updates
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    await quizProvider.fetchProfessorQuizzes();
    // Error handling is done within the provider, maybe show SnackBar here if needed
    // if (quizProvider.errorMessage != null) { // Assuming provider has error message state
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to load quizzes: ${quizProvider.errorMessage}')),
    //   );
    // }
  }

  // Removed mock _loadQuizzes

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
            return _buildEmptyState(); // Show empty state if not loading and no quizzes
          }
          // Pass the provider to the list builder
          return _buildQuizList(quizProvider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyAppColors.primaryColor,
        onPressed: () {
          // Navigate to the creation screen
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
              // Navigate to the creation screen
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

  Widget _buildQuizList(QuizProvider quizProvider) {
    // Accept provider
    final quizzes = quizProvider.professorQuizzes; // Get quizzes from provider

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final Quiz quiz = quizzes[index]; // Use Quiz model
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              quiz.title, // Use model property
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
                    // TODO: Need Course Name/Code - Quiz model needs course details or fetch separately
                    Text(
                        'Course ID: ${quiz.courseId}'), // Display Course ID for now
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.question_answer,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                        'Questions: ${quiz.questions.length}'), // Use model property
                    const SizedBox(width: 16),
                    const Icon(Icons.timer, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                        '${quiz.durationMinutes} minutes'), // Use model property
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                        'End Date: ${_formatDate(quiz.endDate)}'), // Use model property
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (quiz.isPublished ?? false)
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (quiz.isPublished ?? false)
                            ? 'Published'
                            : 'Draft', // Use model property
                        style: TextStyle(
                          color: (quiz.isPublished ?? false)
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: MyAppColors.primaryColor),
                          onPressed: () {
                            // TODO: Navigate to edit quiz screen (pass quiz object)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Edit quiz coming soon!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            (quiz.isPublished ?? false)
                                ? Icons
                                    .visibility_off_outlined // Use outlined icons
                                : Icons.visibility_outlined,
                            color: MyAppColors.primaryColor,
                          ),
                          onPressed: () {
                            // TODO: Call provider to toggle published status
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Publish/unpublish coming soon!')),
                            );
                            // Example: Provider.of<QuizProvider>(context, listen: false).toggleQuizStatus(quiz.id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(
                                quiz); // Pass the whole quiz object
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    // Use intl package for better formatting
    return DateFormat('MMM d, yyyy').format(date);
  }

  // Removed _showCreateQuizDialog as we navigate directly now

  void _showDeleteConfirmation(Quiz quiz) {
    // Accept Quiz object
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: Text(
          'Are you sure you want to delete "${quiz.title}"? This action cannot be undone.', // Show quiz title
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
              // TODO: Call provider to delete quiz
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Delete quiz "${quiz.title}" coming soon!')),
              );
              // Example: Provider.of<QuizProvider>(context, listen: false).deleteQuiz(quiz.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
