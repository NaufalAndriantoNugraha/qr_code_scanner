import 'package:flutter/material.dart';
import 'package:qr_code_scanner/models/qr_code_model.dart';

class QrCodeButton extends StatelessWidget {
  final QrCodeModel qrCode;

  final VoidCallback onTap;

  final double width;
  final String label;

  final Color foregroundColor;
  final Color backgroundColor;

  const QrCodeButton({
    super.key,
    required this.qrCode,
    required this.onTap,
    required this.width,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
