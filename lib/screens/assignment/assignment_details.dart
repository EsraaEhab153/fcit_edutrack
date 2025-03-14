import 'package:fci_edutrack/screens/assignment/assignment_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../style/my_app_colors.dart';
import '../../style/my_theme_data.dart';

class AssignmentDetails extends StatefulWidget {
  static const String routeName = 'assignment_details';

  const AssignmentDetails({super.key});

  @override
  State<AssignmentDetails> createState() => _AssignmentDetailsState();
}

class _AssignmentDetailsState extends State<AssignmentDetails> {
  bool isFilePicked = false;
  PlatformFile? selectedFile; // Store the selected file

  @override
  Widget build(BuildContext context) {
    AssignmentModel assignment =
        ModalRoute.of(context)!.settings.arguments as AssignmentModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyAppColors.primaryColor,
        title: Text(
          assignment.subjectName,
          style: MyThemeData.lightModeStyle.textTheme.titleMedium!.copyWith(
            color: MyAppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject name
            Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.019),
              decoration: BoxDecoration(
                  color: MyAppColors.lightBlueColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                assignment.subjectName,
                style: MyThemeData.lightModeStyle.textTheme.titleSmall!
                    .copyWith(
                        color: MyAppColors.whiteColor,
                        fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // Topic name
            Text(
              assignment.topicName,
              style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            // Assign date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('assign date'),
                Text(
                  assignment.assignDate,
                  style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // Last date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('last date'),
                Text(
                  assignment.lastDate,
                  style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('status'),
                Text(
                  assignment.status,
                  style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            // Show the container only when a file is picked
            if (isFilePicked && selectedFile != null)
              GestureDetector(
                onTap: () {
                  openFile(
                      selectedFile!); // Open the file when the container is clicked
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MyAppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200, // Adjust width as needed
                        child: Text(
                          selectedFile!.name, // Show file name
                          overflow: TextOverflow.ellipsis,
                          // Adds "..." when text is too long
                          maxLines: 1,
                          style: MyThemeData
                              .lightModeStyle.textTheme.bodyMedium!
                              .copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.insert_drive_file,
                              color: Colors.white),
                          const SizedBox(width: 8),
                          // Delete Icon
                          IconButton(
                            onPressed: () {
                              showDeleteConfirmationDialog();
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // File Picker Button
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result == null) return;

                setState(() {
                  isFilePicked = true;
                  selectedFile = result.files.first; // Store the picked file
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.primaryColor,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.017),
                minimumSize: Size(
                    double.infinity, MediaQuery.of(context).size.height * 0.01),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('select File'),
            ),
          ],
        ),
      ),
    );
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  // Show delete confirmation dialog
  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete File"),
        content: const Text("Are you sure you want to delete this file?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isFilePicked = false;
                selectedFile = null;
              });
              Navigator.pop(context); // Close dialog
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
