import 'package:flutter/material.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:fci_edutrack/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfessorRequestsScreen extends StatefulWidget {
  static const String routeName = 'admin_professor_requests_screen';

  const ProfessorRequestsScreen({Key? key}) : super(key: key);

  @override
  State<ProfessorRequestsScreen> createState() =>
      _ProfessorRequestsScreenState();
}

class _ProfessorRequestsScreenState extends State<ProfessorRequestsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingRequests();
  }

  Future<void> _fetchPendingRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print("Fetching pending professor requests...");
      final response = await _apiService.getPendingProfessorRequests();
      print("Pending requests response: $response");

      if (response['success'] && response['data'] != null) {
        setState(() {
          _requests = response['data'];
        });
        print("Found ${_requests.length} pending requests");
      } else {
        setState(() {
          _errorMessage =
              response['message'] ?? "Failed to fetch pending requests";
        });
        print("Failed to fetch pending requests: $_errorMessage");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
      });
      print("Exception fetching pending requests: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _reviewRequest(String requestId, bool isApproved) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response =
          await _apiService.reviewProfessorRequest(requestId, isApproved);

      if (response['success']) {
        // Refresh the list after successful review
        await _fetchPendingRequests();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isApproved
                ? "Request approved successfully"
                : "Request rejected successfully"),
            backgroundColor: isApproved ? Colors.green : Colors.orange,
          ),
        );
      } else {
        setState(() {
          _errorMessage = response['message'] ?? "Failed to review request";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark();

    return Scaffold(
      backgroundColor:
          isDark ? MyAppColors.primaryDarkColor : MyAppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Professor Requests',
          style: TextStyle(
            color: isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPendingRequests,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchPendingRequests,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : _requests.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No pending professor requests found',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _requests.length,
                      padding: const EdgeInsets.all(16.0),
                      itemBuilder: (context, index) {
                        final request = _requests[index];
                        return _buildRequestCard(request, isDark);
                      },
                    ),
    );
  }

  Widget _buildRequestCard(dynamic request, bool isDark) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? MyAppColors.secondaryDarkColor : MyAppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request['fullName'] ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? MyAppColors.whiteColor
                          : MyAppColors.blackColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'PENDING',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request['email'] ?? 'No email provided',
                    style: TextStyle(
                      color:
                          isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 16,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request['department'] ?? 'No department provided',
                    style: TextStyle(
                      color:
                          isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            if (request['additionalInfo'] != null &&
                request['additionalInfo'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Additional Information:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request['additionalInfo'],
                style: TextStyle(
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
            ],
            if (request['idImageUrl'] != null) ...[
              const SizedBox(height: 12),
              Text(
                'ID Verification:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? MyAppColors.whiteColor : MyAppColors.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: request['idImageUrl'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 120,
                    width: double.infinity,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 120,
                    width: double.infinity,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _reviewRequest(request['id'], false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _reviewRequest(request['id'], true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyAppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
