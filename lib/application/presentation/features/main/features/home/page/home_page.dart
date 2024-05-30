import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/camera_service.dart';
import 'package:uniscan/application/data/services/geo_position_service.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/presentation/features/main/features/home/cubit/home_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/custom_app_bar.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_dialog.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_list.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late QrCodeModel? _nearestQrCode;

  @override
  void initState() {
    super.initState();

    _initializePermissions();

    if (widget.barcode != '') {
      WidgetsBinding.instance!.addPostFrameCallback((final _) {
        openQrCodeBox();
      });
    }

    loadNearestQrCode();
  }

  Future<void> _initializePermissions() async {
    // Ask for geo position permissions
    await getIt<GeoPositionService>().getPermissions();
    // Ask for camera permissions
    await getIt<CameraService>().getPermissions();
  }

  Future<void> loadNearestQrCode() async {
    try {
      final Position position =
          await GeoPositionServiceImpl().determinePosition();
      final List<QrCodeModel> nearbyQrCodes = await qrCodeService
          .getNearbyQrCodes(position.latitude, position.longitude);
      if (nearbyQrCodes.isNotEmpty) {
        setState(() {
          _nearestQrCode = nearbyQrCodes.first;
        });
        _showNearestQrCodePopup(nearbyQrCodes.first);
      }
    } catch (e) {
      print('Error loading nearest QR code: $e');
    }
  }

  void _showNearestQrCodePopup(final QrCodeModel qrCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nearest QR Code'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: ${qrCode.name}'),
            // Making the URL clickable using RichText
            InkWell(
              onTap: () => launchUrl(Uri.parse(qrCode.url)),
              child: Text(
                'URL: ${qrCode.url} ',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            )
            // Add more QR code details if needed
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
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
      final QrCodeModel? qrCode = await qrCodeService.getQrCodeById(docID);
      if (qrCode != null) {
        nameTextController.text = qrCode.name;
        urlTextController.text = qrCode.url;
      }
    }
    await showDialog(
      context: context,
      builder: (final _) => QrCodeDialog(
        nameTextController: nameTextController,
        urlTextController: urlTextController,
        barcode: widget.barcode,
        docID: docID,
        qrCodeService: qrCodeService,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => BlocProvider<HomeCubit>(
        create: (final _) => getIt<HomeCubit>(),
        child: Scaffold(
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
            qrCodeService: qrCodeService,
            openQrCodeBox: openQrCodeBox,
          ),
        ),
      );
}
