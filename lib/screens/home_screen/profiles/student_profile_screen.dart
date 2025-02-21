import 'package:fci_edutrack/modules/custome_container.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: MediaQuery.of(context).size.width * 0.16,
              child: Image.asset(
                'assets/images/student_profile_photo.png',
                width: MediaQuery.of(context).size.width * 0.32,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.012,
            ),
            Text(
              'Mariam Mohamed',
              style: MyThemeData.lightModeStyle.textTheme.bodySmall,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            CustomContainer(
              label: 'My Attendance',
              icon: Icons.list_alt_outlined,
              onContainerClick: () {},
            ),
            CustomContainer(
              label: 'Notifications',
              icon: Icons.notifications,
              onContainerClick: () {},
            ),
            CustomContainer(
              label: 'Help and Support',
              icon: Icons.help,
              onContainerClick: () {},
            ),
            CustomContainer(
              label: 'Settings',
              icon: Icons.settings,
              onContainerClick: () {},
            ),
            CustomContainer(
              label: 'Log Out',
              icon: Icons.logout,
              onContainerClick: () {},
            ),
          ],
        ),
      ),
    );
  }
}
