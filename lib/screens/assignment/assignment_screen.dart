import 'package:fci_edutrack/screens/assignment/assignment_card.dart';
import 'package:fci_edutrack/screens/assignment/assignment_model.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/my_theme_data.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssignmentScreen extends StatelessWidget {
  static const String routeName = 'assignment_screen';

  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assignment',
          style: MyThemeData.lightModeStyle.textTheme.titleMedium!
              .copyWith(color: MyAppColors.whiteColor),
        ),
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(MediaQuery.of(context).size.width * 0.1),
            bottomRight:
                Radius.circular(MediaQuery.of(context).size.width * 0.1),
          ),
        ),
        backgroundColor: MyAppColors.primaryColor,
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
            color: Provider.of<ThemeProvider>(context).isDark()
                ? MyAppColors.primaryDarkColor
                : MyAppColors.whiteColor),
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
