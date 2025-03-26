import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/my_app_colors.dart';
import '../themes/my_theme_data.dart';
import '../themes/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
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
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.09),
              decoration: BoxDecoration(
                // color: Provider.of<ThemeProvider>(context).isDark()?MyAppColors.primaryDarkColor:MyAppColors.whiteColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Provider.of<ThemeProvider>(context).isDark()
                      ? Colors.blue.shade800
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dark Mode'),
                  CupertinoSwitch(
                      activeColor: MyAppColors.primaryColor,
                      value: Provider.of<ThemeProvider>(context, listen: false)
                          .isDark(),
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
