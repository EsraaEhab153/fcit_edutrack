import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/quiz_models.dart';
import '../../models/course_model.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/course_provider.dart';
import '../../style/my_app_colors.dart';

class QuizCreationScreen extends StatefulWidget {
  static const String routeName = 'quiz_creation';

  const QuizCreationScreen({Key? key}) : super(key: key);

  @override
  _QuizCreationScreenState createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for basic quiz info
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Course? _selectedCourse;
  DateTime? _startDate;
  DateTime? _endDate;
  final _durationController = TextEditingController();

  // List to hold questions being built
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    // Fetch courses for the dropdown if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false)
          .ensureEnrolledCoursesFetched();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    // Dispose question/option controllers if added later
    super.dispose();
  }

  // --- UI Building Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Quiz',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: MyAppColors.primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          // Use ListView for scrolling
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildQuizInfoSection(),
            const Divider(height: 32),
            _buildQuestionsSection(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quiz Details', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
              labelText: 'Quiz Title', border: OutlineInputBorder()),
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter a title' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
              labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 3,
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter a description'
              : null,
        ),
        const SizedBox(height: 12),
        Consumer<CourseProvider>(// Use Consumer to get courses
            builder: (context, courseProvider, child) {
          // Handle loading state for courses
          if (courseProvider.isLoading &&
              courseProvider.enrolledCourses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (courseProvider.enrolledCourses.isEmpty) {
            return const Text(
                'No courses available. Please enroll in a course first.');
          }
          return DropdownButtonFormField<Course>(
            value: _selectedCourse,
            items: courseProvider.enrolledCourses.map((Course course) {
              return DropdownMenuItem<Course>(
                value: course,
                child: Text('${course.courseCode} - ${course.courseName}'),
              );
            }).toList(),
            onChanged: (Course? newValue) {
              setState(() {
                _selectedCourse = newValue;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Course',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null ? 'Please select a course' : null,
          );
        }),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildDateTimePicker('Start Date', _startDate,
                    (date) => setState(() => _startDate = date))),
            const SizedBox(width: 12),
            Expanded(
                child: _buildDateTimePicker('End Date', _endDate,
                    (date) => setState(() => _endDate = date))),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _durationController,
          decoration: const InputDecoration(
              labelText: 'Duration (Minutes)', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter duration';
            if (int.tryParse(value) == null || int.parse(value) <= 0)
              return 'Enter a valid number';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate:
              DateTime.now().subtract(const Duration(days: 1)), // Allow today
          lastDate: DateTime.now()
              .add(const Duration(days: 365 * 2)), // Allow 2 years in future
        );
        if (pickedDate != null) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
          );
          if (pickedTime != null) {
            final finalDateTime = DateTime(pickedDate.year, pickedDate.month,
                pickedDate.day, pickedTime.hour, pickedTime.minute);
            onDateSelected(finalDateTime);
          }
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          selectedDate == null
              ? 'Select Date & Time'
              : DateFormat('yyyy-MM-dd HH:mm').format(selectedDate),
        ),
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Questions (${_questions.length})',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (_questions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
                child: Text(
                    'No questions added yet. Click "Add Question" below.')),
          )
        else
          ListView.builder(
            shrinkWrap: true, // Important inside a ListView
            physics:
                const NeverScrollableScrollPhysics(), // Disable inner scrolling
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final question = _questions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(question.text,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                      'Type: ${question.type.name}, Points: ${question.points}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.edit_outlined, color: Colors.blue),
                        tooltip: 'Edit Question',
                        onPressed: () =>
                            _editQuestion(index), // Call edit method
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'Remove Question',
                        onPressed: () =>
                            _removeQuestion(index), // Call remove method
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Question'),
          onPressed: _addQuestion, // Calls the updated method
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitQuiz,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyAppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ))
            : const Text('Save Quiz'),
      ),
    );
  }

  // --- Logic Methods ---

  // Method to show dialog for adding/editing a question
  Future<void> _showQuestionDialog({int? editIndex}) async {
    final _questionTextController = TextEditingController();
    final _pointsController = TextEditingController();
    QuestionType _selectedType = QuestionType.MULTIPLE_CHOICE;
    // Declare controllers and state variables needed within the dialog scope
    List<TextEditingController> _optionControllers = [];
    int? _correctOptionIndex; // Index of the correct option for MC questions
    final _textAnswerController = TextEditingController();

    bool isEditing = editIndex != null;
    if (isEditing) {
      final existingQuestion = _questions[editIndex];
      _questionTextController.text = existingQuestion.text;
      _pointsController.text = existingQuestion.points.toString();
      _selectedType = existingQuestion.type;
      // Populate options/answer controllers based on existing question
      if (existingQuestion.type == QuestionType.MULTIPLE_CHOICE &&
          existingQuestion.options != null) {
        _optionControllers = existingQuestion.options!
            .map((opt) => TextEditingController(text: opt.text))
            .toList();
        _correctOptionIndex =
            existingQuestion.options!.indexWhere((opt) => opt.correct);
        if (_correctOptionIndex == -1)
          _correctOptionIndex =
              null; // Handle case where no correct option was marked
      } else if (existingQuestion.type == QuestionType.TEXT_ANSWER) {
        _textAnswerController.text = existingQuestion.correctAnswer ?? '';
      }
    } else {
      // Initialize with two empty options for new MC questions by default
      _optionControllers.add(TextEditingController());
      _optionControllers.add(TextEditingController());
    }

    await showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to manage dialog's internal state (like dropdown)
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isEditing ? 'Edit Question' : 'Add New Question'),
            content: SingleChildScrollView(
              // Allow scrolling if content overflows
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _questionTextController,
                    decoration:
                        const InputDecoration(labelText: 'Question Text'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<QuestionType>(
                    value: _selectedType,
                    items: QuestionType.values
                        .where((t) => t != QuestionType.UNKNOWN)
                        .map((type) {
                      // Exclude UNKNOWN
                      return DropdownMenuItem<QuestionType>(
                        value: type,
                        child: Text(type.name), // Display enum name
                      );
                    }).toList(),
                    onChanged: (QuestionType? newValue) {
                      if (newValue != null) {
                        setDialogState(() {
                          // Use setDialogState for dialog UI updates
                          _selectedType = newValue;
                        });
                      }
                    },
                    decoration:
                        const InputDecoration(labelText: 'Question Type'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pointsController,
                    decoration: const InputDecoration(labelText: 'Points'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  // --- Dynamic Fields based on Question Type ---
                  if (_selectedType == QuestionType.MULTIPLE_CHOICE)
                    _buildMultipleChoiceOptions(
                        setDialogState, _optionControllers, _correctOptionIndex,
                        (index) {
                      setDialogState(() => _correctOptionIndex =
                          index); // Update correct index state
                    }),
                  if (_selectedType == QuestionType.TEXT_ANSWER)
                    TextField(
                      controller: _textAnswerController,
                      decoration: const InputDecoration(
                          labelText: 'Correct Answer Text'),
                      maxLines: 2,
                    ),
                  // --- End Dynamic Fields ---
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // --- Validation ---
                  if (_questionTextController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter the question text.')));
                    return;
                  }
                  if (_pointsController.text.isEmpty ||
                      int.tryParse(_pointsController.text) == null ||
                      int.parse(_pointsController.text) <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Please enter valid points (positive number).')));
                    return;
                  }
                  // Additional validation based on type
                  if (_selectedType == QuestionType.MULTIPLE_CHOICE) {
                    if (_optionControllers.length < 2 ||
                        _optionControllers.any((c) => c.text.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please provide at least two non-empty options.')),
                      );
                      return;
                    }
                    if (_correctOptionIndex == null ||
                        _correctOptionIndex! < 0 ||
                        _correctOptionIndex! >= _optionControllers.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please mark one option as correct.')),
                      );
                      return;
                    }
                  } else if (_selectedType == QuestionType.TEXT_ANSWER) {
                    if (_textAnswerController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please provide the correct text answer.')),
                      );
                      return;
                    }
                  }
                  // --- End Validation ---

                  final newQuestion = Question(
                    // id: isEditing ? _questions[editIndex].id : null, // Keep ID if editing
                    text: _questionTextController.text,
                    type: _selectedType,
                    points: int.parse(_pointsController.text),
                    options: _selectedType == QuestionType.MULTIPLE_CHOICE
                        ? _optionControllers.asMap().entries.map((entry) {
                            int idx = entry.key;
                            TextEditingController ctrl = entry.value;
                            return Option(
                                text: ctrl.text,
                                correct: idx == _correctOptionIndex);
                          }).toList()
                        : null,
                    correctAnswer: _selectedType == QuestionType.TEXT_ANSWER
                        ? _textAnswerController.text
                        : null,
                  );

                  setState(() {
                    // Update the main screen's state
                    if (isEditing) {
                      _questions[editIndex] = newQuestion;
                    } else {
                      _questions.add(newQuestion);
                    }
                  });
                  Navigator.pop(context); // Close dialog
                },
                child: Text(isEditing ? 'Save Changes' : 'Add'),
              ),
            ],
          );
        });
      },
    );
    // Dispose controllers after dialog is closed
    _questionTextController.dispose();
    _pointsController.dispose();
    _textAnswerController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
  }

  // Helper Widget for Multiple Choice Options
  Widget _buildMultipleChoiceOptions(
      StateSetter setDialogState,
      List<TextEditingController> controllers,
      int? correctIndex,
      Function(int?) onCorrectSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Options:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...controllers.asMap().entries.map((entry) {
          int idx = entry.key;
          TextEditingController ctrl = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    decoration: InputDecoration(labelText: 'Option ${idx + 1}'),
                  ),
                ),
                Radio<int?>(
                  value: idx,
                  groupValue: correctIndex,
                  onChanged: onCorrectSelected,
                  visualDensity: VisualDensity.compact, // Make radio smaller
                ),
                const Text('Correct'),
                // Only show remove button if more than 2 options
                if (controllers.length > 2)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red, size: 20),
                    tooltip: 'Remove Option',
                    onPressed: () {
                      setDialogState(() {
                        ctrl.dispose(); // Dispose controller before removing
                        controllers.removeAt(idx);
                        // Adjust correct index if necessary
                        if (correctIndex == idx) {
                          onCorrectSelected(null); // Unset correct option
                        } else if (correctIndex != null && correctIndex > idx) {
                          onCorrectSelected(
                              correctIndex - 1); // Shift index down
                        }
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 8),
        TextButton.icon(
          icon: const Icon(Icons.add_circle_outline, size: 18),
          label: const Text('Add Option'),
          onPressed: () {
            setDialogState(() {
              controllers.add(TextEditingController());
            });
          },
        ),
      ],
    );
  }

  // Placeholder for editing (calls the same dialog)
  void _editQuestion(int index) {
    _showQuestionDialog(editIndex: index);
  }

  // Method to remove a question
  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  // Updated _addQuestion to call the dialog
  void _addQuestion() {
    _showQuestionDialog();
  }

  Future<void> _submitQuiz() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix errors in the form.')),
      );
      return;
    }
    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a course.')),
      );
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates.')),
      );
      return;
    }
    if (_startDate!.isAfter(_endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start date must be before end date.')),
      );
      return;
    }
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final quiz = Quiz(
      title: _titleController.text,
      description: _descriptionController.text,
      courseId: _selectedCourse!.id,
      startDate: _startDate!,
      endDate: _endDate!,
      durationMinutes: int.parse(_durationController.text),
      questions: _questions,
      // isPublished: false, // Default to draft? Depends on API/requirements
    );

    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final response = await quizProvider.createQuiz(quiz);

    if (!mounted) return; // Check if widget is still mounted

    setState(() => _isLoading = false);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Quiz created successfully!'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Go back to management screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to create quiz: ${response['message'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red),
      );
    }
  }
}
