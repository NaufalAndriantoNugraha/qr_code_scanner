import 'package:flutter/material.dart';
import 'package:qr_code_scanner/styles/my_custom_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScannerResultScreen extends StatefulWidget {
  static const String routeName = '/scanner_result_screen';

  const ScannerResultScreen({super.key});

  @override
  State<ScannerResultScreen> createState() => _ScannerResultScreenState();
}

class _ScannerResultScreenState extends State<ScannerResultScreen> {
  @override
  Widget build(BuildContext context) {
    String args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: MyCustomColors.gray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.navigate_before, size: 30),
        ),
        title: Text('QR Code Scanner'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [qrCodeTips(), qrCodeView(args), qrCodeForm()],
          ),
        ),
      ),
    );
  }

  Widget qrCodeTips() {
    return Container(
      width: 330,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: BoxBorder.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline),
          Flexible(child: Text('Save the QR code so you can access it later!')),
        ],
      ),
    );
  }

  Widget qrCodeView(String qrCode) {
    return Container(
      width: 330,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 15,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          QrImageView(
            data: qrCode,
            size: 290,
          ),
          Container(
            width: 280,
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.open_in_new, color: Colors.white),
                Text(
                  qrCode,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget qrCodeForm() {
    return Column(
      spacing: 20,
      children: [
        SizedBox(
          width: 330,
          child: TextField(
            maxLength: 25,
            cursorColor: Colors.blueAccent,
            decoration: InputDecoration(
              counterText: '',
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter QR Code name...',
              focusColor: Colors.blueAccent,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
            style: TextStyle(backgroundColor: Colors.white),
          ),
        ),
        Container(
          width: 330,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'SAVE QR CODE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
