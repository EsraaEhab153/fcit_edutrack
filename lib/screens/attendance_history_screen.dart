import 'package:fci_edutrack/models/attendance_model.dart';
import 'package:fci_edutrack/providers/attendance_provider.dart';
import 'package:fci_edutrack/providers/auth_provider.dart';
import 'package:fci_edutrack/providers/course_provider.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  static const String routeName = 'attendance_history';

  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  Map<int, List<Attendance>> courseAttendance = {};
  Map<int, bool> expandedCourses = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load attendance history when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });

      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final attendanceProvider =
          Provider.of<AttendanceProvider>(context, listen: false);

      // Clear any previous attendance records
      attendanceProvider.clearAttendanceRecords();

      // Make sure we're fetching enrolled courses, not current courses
      await courseProvider.fetchEnrolledCourses();

      if (courseProvider.enrolledCourses.isNotEmpty) {
        for (var course in courseProvider.enrolledCourses) {
          // Pass empty string as userId since we're using the current user endpoint now
          await attendanceProvider.fetchUserAttendance("", course.id);

          // Initialize all courses as collapsed
          expandedCourses[course.id] = false;
        }
      } else {
        print("No enrolled courses found");
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  // Calculate attendance percentage for a course
  double calculateAttendancePercentage(int courseId) {
    final attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    final attendanceRecords =
        attendanceProvider.getAttendanceForCourse(courseId);

    if (attendanceRecords.isEmpty) {
      return 0.0;
    }

    // Total number of classes should be determined by schedule
    // For now, let's assume all scheduled classes have been held
    // In a real app, you'd compare with the schedule
    final records = attendanceRecords;

    // Get the course from provider
    final course = Provider.of<CourseProvider>(context, listen: false)
        .enrolledCourses
        .firstWhere((c) => c.id == courseId);

    // For demo purposes, calculate based on days since course creation
    // Estimate number of classes that should have been held
    final now = DateTime.now();
    const classesPerWeek = 2; // Assuming 2 classes per week
    int totalClassesShouldHaveBeenHeld =
        classesPerWeek; // At least one week of classes

    if (records.isEmpty) return 0.0;

    final attendedClasses = records.length;
    if (totalClassesShouldHaveBeenHeld == 0) return 100.0;

    return (attendedClasses / totalClassesShouldHaveBeenHeld) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark();
    final courseProvider = Provider.of<CourseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      backgroundColor:
          isDark ? MyAppColors.primaryDarkColor : MyAppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Attendance History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Records',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your attendance for all enrolled courses',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // List of courses with attendance percentage
            Expanded(
              child: isLoading || courseProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : courseProvider.enrolledCourses.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'You are not enrolled in any courses yet',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: courseProvider.enrolledCourses.length,
                          itemBuilder: (context, index) {
                            final course =
                                courseProvider.enrolledCourses[index];
                            final attendancePercentage =
                                calculateAttendancePercentage(course.id);
                            final isExpanded =
                                expandedCourses[course.id] ?? false;
                            final attendanceRecords = attendanceProvider
                                .getAttendanceForCourse(course.id);

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: isDark
                                  ? MyAppColors.primaryDarkColor
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          expandedCourses[course.id] =
                                              !isExpanded;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  course.courseName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  course.courseCode,
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.grey.shade400
                                                        : Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: attendancePercentage >= 75
                                                  ? Colors.green
                                                      .withOpacity(0.15)
                                                  : attendancePercentage >= 50
                                                      ? Colors.orange
                                                          .withOpacity(0.15)
                                                      : Colors.red
                                                          .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '${attendancePercentage.toStringAsFixed(1)}%',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: attendancePercentage >=
                                                        75
                                                    ? Colors.green
                                                    : attendancePercentage >= 50
                                                        ? Colors.orange
                                                        : Colors.red,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Divider(height: 1),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildAttendanceInfoItem(
                                            'Attended',
                                            '${attendanceRecords.length}',
                                            Icons.check_circle_outline,
                                            Colors.green,
                                            isDark),
                                        _buildAttendanceInfoItem(
                                            'Total Classes',
                                            '2', // Placeholder for total scheduled classes
                                            Icons.calendar_today,
                                            Colors.blue,
                                            isDark),
                                        _buildAttendanceInfoItem(
                                            'Last Attended',
                                            attendanceRecords.isNotEmpty
                                                ? DateFormat('MMM d').format(
                                                    DateTime.parse(
                                                            attendanceRecords
                                                                .first
                                                                .timestamp)
                                                        .toLocal())
                                                : 'Never',
                                            Icons.access_time,
                                            Colors.blue,
                                            isDark),
                                      ],
                                    ),

                                    // Expanded attendance details
                                    if (isExpanded) ...[
                                      const SizedBox(height: 16),
                                      const Divider(height: 1),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Attendance Details',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (attendanceRecords.isEmpty)
                                        Text(
                                          'No attendance records found',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey.shade400
                                                : Colors.grey.shade700,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        )
                                      else
                                        ...attendanceRecords.map((record) {
                                          final recordDate =
                                              DateTime.parse(record.timestamp)
                                                  .toLocal();
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  DateFormat(
                                                          'EEEE, MMMM d, yyyy - HH:mm')
                                                      .format(recordDate),
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceInfoItem(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
