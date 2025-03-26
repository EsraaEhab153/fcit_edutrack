import 'package:fci_edutrack/screens/assignment/assignment_details.dart';
import 'package:fci_edutrack/screens/assignment/assignment_model.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';

class AssignmentCard extends StatelessWidget {
  final int index;

  const AssignmentCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.024),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(
          border: Border.all(
              color: Provider.of<ThemeProvider>(context).isDark()
                  ? Colors.blue.shade800
                  : Colors.grey.shade300,
              width: 2),
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
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: MyAppColors.whiteColor, fontWeight: FontWeight.bold),
            ),
          ),
          //topic name
          Text(
            assignments[index].topicName,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Provider.of<ThemeProvider>(context).isDark()
                    ? MyAppColors.lightBlueColor
                    : MyAppColors.blackColor),
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
                style: Theme.of(context).textTheme.bodyMedium,
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
                style: Theme.of(context).textTheme.bodyMedium,
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
                style: Theme.of(context).textTheme.bodyMedium,
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
