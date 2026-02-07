import 'package:flutter/material.dart';
import 'package:qr_code_scanner/models/qr_code_model.dart';
import 'package:qr_code_scanner/widgets/qr_code_button.dart';
import 'package:qr_code_scanner/widgets/qr_code_snackbar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/database.dart';
import '../styles/my_custom_colors.dart';
import '../widgets/qr_code_dialog.dart';

class QrCodeDetailScreen extends StatefulWidget {
  static const String routeName = '/qr_code_detail_screen';

  const QrCodeDetailScreen({super.key});

  @override
  State<QrCodeDetailScreen> createState() => _QrCodeDetailScreenState();
}

class _QrCodeDetailScreenState extends State<QrCodeDetailScreen> {
  QrCodeDatabase qrCodeDatabase = QrCodeDatabase();
  TextEditingController qrCodeController = TextEditingController();

  Future<void> openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    QrCodeModel qrCode =
        ModalRoute.of(context)!.settings.arguments as QrCodeModel;

    qrCodeController.text = qrCode.name;

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                qrCodeView(qrCode.link),
                qrCodeForm(qrCode, qrCodeController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget qrCodeView(String qrCodeLink) {
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
          QrImageView(data: qrCodeLink, size: 290),
          GestureDetector(
            onTap: () => openUrl(qrCodeLink),
            child: Container(
              width: 280,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.open_in_new, color: Colors.black),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        qrCodeLink,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget qrCodeForm(
    QrCodeModel qrCode,
    TextEditingController qrCodeController,
  ) {
    return Column(
      spacing: 20,
      children: [
        SizedBox(
          width: 330,
          child: TextFormField(
            controller: qrCodeController,
            maxLength: 25,
            cursorColor: Colors.black,
            validator: (name) {
              if (name == null || name.isEmpty) {
                return 'Name cannot be empty';
              }
              if (name.length < 5) {
                return 'Minimum 3 characters required';
              }
              return null;
            },
            decoration: InputDecoration(
              counterText: '',
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter QR Code name...',
              iconColor: Colors.black,
              focusColor: Colors.black,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: TextStyle(backgroundColor: Colors.white),
          ),
        ),
        Column(
          spacing: 15,
          children: [
            QrCodeButton(
              qrCode: qrCode,
              onTap: () async {
                String name = qrCodeController.value.text;
                if (name.isNotEmpty) {
                  await QrCodeDatabase().updateQrCodeName(
                    qrCode.id!,
                    qrCodeController.text,
                  );
                  if (mounted) {
                    SnackBar snackbar = QrCodeSnackbar.build(
                      context,
                      message: 'Succesfully rename QR Code!',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                }
              },
              width: 330,
              label: 'RENAME QR CODE',
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
            QrCodeButton(
              qrCode: qrCode,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return qrCodeFormDialog(qrCode);
                  },
                );
              },
              width: 330,
              label: 'DELETE QR CODE',
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget qrCodeFormDialog(QrCodeModel qrCode) {
    return QrCodeDialog(
      title: 'Delete QR Code',
      content:
          "Are you sure want to delete '${qrCode.name}' QR code? This action can't be undo!",
      onTap: () async {
        if (qrCode.id != null) {
          await QrCodeDatabase().deleteQrCode(qrCode.id!);
          if (mounted) {
            Navigator.popUntil(
              context,
              ModalRoute.withName('/saved_qr_code_screen'),
            );
          }
        }
      },
    );
  }
}
