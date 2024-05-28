import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/camera_service.dart';
import 'package:uniscan/application/data/services/geo_location_service.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/di/injections.dart';
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
  final QrCodeService qrCodeService = getIt<QrCodeService>();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController urlTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initializePermissions();

    if (widget.barcode != '') {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        openQrCodeBox();
      });
    }
  }

  Future<void> _initializePermissions() async {
    // Ask for geo location permissions
    await getIt<GeoLocationService>().getPermissions();
    // Ask for camera permissions
    await getIt<CameraService>().getPermissions();
  }

  Future<void> openQrCodeBox({final String? docID}) async {
    print(docID);
    if (docID == null) {
      nameTextController.clear();
      urlTextController.clear();
      if (widget.barcode != '') {
        urlTextController.text = widget.barcode!;
      }
    } else {
      QrCodeModel? qrCode = await qrCodeService.getQrCodeById(docID);
      if (qrCode != null) {
        nameTextController.text = qrCode.name;
        urlTextController.text = qrCode.url;
      }
    }
    await showDialog(
      context: context,
      builder: (final context) => QrCodeDialog(
        nameTextController: nameTextController,
        urlTextController: urlTextController,
        barcode: widget.barcode,
        docID: docID,
        qrCodeService: qrCodeService,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: CustomAppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: openQrCodeBox,
          shape:
              const CircleBorder(side: BorderSide(color: Colors.transparent)),
          backgroundColor: const Color.fromARGB(255, 61, 94, 170),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: QrCodeList(
          qrCodeStream: qrCodeService.getQrCodesStream(),
          qrCodeService: qrCodeService,
          openQrCodeBox:
              openQrCodeBox, // Pass the function without named parameters
        ),
      );
}
