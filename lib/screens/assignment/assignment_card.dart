import 'package:fci_edutrack/screens/assignment/assignment_details.dart';
import 'package:fci_edutrack/screens/assignment/assignment_model.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

class AssignmentCard extends StatelessWidget {
  final int index;

  const AssignmentCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(15)),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // subject name
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.019),
            decoration: BoxDecoration(
                color: MyAppColors.lightBlueColor,
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              assignments[index].subjectName,
              style: MyThemeData.lightModeStyle.textTheme.titleSmall!.copyWith(
                  color: MyAppColors.whiteColor, fontWeight: FontWeight.bold),
            ),
          ),
          //topic name
          Text(
            assignments[index].topicName,
            style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
          ),
          // assign date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'assign date',
              ),
              Text(
                assignments[index].assignDate,
                style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
              ),
            ],
          ),
          // last date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('last date'),
              Text(
                assignments[index].lastDate,
                style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
              ),
            ],
          ),
          // status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('status'),
              Text(
                assignments[index].status,
                style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
              ),
            ],
          ),
          if (assignments[index].status == 'pending')
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AssignmentDetails.routeName,
                      arguments: assignments[index]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyAppColors.primaryColor,
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.017),
                  minimumSize: Size(double.infinity,
                      MediaQuery.of(context).size.height * 0.01),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('To Be Submitted')),
        ],
      ),
    );
  }
}
