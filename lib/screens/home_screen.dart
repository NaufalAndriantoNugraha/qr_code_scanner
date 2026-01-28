import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/widgets/scanner_button.dart';
import 'package:qr_code_scanner/widgets/scanner_frame.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MobileScannerController scannerController = MobileScannerController(
    torchEnabled: false,
  );

  bool isFlashlightOn = false;

  void toggleFlashlight() {
    scannerController.toggleTorch();
    setState(() {
      isFlashlightOn = !isFlashlightOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(
              controller: scannerController,
            ),
            Center(
              child: CustomPaint(
                size: Size(280, 280),
                painter: ScannerFrame(),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: scannerButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget scannerButtons() {
    return Column(
      spacing: 20,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: ScannerButton(
            width: 200,
            icon: Icons.image,
            label: 'Import from Gallery',
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            onTap: () {},
          ),
        ),
        Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScannerButton(
              width: 160,
              icon: isFlashlightOn ? Icons.flash_on : Icons.flash_off,
              label: isFlashlightOn ? 'Flashlight On' : 'Flashlight Off',
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              onTap: () => toggleFlashlight(),
            ),
            ScannerButton(
              width: 160,
              icon: Icons.qr_code,
              label: 'Saved QR Code',
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
