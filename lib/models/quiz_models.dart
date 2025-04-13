import 'package:intl/intl.dart'; // For date parsing/formatting if needed directly

// Enum for Question Type
enum QuestionType {
  MULTIPLE_CHOICE,
  TEXT_ANSWER,
  UNKNOWN // Default for safety
}

// Helper to convert String to QuestionType and vice-versa
QuestionType questionTypeFromString(String? type) {
  switch (type?.toUpperCase()) {
    case 'MULTIPLE_CHOICE':
      return QuestionType.MULTIPLE_CHOICE;
    case 'TEXT_ANSWER':
      return QuestionType.TEXT_ANSWER;
    default:
      print("Warning: Unknown QuestionType string '$type'");
      return QuestionType.UNKNOWN;
  }
}

String questionTypeToString(QuestionType type) {
  switch (type) {
    case QuestionType.MULTIPLE_CHOICE:
      return 'MULTIPLE_CHOICE';
    case QuestionType.TEXT_ANSWER:
      return 'TEXT_ANSWER';
    case QuestionType.UNKNOWN:
      return 'UNKNOWN'; // Or handle appropriately
  }
}

// Model for Quiz Option (for Multiple Choice questions)
class Option {
  final int? id; // Optional ID from backend response
  final String text;
  final bool correct;

  Option({
    this.id,
    required this.text,
    required this.correct,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'], // May be null when creating
      text: json['text'] ?? '',
      correct: json['correct'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Don't include 'id' when sending for creation unless backend requires it
      'text': text,
      'correct': correct,
    };
  }
}

// Model for Quiz Question
class Question {
  final int? id; // Optional ID from backend response
  final String text;
  final QuestionType type;
  final int points;
  final List<Option>? options; // Nullable, only for MULTIPLE_CHOICE
  final String? correctAnswer; // Nullable, only for TEXT_ANSWER

  Question({
    this.id,
    required this.text,
    required this.type,
    required this.points,
    this.options,
    this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var type = questionTypeFromString(json['type']);
    List<Option>? optionsList;
    if (type == QuestionType.MULTIPLE_CHOICE && json['options'] != null) {
      var optionsData = json['options'] as List;
      optionsList =
          optionsData.map((optJson) => Option.fromJson(optJson)).toList();
    }

    return Question(
      id: json['id'],
      text: json['text'] ?? '',
      type: type,
      points: json['points'] ?? 0,
      options: optionsList,
      correctAnswer: json['correctAnswer'], // Will be null if not TEXT_ANSWER
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      // Don't include 'id' when sending for creation
      'text': text,
      'type': questionTypeToString(type),
      'points': points,
    };
    if (type == QuestionType.MULTIPLE_CHOICE && options != null) {
      data['options'] = options!.map((opt) => opt.toJson()).toList();
    }
    if (type == QuestionType.TEXT_ANSWER && correctAnswer != null) {
      data['correctAnswer'] = correctAnswer;
    }
    return data;
  }
}

// Model for Quiz
class Quiz {
  final int? id; // Optional ID from backend response
  final String title;
  final String description;
  final int courseId;
  final DateTime startDate;
  final DateTime endDate;
  final int durationMinutes;
  final List<Question> questions;
  // Add other fields if present in response, e.g., isPublished
  final bool? isPublished;

  Quiz({
    this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.startDate,
    required this.endDate,
    required this.durationMinutes,
    required this.questions,
    this.isPublished,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    var questionsData = json['questions'] as List?;
    List<Question> questionsList = questionsData != null
        ? questionsData.map((qJson) => Question.fromJson(qJson)).toList()
        : [];

    return Quiz(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      courseId: json['courseId'] ?? 0, // Provide default or handle error
      startDate: DateTime.tryParse(json['startDate'] ?? '') ??
          DateTime.now(), // Handle parsing error
      endDate: DateTime.tryParse(json['endDate'] ?? '') ??
          DateTime.now().add(const Duration(days: 1)), // Handle parsing error
      durationMinutes: json['durationMinutes'] ?? 0,
      questions: questionsList,
      isPublished: json['isPublished'], // May be null
    );
  }

  Map<String, dynamic> toJson() {
    // Format dates back to ISO 8601 string for the API
    final DateFormat formatter = DateFormat("yyyy-MM-ddTHH:mm:ss");

    return {
      // Don't include 'id' when sending for creation
      'title': title,
      'description': description,
      'courseId': courseId,
      'startDate':
          formatter.format(startDate.toUtc()), // Send as UTC ISO string
      'endDate': formatter.format(endDate.toUtc()), // Send as UTC ISO string
      'durationMinutes': durationMinutes,
      'questions': questions.map((q) => q.toJson()).toList(),
      // 'isPublished' might not be sent during creation, depends on API
    };
  }
}
