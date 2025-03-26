import 'package:fci_edutrack/modules/custom_button_widget.dart';
import 'package:fci_edutrack/screens/home_screen/QR_code/qr_code_functions.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/my_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../themes/theme_provider.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  bool isScannedSuccess = false;

  Future<void> scanQrCodeCheck() async {
    String scanResult = await QrCodeFunctions.scanQR();
    if (scanResult.isNotEmpty) {
      setState(() {
        showSuccessDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Attendance registration',
                style: MyThemeData.lightModeStyle.textTheme.titleMedium!
                    .copyWith(color: MyAppColors.primaryColor),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Icon(
                Icons.qr_code_2,
                color: Provider.of<ThemeProvider>(context).isDark()
                    ? MyAppColors.whiteColor
                    : MyAppColors.blackColor,
                size: MediaQuery.of(context).size.height * 0.3,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              CustomButtonWidget(
                  label: 'Scan the QR Code',
                  buttonIcon: Icons.qr_code_2,
                  buttonFunction: () {
                    scanQrCodeCheck();
                  })
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Provider.of<ThemeProvider>(context).isDark()
                ? MyAppColors.primaryDarkColor
                : MyAppColors.whiteColor,
            title: Text(
              'Scanned Successfully',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            icon: Icon(
              Icons.check_circle,
              color: const Color(0xff35ef03),
              size: MediaQuery.of(context).size.height * 0.1,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: MyAppColors.primaryColor),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
  }
}
