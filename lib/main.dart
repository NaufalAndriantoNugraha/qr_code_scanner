import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/screens/camera_permission_disabled_screen.dart';
import 'package:qr_code_scanner/screens/home_screen.dart';
import 'package:qr_code_scanner/screens/qr_code_detail_screen.dart';
import 'package:qr_code_scanner/screens/saved_qr_code_screen.dart';
import 'package:qr_code_scanner/screens/scanner_result_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Scanner',
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        ScannerResultScreen.routeName: (context) => ScannerResultScreen(),
        SavedQrCodeScreen.routeName: (context) => SavedQrCodeScreen(),
        QrCodeDetailScreen.routeName: (context) => QrCodeDetailScreen(),
        CameraPermissionDisabledScreen.routeName: (context) =>
            CameraPermissionDisabledScreen(),
      },
    );
  }
}
