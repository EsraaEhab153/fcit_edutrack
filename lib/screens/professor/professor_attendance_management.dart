import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // For potential future use
import '../../models/course_model.dart'; // Import Course model
import '../../providers/course_provider.dart'; // Import CourseProvider
import 'attendance_recording_screen.dart'; // Import the target screen
import '../../style/my_app_colors.dart'; // Import colors
// TODO: Import the screen containing the main course list if needed for "Browse Courses"

class ProfessorAttendanceManagementScreen extends StatefulWidget {
  const ProfessorAttendanceManagementScreen({super.key});

  @override
  State<ProfessorAttendanceManagementScreen> createState() =>
      _ProfessorAttendanceManagementScreenState();
}

class _ProfessorAttendanceManagementScreenState
    extends State<ProfessorAttendanceManagementScreen> {
  // Removed local loading/error/success states, will rely on Provider
  // bool _isLoading = false;
  // String? _errorMessage;
  // String? _successMessage;

  @override
  void initState() {
    super.initState();
    // Fetch enrolled courses when the screen initializes
    // Use addPostFrameCallback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchEnrolledCourses();
    });
  }

  Future<void> _fetchEnrolledCourses() async {
    // Access provider without listening here, Consumer will handle updates
    final courseProvider =
        Provider.of<CourseProvider>(context, listen: false); // Corrected type
    // Use the specific method to fetch enrolled courses
    await courseProvider.fetchEnrolledCourses();
    // Error handling can be done within the provider or shown via SnackBar if needed
  }

  // Removed placeholder methods for create/fetch/view/download as they are not needed here

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen for changes in CourseProvider
    return Scaffold(
      // AppBar might be handled by MyBottomNavBar, or add one here if needed
      body: Consumer<CourseProvider>(
        // Corrected type
        builder: (context, courseProvider, child) {
          return RefreshIndicator(
            onRefresh: _fetchEnrolledCourses, // Refresh action
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Course to Manage Attendance',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: MyAppColors.primaryColor,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildCourseList(courseProvider),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseList(CourseProvider courseProvider) {
    // Corrected type
    if (courseProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final enrolledCourses = courseProvider.enrolledCourses;

    if (enrolledCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are not enrolled in any courses yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement navigation to the main course browsing screen
                print("Navigate to Browse Courses");
                // Example: Navigator.pushNamed(context, ProfessorHomeScreen.routeName); // Or wherever courses are listed
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Navigation to Browse Courses not implemented yet.')),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Browse Courses'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    MyAppColors.secondaryBlueColor, // Corrected color name
              ),
            ),
          ],
        ),
      );
    }

    // Display list of enrolled courses
    return ListView.builder(
      itemCount: enrolledCourses.length,
      itemBuilder: (context, index) {
        final course = enrolledCourses[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              '${course.courseCode} - ${course.courseName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(course.description ?? 'No description'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.primaryColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceRecordingScreen(
                      // Corrected constructor call
                      courseId: course.id, // Pass the course ID
                      courseName:
                          course.courseName, // Pass course name for display
                      courseCode:
                          course.courseCode, // Pass course code for display
                    ),
                  ),
                );
              },
              child: const Text('Select'),
            ),
          ),
        );
      },
    );
  }
}
