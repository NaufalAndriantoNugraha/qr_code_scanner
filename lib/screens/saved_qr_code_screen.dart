import 'package:flutter/material.dart';
import 'package:qr_code_scanner/models/qr_code_model.dart';
import 'package:qr_code_scanner/screens/qr_code_detail_screen.dart';
import 'package:qr_code_scanner/services/database.dart';
import 'package:qr_code_scanner/styles/my_custom_colors.dart';
import 'package:qr_code_scanner/widgets/qr_code_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SavedQrCodeScreen extends StatefulWidget {
  static const String routeName = '/saved_qr_code_screen';

  const SavedQrCodeScreen({super.key});

  @override
  State<SavedQrCodeScreen> createState() => _SavedQrCodeScreenState();
}

class _SavedQrCodeScreenState extends State<SavedQrCodeScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<QrCodeModel>>(
        future: QrCodeDatabase().getQrCodes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container();
          }

          List<QrCodeModel> qrCodes = snapshot.data!;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: ListView.builder(
                itemCount: qrCodes.length,
                itemBuilder: (context, index) {
                  QrCodeModel currentIndex = qrCodes[index];
                  return listTile(currentIndex);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listTile(QrCodeModel qrCode) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        QrCodeDetailScreen.routeName,
        arguments: qrCode,
      ).then((_) => setState(() {})),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          spacing: 10,
          children: [
            QrImageView(data: qrCode.link, size: 80),
            listTileContent(qrCode),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return QrCodeDialog(
                      title: 'Delete QR Code',
                      content:
                          "Are you sure want to delete '${qrCode.name}' QR code? This action can't be undo!",
                      onTap: () async {
                        if (mounted) {
                          if (qrCode.id != null) {
                            Navigator.pop(context);
                            await QrCodeDatabase().deleteQrCode(qrCode.id!);
                            setState(() {});
                          }
                        }
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  Widget listTileContent(QrCodeModel qrCode) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            qrCode.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(qrCode.link),
        ],
      ),
    );
  }
}
