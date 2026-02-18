import 'package:flutter/material.dart';

class ScannerButton extends StatelessWidget {
  final double width;

  final IconData icon;
  final String label;

  final Color foregroundColor;
  final Color backgroundColor;

  final VoidCallback onTap;

  const ScannerButton({
    super.key,
    required this.width,
    required this.icon,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(icon, color: foregroundColor),
            Text(
              label,
              style: TextStyle(color: foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
