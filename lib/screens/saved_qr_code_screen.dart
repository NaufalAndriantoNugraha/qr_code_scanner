import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/cubits/qr_code_cubit.dart';
import 'package:qr_code_scanner/models/qr_code_model.dart';
import 'package:qr_code_scanner/screens/qr_code_detail_screen.dart';
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
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<QrCodeCubit>().getQrCodes();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<QrCodeCubit>().getQrCodes();
      return;
    }
    context.read<QrCodeCubit>().searchQrCodes(query);
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
          BlocBuilder<QrCodeCubit, QrCodeState>(
            builder: (context, state) {
              if (state is QrCodeStateLoaded) {
                final counter = state.qrCodes.length;
                return Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Text(
                    counter.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.only(right: 20),
                child: Text(
                  0.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
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
    return BlocBuilder<QrCodeCubit, QrCodeState>(
      builder: (context, state) {
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
      },
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
    return BlocBuilder<QrCodeCubit, QrCodeState>(
      builder: (context, state) {
        if (state is QrCodeStateLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else if (state is QrCodeStateError) {
          return Center(
            child: Text(state.toString()),
          );
        } else if (state is QrCodeStateLoaded) {
          final qrCodes = state.qrCodes;
          if (qrCodes.isEmpty) {
            if (searchController.text.isNotEmpty) {
              return qrCodeNotFound();
            }
            return emptyList();
          }

          return Expanded(
            child: ListView.builder(
              itemCount: qrCodes.length,
              itemBuilder: (context, index) {
                QrCodeModel currentIndex = qrCodes[index];
                return listTile(currentIndex);
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget qrCodeNotFound() {
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
            'Search Not Found',
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
              "No QR codes match your search. Make sure the name is correct and that is has been saved.",
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
      onTap: () {
        if (mounted && qrCode.id != null) {
          context.read<QrCodeCubit>().deleteQrCodes(qrCode.id!);
          Navigator.pop(context);
          context.read<QrCodeCubit>().getQrCodes();
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
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          Text(qrCode.link),
        ],
      ),
    );
  }
}
