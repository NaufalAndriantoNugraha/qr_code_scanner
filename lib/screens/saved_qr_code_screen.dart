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
  late Future<List<QrCodeModel>> qrFutureData;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    qrFutureData = QrCodeDatabase().getQrCodes();
  }

  void onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        qrFutureData = QrCodeDatabase().getQrCodes();
      } else {
        qrFutureData = QrCodeDatabase().searchQrCode(query);
      }
    });
  }

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          child: Column(
            spacing: 5,
            children: [
              textField(),
              savedQrCode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField() {
    return Container(
      margin: EdgeInsets.only(left: 4, right: 4, bottom: 4),
      child: TextField(
        controller: searchController,
        cursorColor: Colors.black,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: "Search QR code's name...",
          contentPadding: EdgeInsets.symmetric(
            vertical: 1,
            horizontal: 5,
          ),
          filled: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? cleanSearchQueryButton()
              : null,
        ),
      ),
    );
  }

  Widget cleanSearchQueryButton() {
    return IconButton(
      onPressed: () {
        searchController.text = '';
        onSearchChanged('');
      },
      icon: Icon(Icons.close_outlined),
    );
  }

  Widget savedQrCode() {
    return FutureBuilder(
      future: qrFutureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        }
        List<QrCodeModel> qrCodes = snapshot.data!;
        return Expanded(
          child: ListView.builder(
            itemCount: qrCodes.length,
            itemBuilder: (context, index) {
              QrCodeModel currentIndex = qrCodes[index];
              return listTile(currentIndex);
            },
          ),
        );
      },
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
            iconButton(qrCode),
          ],
        ),
      ),
    );
  }

  Widget iconButton(QrCodeModel qrCode) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return qrCodeDialog(qrCode, context);
          },
        );
      },
      icon: Icon(Icons.delete),
    );
  }

  Widget qrCodeDialog(QrCodeModel qrCode, BuildContext context) {
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
