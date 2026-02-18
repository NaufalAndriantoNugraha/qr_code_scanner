import 'package:flutter/material.dart';

class QrCodeSnackbar {
  static SnackBar build(
    BuildContext context, {
    required String message,
  }) {
    return SnackBar(
      elevation: 0,
      content: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info, color: Colors.black),
          Text(message, style: const TextStyle(color: Colors.black)),
        ],
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        right: 15,
        left: 15,
      ),
      dismissDirection: DismissDirection.none,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
    );
  }
}
