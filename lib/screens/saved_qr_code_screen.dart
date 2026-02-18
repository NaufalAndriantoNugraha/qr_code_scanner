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
  final ValueNotifier<int> qrCounter = ValueNotifier<int>(0);

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
          icon: const Icon(Icons.navigate_before, size: 30),
        ),
        title: const Text('QR Code Scanner'),
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: qrCounter,
            builder: (context, value, child) {
              return Container(
                margin: const EdgeInsets.only(right: 20),
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
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
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
      child: TextField(
        controller: searchController,
        cursorColor: Colors.black,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: "Search QR code's name...",
          contentPadding: const EdgeInsets.symmetric(
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
          prefixIcon: const Icon(Icons.search),
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
      icon: const Icon(Icons.close_outlined),
    );
  }

  Widget savedQrCode() {
    return FutureBuilder(
      future: qrFutureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return emptyList();
        }
        List<QrCodeModel> qrCodes = snapshot.data!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          qrCounter.value = qrCodes.length;
        });
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

  Widget emptyList() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_rounded,
            size: 150,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 10),
          const Text(
            'Your QR Codes Gallery is Empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "It seems you haven't saved any QR codes. Start scanning and saving them, and they will appear here automatically.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listTile(QrCodeModel qrCode) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          QrCodeDetailScreen.routeName,
          arguments: qrCode,
        );
        setState(() {
          qrFutureData = QrCodeDatabase().getQrCodes();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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
      icon: const Icon(Icons.delete),
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
            setState(() {
              qrFutureData = QrCodeDatabase().getQrCodes();
            });
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(qrCode.link),
        ],
      ),
    );
  }
}
