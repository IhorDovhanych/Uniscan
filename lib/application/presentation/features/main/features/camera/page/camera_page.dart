import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uniscan/application/presentation/features/main/cubit/main_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_dialog.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: MobileScanner(
          controller: MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates, returnImage: true),
          onDetect: (final capture) {
            if (capture.image != null) {
              context.read<MainCubit>().goToHomePage();
              QrCodeDialog.show(context, url: capture.barcodes.first.rawValue);
            }
          },
        ),
      );
}
