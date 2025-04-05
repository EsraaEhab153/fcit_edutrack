import 'package:flutter/material.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class QuizManagementScreen extends StatefulWidget {
  static const String routeName = 'quiz_management';

  const QuizManagementScreen({Key? key}) : super(key: key);

  @override
  State<QuizManagementScreen> createState() => _QuizManagementScreenState();
}

class _QuizManagementScreenState extends State<QuizManagementScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    setState(() {
      isLoading = true;
    });

    try {
      // TODO: Implement API call to get professor's quizzes

      // Mock data for UI development
      quizzes = [
        {
          'id': '1',
          'title': 'Midterm Quiz',
          'courseCode': 'CS101',
          'totalQuestions': 10,
          'timeLimit': 30,
          'dueDate': DateTime.now().add(const Duration(days: 7)),
          'isPublished': true
        },
        {
          'id': '2',
          'title': 'Final Quiz',
          'courseCode': 'CS101',
          'totalQuestions': 15,
          'timeLimit': 45,
          'dueDate': DateTime.now().add(const Duration(days: 14)),
          'isPublished': false
        },
      ];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load quizzes: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : quizzes.isEmpty
              ? _buildEmptyState()
              : _buildQuizList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyAppColors.primaryColor,
        onPressed: () {
          _showCreateQuizDialog();
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
              _showCreateQuizDialog();
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

  Widget _buildQuizList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              quiz['title'],
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
                    Text('Course: ${quiz['courseCode']}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.question_answer,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Questions: ${quiz['totalQuestions']}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.timer, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${quiz['timeLimit']} minutes'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('Due: ${_formatDate(quiz['dueDate'])}'),
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
                        color: quiz['isPublished']
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        quiz['isPublished'] ? 'Published' : 'Draft',
                        style: TextStyle(
                          color: quiz['isPublished']
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
                            // Navigate to edit quiz
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            quiz['isPublished']
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: MyAppColors.primaryColor,
                          ),
                          onPressed: () {
                            // Toggle published status
                            setState(() {
                              quiz['isPublished'] = !quiz['isPublished'];
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(quiz['id']);
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
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCreateQuizDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Quiz'),
        content: const Text(
          'This will take you to the quiz creation form where you can add questions and set quiz parameters.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyAppColors.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Navigate to quiz creation screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quiz creation coming soon!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String quizId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text(
          'Are you sure you want to delete this quiz? This action cannot be undone.',
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
              // Delete quiz logic
              setState(() {
                quizzes.removeWhere((quiz) => quiz['id'] == quizId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quiz deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
