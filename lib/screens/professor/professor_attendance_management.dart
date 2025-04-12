import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // For potential future use
// Import other necessary providers and services later

class ProfessorAttendanceManagementScreen extends StatefulWidget {
  const ProfessorAttendanceManagementScreen({super.key});

  @override
  State<ProfessorAttendanceManagementScreen> createState() =>
      _ProfessorAttendanceManagementScreenState();
}

class _ProfessorAttendanceManagementScreenState
    extends State<ProfessorAttendanceManagementScreen> {
  // TODO: Implement state variables for course selection, expiry time, active sessions list, etc.
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    // TODO: Fetch professor's courses or active sessions initially if needed
  }

  // TODO: Implement method to create a new attendance session (call API)
  Future<void> _createSession() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    // Placeholder - Replace with actual API call using selected course and expiry
    await Future.delayed(const Duration(seconds: 1));
    print("Placeholder: Create Session logic goes here.");
    setState(() {
      _isLoading = false;
      _successMessage = "Session created successfully (Placeholder)";
    });
    // Handle errors appropriately
  }

  // TODO: Implement method to fetch active sessions (call API)
  Future<void> _fetchActiveSessions() async {
    setState(() => _isLoading = true);
    // Placeholder
    await Future.delayed(const Duration(seconds: 1));
    print("Placeholder: Fetch active sessions logic.");
    setState(() => _isLoading = false);
  }

  // TODO: Implement method to view session attendees (navigate or show dialog)
  void _viewAttendees(int sessionId) {
    print("Placeholder: View attendees for session $sessionId");
    // Navigate to a new screen or show a dialog with attendee list
  }

  // TODO: Implement method to download spreadsheet (call API)
  void _downloadSpreadsheet(int courseId) {
    print("Placeholder: Download spreadsheet for course $courseId");
    // Call API service, handle byte stream response for download
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Build the UI for managing attendance sessions
    return Scaffold(
      // AppBar might be handled by MyBottomNavBar, or add one here if needed
      body: RefreshIndicator(
        onRefresh: _fetchActiveSessions, // Example refresh action
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Section to Create New Session
            _buildCreateSessionCard(),
            const SizedBox(height: 20),
            // Section to View Active Sessions
            _buildActiveSessionsList(),
            const SizedBox(height: 20),
            // Section for Reports (Optional Here or Separate Screen)
            _buildReportsSection(),

            // Display loading/error/success messages
            if (_isLoading)
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator())),
            if (_errorMessage != null)
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_errorMessage!,
                          style: const TextStyle(color: Colors.red)))),
            if (_successMessage != null)
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_successMessage!,
                          style: const TextStyle(color: Colors.green)))),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateSessionCard() {
    // TODO: Add course dropdown, expiry input, create button
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create New Session',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // Placeholder for Course Dropdown
            const Text('Course Dropdown Here'),
            const SizedBox(height: 12),
            // Placeholder for Expiry Input
            const Text('Expiry Minutes Input Here'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _createSession,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Start Session'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSessionsList() {
    // TODO: Fetch and display list of active sessions
    // Each item could show course, code, expiry, and a button to view attendees
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active Sessions',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // Placeholder for list view
            const Text('List of active sessions will appear here...'),
            // Example list item structure:
            // ListTile(
            //   title: Text('CS101 - Code: ABCDEF'),
            //   subtitle: Text('Expires: 10:45 AM'),
            //   trailing: TextButton(onPressed: () => _viewAttendees(123), child: Text('View')),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsSection() {
    // TODO: Add course dropdown and download button
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attendance Reports',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // Placeholder for Course Dropdown
            const Text('Course Dropdown Here (for report selection)'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () => _downloadSpreadsheet(1), // Placeholder ID
              icon: const Icon(Icons.download_outlined),
              label: const Text('Download Report (CSV)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
