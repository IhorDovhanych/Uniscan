import 'package:Uniscan/widgets/custom_app_bar.dart';
import 'package:Uniscan/widgets/qr_code_dialog.dart';
import 'package:Uniscan/widgets/qr_code_list.dart';
import 'package:flutter/material.dart';
import 'package:Uniscan/services/qr_code_service.dart';

class HomePage extends StatefulWidget {
  final String? barcode;

  const HomePage({Key? key, required this.barcode}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QrCodeService qrCodeService = QrCodeService();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController urlTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.barcode != '') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        openQrCodeBox();
      });
    }
  }

  void openQrCodeBox({String? docID}) async {
    print(docID);
    if (docID == null) {
      nameTextController.clear();
      urlTextController.clear();
      if (widget.barcode != '') {
        urlTextController.text = widget.barcode!;
      }
    } else {
      dynamic qrCode = await qrCodeService.getQrCodeById(docID);
      nameTextController.text = qrCode['name'];
      urlTextController.text = qrCode['url'];
    }
    showDialog(
      context: context,
      builder: (context) => QrCodeDialog(
        nameTextController: nameTextController,
        urlTextController: urlTextController,
        barcode: widget.barcode,
        docID: docID,
        qrCodeService: qrCodeService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: openQrCodeBox,
        shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
        backgroundColor: const Color.fromARGB(255, 61, 94, 170),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: QrCodeList(
        qrCodeStream: qrCodeService.getQrCodesStream(),
        qrCodeService: qrCodeService,
        openQrCodeBox: openQrCodeBox, // Pass the function without named parameters
      ),
    );
  }
}

