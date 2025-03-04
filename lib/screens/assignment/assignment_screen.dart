import 'package:fci_edutrack/screens/assignment/assignment_card.dart';
import 'package:fci_edutrack/screens/assignment/assignment_model.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

class AssignmentScreen extends StatelessWidget {
  static const String routeName = 'assignment_screen';

  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyAppColors.primaryColor,
        title: Text(
          'ASSIGNMENT',
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
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: MyAppColors.whiteColor),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    return AssignmentCard(index: index);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
