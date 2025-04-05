import 'package:flutter/material.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:intl/intl.dart';

class AttendanceRecordingScreen extends StatefulWidget {
  static const String routeName = 'attendance_recording';

  const AttendanceRecordingScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceRecordingScreen> createState() =>
      _AttendanceRecordingScreenState();
}

class _AttendanceRecordingScreenState extends State<AttendanceRecordingScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> courses = [];
  Map<String, dynamic>? selectedCourse;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadProfessorCourses();
  }

  Future<void> _loadProfessorCourses() async {
    setState(() {
      isLoading = true;
    });

    try {
      // TODO: Implement API call to get professor's courses

      // Mock data for UI development
      courses = [
        {
          'id': '1',
          'code': 'CS101',
          'name': 'Introduction to Programming',
          'students': 28,
          'classesRecorded': 14,
        },
        {
          'id': '2',
          'code': 'CS202',
          'name': 'Data Structures',
          'students': 22,
          'classesRecorded': 12,
        },
        {
          'id': '3',
          'code': 'CS303',
          'name': 'Database Systems',
          'students': 18,
          'classesRecorded': 10,
        },
      ];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load courses: $e')),
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
          'Record Attendance',
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
          : selectedCourse == null
              ? _buildCourseSelection()
              : _buildAttendanceRecorder(),
    );
  }

  Widget _buildCourseSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a Course',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: courses.isEmpty
                ? const Center(
                    child: Text(
                      'No courses found. Please check your assignments.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            '${course['code']} - ${course['name']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.people,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('${course['students']} students'),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.calendar_today,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                      '${course['classesRecorded']} classes recorded'),
                                ],
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyAppColors.primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedCourse = course;
                              });
                            },
                            child: const Text('Select'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRecorder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedCourse = null;
                  });
                },
              ),
              Expanded(
                child: Text(
                  '${selectedCourse!['code']} - ${selectedCourse!['name']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Date selector
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${DateFormat('EEEE, MMMM d, yyyy').format(selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Class Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Topic Covered',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.subject),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  initialValue: '10:00 AM',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  initialValue: '11:30 AM',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recording a class helps track the total number of classes for attendance calculations. Students can scan the QR code during class to mark their attendance.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _recordClass,
              child: const Text(
                'Record Class & Generate QR Code',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _recordClass() {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog

      // Show success dialog with QR code
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Class Recorded'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'QR Code for Student Attendance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.qr_code, size: 150),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Students can scan this QR code to mark their attendance for this class',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                // Reset to course selection
                setState(() {
                  selectedCourse = null;
                });
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    });
  }
}
