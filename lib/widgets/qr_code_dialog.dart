import 'package:Uniscan/models/qr_code.dart';
import 'package:Uniscan/services/qr_code_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeDialog extends StatelessWidget {
  final TextEditingController nameTextController;
  final TextEditingController urlTextController;
  final String? barcode;
  final String? docID;
  final QrCodeService qrCodeService;

  const QrCodeDialog({
    Key? key,
    required this.nameTextController,
    required this.urlTextController,
    required this.barcode,
    required this.docID,
    required this.qrCodeService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        children: [
          Text(
            docID == null ? 'Add QR Code' : 'Edit QR Code',
            style: const TextStyle(fontSize: 20),
          ),
          TextField(
            controller: nameTextController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'QR code name',
            ),
          ),
          TextField(
            controller: urlTextController,
            decoration: const InputDecoration(
              labelText: 'URL',
              hintText: 'https://example.com',
            ),
          ),
        ],
      ),
      actions: [
        (this.barcode == '')
            ? ElevatedButton(
                onPressed: () {
                  try {
                    QrCode qrCode = QrCode(
                        name: nameTextController.text,
                        url: urlTextController.text);
                    if (docID == null) {
                      qrCodeService.addQrCode(qrCode);
                    } else {
                      qrCodeService.updateQrCode(docID!, qrCode);
                    }
                    Navigator.pop(context);
                  } catch (err) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Text(err.toString()),
                            ));
                    urlTextController.clear();
                  }
                },
                child: docID == null
                    ? Text(
                        'Add',
                        style: TextStyle(color: Colors.black),
                      )
                    : const Text(
                        'Update',
                        style: TextStyle(
                            color: Colors.black), // Customize color for update
                      ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        try {
                          QrCode qrCode = QrCode(
                              name: nameTextController.text,
                              url: urlTextController.text);
                          qrCodeService.addQrCode(qrCode);
                          Navigator.pop(context);
                        } catch (err) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Text(err.toString()),
                                  ));
                          urlTextController.clear();
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.black),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        try {
                          QrCode qrCode = QrCode(
                              name: nameTextController.text,
                              url: urlTextController.text);
                          qrCodeService.addQrCode(qrCode);
                          launchUrl(Uri.parse(urlTextController.text));
                          Navigator.pop(context);
                        } catch (err) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Text(err.toString()),
                                  ));
                          urlTextController.clear();
                        }
                      },
                      child: const Text(
                        'Add and visit',
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
      ],
    );
  }
}
