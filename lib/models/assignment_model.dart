class Assignment {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final int maxPoints;
  final List<AssignmentFile>? files;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.maxPoints,
    this.files,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      maxPoints: json['maxPoints'] ?? 0,
      files: json['files'] != null
          ? (json['files'] as List)
              .map((f) => AssignmentFile.fromJson(f))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'maxPoints': maxPoints,
      'files': files?.map((f) => f.toJson()).toList(),
    };
  }
}

class AssignmentFile {
  final String fileName;
  final String fileUrl;
  final String contentType;
  final int fileSize;

  AssignmentFile({
    required this.fileName,
    required this.fileUrl,
    required this.contentType,
    required this.fileSize,
  });

  factory AssignmentFile.fromJson(Map<String, dynamic> json) {
    return AssignmentFile(
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      contentType: json['contentType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
      'contentType': contentType,
      'fileSize': fileSize,
    };
  }
}

class AssignmentSubmission {
  final int id;
  final int assignmentId;
  final String notes;
  final String submissionDate;
  final bool graded;
  final bool late;
  final int? score;
  final String? feedback;
  final List<AssignmentFile>? files;

  AssignmentSubmission({
    required this.id,
    required this.assignmentId,
    required this.notes,
    required this.submissionDate,
    required this.graded,
    required this.late,
    this.score,
    this.feedback,
    this.files,
  });

  factory AssignmentSubmission.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmission(
      id: json['id'],
      assignmentId: json['assignment']['id'],
      notes: json['notes'] ?? '',
      submissionDate: json['submissionDate'] ?? '',
      graded: json['graded'] ?? false,
      late: json['late'] ?? false,
      score: json['score'],
      feedback: json['feedback'],
      files: json['files'] != null
          ? (json['files'] as List)
              .map((f) => AssignmentFile.fromJson(f))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'notes': notes,
      'submissionDate': submissionDate,
      'graded': graded,
      'late': late,
      'score': score,
      'feedback': feedback,
      'files': files?.map((f) => f.toJson()).toList(),
    };
  }
}
