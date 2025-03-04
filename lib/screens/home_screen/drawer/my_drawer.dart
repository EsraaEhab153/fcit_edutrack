import 'package:fci_edutrack/screens/assignment/assignment_screen.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:flutter/material.dart';

import 'drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyAppColors.whiteColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.2,
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
        child: Column(
          children: [
            // logo
            Icon(
              Icons.school_outlined,
              color: MyAppColors.primaryColor,
              size: MediaQuery.of(context).size.width * 0.26,
            ),
            const Divider(
              color: MyAppColors.blackColor,
              thickness: 1.25,
            ),
            // home tile
            MyDrawerTile(
                title: 'H O M E',
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                }),
            //Assignment
            MyDrawerTile(
                title: 'A S S I G N M E N T',
                icon: Icons.assignment,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AssignmentScreen.routeName);
                }),
            //quiz
            MyDrawerTile(
                title: 'Q U I Z',
                icon: Icons.lightbulb_outline,
                onTap: () {
                  Navigator.pop(context);
                }),
            // settings
            MyDrawerTile(
                title: 'S E T T I N G S',
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, Settings.routeName);
                }),
            const Spacer(),
            // logout
            MyDrawerTile(
                title: 'L O G O U T', icon: Icons.logout, onTap: () {}),
          ],
        ),
      ),
    );
  }
}
