import 'package:fci_edutrack/modules/custom_button_widget.dart';
import 'package:fci_edutrack/screens/home_screen/QR_code/qr_code_functions.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Attendance registration',
              style: MyThemeData.lightModeStyle.textTheme.titleMedium,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Icon(
              Icons.qr_code_2,
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
    );
  }

  void showSuccessDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Scanned Successfully',
              style: MyThemeData.lightModeStyle.textTheme.titleSmall,
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
                  style: MyThemeData.lightModeStyle.textTheme.bodyMedium!
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
