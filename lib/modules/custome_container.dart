import 'package:flutter/material.dart';

import '../style/my_app_colors.dart';
import '../style/my_theme_data.dart';

class CustomContainer extends StatelessWidget {
  final String label;
  final void Function()? onContainerClick;
  final IconData icon;

  const CustomContainer(
      {super.key,
      required this.label,
      required this.onContainerClick,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onContainerClick,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.02),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025),
        decoration: BoxDecoration(
            color: MyAppColors.babyBlueColor,
            borderRadius: BorderRadius.circular(17)),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: MyAppColors.primaryColor,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text(
                  label,
                  style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: MyAppColors.darkBlueColor,
            )
          ],
        ),
      ),
    );
  }
}
