import 'package:flutter/material.dart';
import 'package:uniscan/application/data/services/camera_service.dart';
import 'package:uniscan/application/data/services/geo_position_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/presentation/features/main/features/home/cubit/home_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/custom_app_bar.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_dialog.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({final Key? key, required this.barcode}) : super(key: key);

  final String? barcode;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    // Ask for geo position permissions
    await getIt<GeoPositionService>().getPermissions();
    // Ask for camera permissions
    await getIt<CameraService>().getPermissions();
  }

  @override
  Widget build(final BuildContext context) {
    getIt<HomeCubit>().loadNearestQrCode(context);
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          QrCodeDialog.show(context);
        },
        shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
        backgroundColor: const Color.fromARGB(255, 61, 94, 170),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: QrCodeList(),
    );
  }
}
