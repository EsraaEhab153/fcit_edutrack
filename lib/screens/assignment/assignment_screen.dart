import 'dart:io';
import 'dart:typed_data';

import 'package:fci_edutrack/models/assignment_model.dart';
import 'package:fci_edutrack/providers/assignment_provider.dart';
import 'package:fci_edutrack/providers/auth_provider.dart';
import 'package:fci_edutrack/providers/course_provider.dart';
import 'package:fci_edutrack/screens/assignment/assignment_card.dart';
import 'package:fci_edutrack/services/api_service.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:fci_edutrack/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../themes/my_theme_data.dart';

class AssignmentScreen extends StatefulWidget {
  static const String routeName = 'assignment_screen';
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  bool _initialized = false;
  bool _isProfessor = false;
  List assignments = [];
  Future<List<AssignmentSubmission>>? _historyFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final assignmentProvider =
          Provider.of<AssignmentProvider>(context, listen: false);
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      assignmentProvider.updateCourseProvider(courseProvider);
      // Determine role
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Properly handle the async operation
      authProvider.isProfessor().then((isProfessor) {
        setState(() {
          _isProfessor = isProfessor;
        });
        if (_isProfessor) {
          assignmentProvider.fetchProfessorAssignments();
        } else {
          assignmentProvider.fetchStudentAssignments().then((_) {
            setState(() {
              _historyFuture = _loadHistory();
            });
          });
        }
        _initialized = true;
      });
    }
  }

  Future<List<AssignmentSubmission>> _loadHistory() async {
    final api = ApiService();
    final response = await api.getStudentSubmissions();
    final rawSubs = <AssignmentSubmission>[];
    if (response['success'] == true && response['data'] != null) {
      // First, collect all assignmentIds to fetch details in batches
      Set<int> assignmentIds = {};

      for (var json in response['data']) {
        rawSubs.add(AssignmentSubmission.fromJson(json));
        final assignmentId = json['assignmentId'] ??
            (json['assignment'] is Map ? json['assignment']['id'] : null);
        if (assignmentId != null) {
          assignmentIds.add(assignmentId);
        }
      }

      // Create a map to store assignment details
      Map<int, Assignment> assignmentDetails = {};

      // Fetch detailed information for each assignment
      for (int assignmentId in assignmentIds) {
        try {
          final assignmentResponse =
              await api.getAssignmentDetails(assignmentId);
          if (assignmentResponse['success'] == true &&
              assignmentResponse['data'] != null) {
            final details = Assignment.fromJson(assignmentResponse['data']);
            assignmentDetails[assignmentId] = details;
          }
        } catch (e) {
          print('Error fetching assignment details for ID $assignmentId: $e');
        }
      }

      // Now enrich our submissions with assignment details
      for (var sub in rawSubs) {
        final details = assignmentDetails[sub.assignmentId];
        if (details != null && sub.assignmentTitle == null) {
          // Create a new submission with the title included
          final enrichedSub = AssignmentSubmission(
            id: sub.id,
            studentId: sub.studentId,
            studentName: sub.studentName,
            assignmentTitle: details.title,
            assignmentId: sub.assignmentId,
            notes: sub.notes,
            submissionDate: sub.submissionDate,
            graded: sub.graded,
            late: sub.late,
            score: sub.score,
            feedback: sub.feedback,
            files: sub.files,
          );

          // Replace the original submission
          rawSubs[rawSubs.indexOf(sub)] = enrichedSub;
        }
      }
    }

    final grouped = <int, List<AssignmentSubmission>>{};
    for (var sub in rawSubs) {
      grouped.putIfAbsent(sub.assignmentId, () => []).add(sub);
    }
    final processed = <AssignmentSubmission>[];
    grouped.forEach((_, subs) {
      subs.sort((a, b) => DateTime.parse(b.submissionDate)
          .compareTo(DateTime.parse(a.submissionDate)));
      processed.addAll(subs.where((s) => s.graded));
      final ungraded = subs.where((s) => !s.graded).toList();
      if (ungraded.isNotEmpty) processed.add(ungraded.first);
    });
    processed.sort((a, b) => DateTime.parse(b.submissionDate)
        .compareTo(DateTime.parse(a.submissionDate)));
    return processed;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentProvider>(
      builder: (context, provider, child) {
        final theme = Provider.of<ThemeProvider>(context);
        final isDark = theme.isDark();
        final assignments = _isProfessor
            ? provider.professorAssignments
            : provider
                .studentAssignments; // Use appropriate assignments based on role

        // Check if there's a local draft
        final hasDraft = provider.hasDraft;

        return Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: _isProfessor
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    'Assignments',
                    style: MyThemeData.lightModeStyle.textTheme.titleMedium!
                        .copyWith(
                            color: MyAppColors.primaryColor, fontSize: 24),
            ),
                )
              : AppBar(
                  title: Text(
                    'Assignments',
                    style: MyThemeData.lightModeStyle.textTheme.titleMedium!
                        .copyWith(color: MyAppColors.whiteColor),
                  ),
                  elevation: 0,
                  centerTitle: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).size.width * 0.1),
                      bottomRight: Radius.circular(
                          MediaQuery.of(context).size.width * 0.1),
                    ),
                  ),
                  backgroundColor: MyAppColors.primaryColor,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
          body: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark
                    ? MyAppColors.primaryDarkColor
                    : Colors.blue.shade50),
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isProfessor
                    ? (assignments.isEmpty
                        ? const Center(child: Text('No assignments found.'))
                        : RefreshIndicator(
                            onRefresh: () async {
                              await Provider.of<AssignmentProvider>(context,
                                      listen: false)
                                  .fetchProfessorAssignments();
                            },
                            child: ListView.builder(
                              itemCount: assignments.length,
                              itemBuilder: (context, index) {
                                return AssignmentCard(
                                    assignment: assignments[index],
                                    isProfessor: true,
                                    isDraft: false);
                              },
                            ),
                          ))
                    : RefreshIndicator(
                        onRefresh: () async {
                          final provider = Provider.of<AssignmentProvider>(
                              context,
                              listen: false);
                          await provider.fetchStudentAssignments();
                          setState(() {
                            _historyFuture = _loadHistory();
                          });
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Active Assignments',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ),
                              ...assignments.map((assignment) => AssignmentCard(
                                  assignment: assignment,
                                  isProfessor: false,
                                  isDraft: false)),
                              const SizedBox(height: 16),
                              const Divider(),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Submission History',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ),
                              FutureBuilder<List<AssignmentSubmission>>(
                                future: _historyFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  if (snapshot.hasError)
                                    return const Center(
                                        child: Text('Error loading history'));
                                  final history = snapshot.data ?? [];
                                  if (history.isEmpty)
                                    return const Center(
                                        child:
                                            Text('No submissions in history.'));
                                  return Column(
                                    children: history.map((sub) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: ExpansionTile(
                                          title: Text(sub.assignmentTitle ??
                                              'Assignment'),
                                          subtitle: Text(
                                              'Submitted: ${DateFormatter.formatDateString(sub.submissionDate)}'),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (sub.notes.isNotEmpty) ...[
                                                    Text('Notes:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(sub.notes),
                                                    SizedBox(height: 8),
                                                  ],
                                                  if (sub.files != null &&
                                                      sub.files!
                                                          .isNotEmpty) ...[
                                                    Text('Files:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(height: 4),
                                                    ...sub.files!.map((file) {
                                                      bool isImage = file
                                                          .contentType
                                                          .startsWith('image/');
                                                      return ListTile(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4),
                                                        leading: Icon(
                                                          isImage
                                                              ? Icons.image
                                                              : Icons
                                                                  .insert_drive_file,
                                                            color: Colors.blue),
                                                        title: Text(
                                                          file.fileName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        subtitle: Text(
                                                          '${(file.fileSize / 1024).toStringAsFixed(1)} KB',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        onTap: () =>
                                                            _openSubmissionFile(
                                                                file),
                                                        dense: true,
                                                      );
                                                    }).toList(),
                                                  ],
                                                  if (sub.graded) ...[
                                                    Text('Score: ${sub.score}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    if (sub.feedback != null &&
                                                        sub.feedback!
                                                            .isNotEmpty) ...[
                                                      SizedBox(height: 8),
                                                      Text('Feedback:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(sub.feedback!),
                                                    ],
                                                  ] else
                                                    Text(
                                                        'Status: Pending grading',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.orange)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
          floatingActionButton: _isProfessor
              ? FloatingActionButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                        context, 'assignment_create_screen');
                    if (result == true) {
                      Provider.of<AssignmentProvider>(context, listen: false)
                          .fetchProfessorAssignments();
                    }
                    // Force refresh to update UI based on draft status
                    setState(() {});
                  },
                  backgroundColor: MyAppColors.primaryColor,
                  child: const Icon(Icons.add),
                  tooltip: 'Create Assignment',
                )
              : null,
        );
      },
    );
  }

  // Helper method to open submission files with authentication
  void _openSubmissionFile(AssignmentFile file) async {
    final ApiService apiService = ApiService();
    final bool isImage = file.contentType.startsWith('image/');

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening ${file.fileName}...')),
      );

      if (isImage) {
        // Get image with authentication
        final response = await apiService.openFile(file.fileUrl, isImage: true);

        if (!mounted) return;

        if (response['success'] && response['bytes'] != null) {
          final Uint8List imageBytes = response['bytes'];

          // Show image in dialog
          showDialog(
            context: context,
            builder: (ctx) => Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text(file.fileName),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      )
                    ],
                  ),
                  InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: EdgeInsets.all(20),
                    minScale: 0.5,
                    maxScale: 4,
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.open_in_new),
                    label: Text('Open in external app'),
                    onPressed: () async {
                      try {
                        // Save to temporary file
                        final tempDir = await getTemporaryDirectory();
                        final fileName = file.fileName.isNotEmpty
                            ? file.fileName
                            : 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
                        final tempFile = File('${tempDir.path}/$fileName');
                        await tempFile.writeAsBytes(imageBytes);

                        Navigator.of(ctx).pop(); // Close dialog

                        // Open file
                        final result = await OpenFile.open(tempFile.path);
                        if (result.type != ResultType.done) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Could not open file: ${result.message}')),
                          );
                        }
                      } catch (e) {
                        print('Error opening image in external app: $e');
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error opening image: $e')),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response['message'] ?? 'Could not load image')),
          );
        }
      } else {
        // For non-images, open the file with authentication
        final response = await apiService.openFile(file.fileUrl);

        if (!mounted) return;

        if (response['success'] && response['bytes'] != null) {
          final Uint8List bytes = response['bytes'];

          // Save to temporary file
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/${file.fileName}';
          final tempFile = File(filePath);
          await tempFile.writeAsBytes(bytes);

          // Open the file
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open file: ${result.message}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response['message'] ?? 'Could not open file')),
          );
        }
      }
    } catch (e) {
      print('Error opening file: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening file: $e')),
      );
    }
  }
}
