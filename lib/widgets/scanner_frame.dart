import 'package:flutter/material.dart';

class ScannerFrame extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;

    const len = 30.0;
    const radius = 12.0;

    canvas.drawPath(
      Path()
        ..moveTo(0, len)
        ..lineTo(0, radius)
        ..quadraticBezierTo(0, 0, radius, 0)
        ..lineTo(len, 0),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(width - len, 0)
        ..lineTo(width - radius, 0)
        ..quadraticBezierTo(width, 0, width, radius)
        ..lineTo(width, len),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(0, height - len)
        ..lineTo(0, height - radius)
        ..quadraticBezierTo(0, height, radius, height)
        ..lineTo(len, height),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(width - len, height)
        ..lineTo(width - radius, height)
        ..quadraticBezierTo(width, height, width, height - radius)
        ..lineTo(width, height - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
