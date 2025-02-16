import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/notification_logo.png',
              width: MediaQuery.of(context).size.width * 0.8),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          Text(
            'No Notifications Found',
            style: MyThemeData.lightModeStyle.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
