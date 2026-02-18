import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/screens/home_screen.dart';
import 'package:qr_code_scanner/styles/my_custom_colors.dart';

class CameraPermissionDisabledScreen extends StatefulWidget {
  static const String routeName = '/camera_permission_disabled_screen';

  const CameraPermissionDisabledScreen({super.key});

  @override
  State<CameraPermissionDisabledScreen> createState() =>
      _CameraPermissionDisabledScreenState();
}

class _CameraPermissionDisabledScreenState
    extends State<CameraPermissionDisabledScreen> {
  Future<void> permissionGranted() async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await openAppSettings();
      for (int i = 1; i <= 60; i++) {
        await Future.delayed(const Duration(seconds: 1));
        var newStatus = await Permission.camera.status;
        if (newStatus.isGranted) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          }
        }
      }
    } else if (status.isGranted) {
      if (status.isGranted) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      }
    }
  }

  Future<void> permissionNotGranted() async {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyCustomColors.gray,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 40,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                message(),
                buttons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttons() {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        button('Exit application', permissionNotGranted),
        button('Grant permission', permissionGranted),
      ],
    );
  }

  Widget message() {
    return const Column(
      spacing: 10,
      children: [
        Text(
          'Camera Access Required',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          "To scan QR codes, we need permission to use your camera. If we are not allowed to get camera permission, QR Code Scanner will be unable to function, and you won't be able to capture or save any data to your collection.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget button(String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
