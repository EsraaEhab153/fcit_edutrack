import 'package:flutter/material.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:fci_edutrack/providers/course_provider.dart';
import 'package:fci_edutrack/providers/attendance_provider.dart';
import 'package:fci_edutrack/services/api_service.dart';

class RegisterAttendanceScreen extends StatefulWidget {
  static const String routeName = 'register_attendance_screen';

  const RegisterAttendanceScreen({super.key});

  @override
  State<RegisterAttendanceScreen> createState() =>
      _RegisterAttendanceScreenState();
}

class _RegisterAttendanceScreenState extends State<RegisterAttendanceScreen> {
  int? _selectedCourseId;
  bool _isLoading = false;
  bool _isScanning = false;
  String? _error;
  String? _success;
  String? _networkIdentifier;
  String? _scanResult;
  List<dynamic> _courses = [];
  final TextEditingController _codeController = TextEditingController();

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark();
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      backgroundColor:
          isDark ? MyAppColors.primaryDarkColor : MyAppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Record Attendance',
          style: TextStyle(
            color: isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _courses.isEmpty
              ? _buildNoCourses(isDark)
              : DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey.shade100,
                        child: const TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(Icons.qr_code_scanner),
                              text: 'QR Scan',
                            ),
                            Tab(
                              icon: Icon(Icons.pin),
                              text: 'Code Entry',
                            ),
                          ],
                          labelColor: MyAppColors.primaryColor,
                          indicatorColor: MyAppColors.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // QR Scanner tab
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  // ... existing QR scanner code ...
                                  _buildCourseSelector(isDark),

                                  _isScanning
                                      ? _buildQrCodeScanner(isDark)
                                      : _buildScannerPrompt(isDark),

                                  if (_scanResult != null) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'QR Code: $_scanResult',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],

                                  if (_error != null) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.error,
                                              color: Colors.red),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _error!,
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  if (_success != null) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle,
                                              color: Colors.green),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _success!,
                                              style: const TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Verification Code tab
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCourseSelector(isDark),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Enter Verification Code',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _codeController,
                                      decoration: const InputDecoration(
                                        labelText: '6-Digit Code',
                                        hintText:
                                            'Enter the code provided by your professor',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.pin),
                                      ),
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _submitVerificationCode,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              MyAppColors.primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        child: const Text(
                                          'Submit Attendance',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.blue.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.info_outline,
                                              color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Your professor will provide a 6-digit code during class that is valid for 15 minutes.',
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_error != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.error,
                                                color: Colors.red),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _error!,
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (_success != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.check_circle,
                                                color: Colors.green),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _success!,
                                                style: const TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _fetchCourses() {
    // Fetch courses from the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false).fetchCurrentCourses();
    });
  }

  Widget _buildNoCourses(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'You are not enrolled in any courses yet',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyAppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Go back'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseSelector(bool isDark) {
    final courseProvider = Provider.of<CourseProvider>(context);
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Course',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      ),
      value: _selectedCourseId,
      hint: const Text('Select a course'),
      items: courseProvider.currentCourses
          .map((course) => DropdownMenuItem(
                value: course.id,
                child: Text('${course.courseCode} - ${course.courseName}'),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCourseId = value;
        });
      },
    );
  }

  Widget _buildQrCodeScanner(bool isDark) {
    // Implementation of _buildQrCodeScanner method
    // This is a placeholder and should be replaced with the actual implementation
    return Container();
  }

  Widget _buildScannerPrompt(bool isDark) {
    // Implementation of _buildScannerPrompt method
    // This is a placeholder and should be replaced with the actual implementation
    return Container();
  }

  void _submitVerificationCode() async {
    // Make sure a course is selected
    if (_selectedCourseId == null) {
      setState(() {
        _error = 'Please select a course';
        _success = null;
      });
      return;
    }

    // Validate the verification code
    final code = _codeController.text.trim();
    if (code.length != 6 || int.tryParse(code) == null) {
      setState(() {
        _error = 'Please enter a valid 6-digit code';
        _success = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });

    try {
      // Here we would normally call the API with the verification code
      // For now, we'll simulate a successful API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _success = 'Attendance recorded successfully!';
        _codeController.clear();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to record attendance: ${e.toString()}';
      });
    }
  }
}
