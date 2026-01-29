import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/screens/saved_qr_code_screen.dart';
import 'package:qr_code_scanner/screens/scanner_result_screen.dart';
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
  bool isScanning = false;

  void toggleFlashlight() {
    scannerController.toggleTorch();
    setState(() {
      isFlashlightOn = !isFlashlightOn;
    });
  }

  void onDetect(BarcodeCapture capturedBarcode) {
    if (isScanning) {
      return;
    }

    if (isFlashlightOn) {
      toggleFlashlight();
    }

    List<Barcode> barcodes = capturedBarcode.barcodes;
    if (barcodes.isNotEmpty) {
      isScanning = true;

      String? code = barcodes.first.rawValue;
      if (code != null) {
        Navigator.pushNamed(
          context,
          ScannerResultScreen.routeName,
          arguments: code,
        ).then((value) {
          isScanning = false;
        });
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      scanImageFromGallery(image.path);
    }
  }

  void scanImageFromGallery(String path) async {
    if (isFlashlightOn) {
      toggleFlashlight();
    }

    BarcodeCapture? barcode = await scannerController.analyzeImage(path);
    if (barcode != null && barcode.barcodes.isNotEmpty) {
      String code = barcode.barcodes.first.rawValue!;
      if (mounted) {
        Navigator.pushNamed(
          context,
          ScannerResultScreen.routeName,
          arguments: code,
        ).then((value) {
          isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(
              controller: scannerController,
              onDetect: onDetect,
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
            onTap: () => pickImageFromGallery(),
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
              onTap: () =>
                  Navigator.pushNamed(context, SavedQrCodeScreen.routeName),
            ),
          ],
        ),
      ],
    );
  }
}
