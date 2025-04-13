import 'package:fci_edutrack/auth/login_screen.dart';
import 'package:fci_edutrack/modules/custome_container.dart';
import 'package:fci_edutrack/screens/home_screen/notifications_screen.dart';
import 'package:fci_edutrack/screens/settings_screen.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/my_theme_data.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentProfileScreen extends StatelessWidget {
  static const String routeName = 'student_profile';
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark();
    return Container(
      color: isDark ? MyAppColors.primaryDarkColor : MyAppColors.whiteColor,
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
              style: isDark
                  ? MyThemeData.darkModeStyle.textTheme.bodySmall
                  : MyThemeData.lightModeStyle.textTheme.bodySmall,
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
              onContainerClick: () {
                Navigator.pushNamed(context, NotificationsScreen.routeName);
              },
            ),
            CustomContainer(
              label: 'Help and Support',
              icon: Icons.help,
              onContainerClick: () {},
            ),
            CustomContainer(
              label: 'Settings',
              icon: Icons.settings,
              onContainerClick: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
            ),
            CustomContainer(
              label: 'Log Out',
              icon: Icons.logout,
              onContainerClick: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
