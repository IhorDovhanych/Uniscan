import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uniscan/application/presentation/features/main/features/home/page/home_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(final BuildContext context) => Scaffold(
      body: MobileScanner(
          controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates, returnImage: true),
          onDetect: (final capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            if (image != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) =>
                      HomePage(barcode: barcodes.first.rawValue),
                ),
              );
            }
          }),
    );
}
