import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Uniscan/services/qr_code_service.dart';
import 'package:Uniscan/widgets/qr_code_item.dart'; // Importing QrCodeItem

class QrCodeList extends StatelessWidget {
  final Stream<QuerySnapshot> qrCodeStream;
  final QrCodeService qrCodeService;
  final void Function({String? docID}) openQrCodeBox; // Update this line

  const QrCodeList({
    Key? key,
    required this.qrCodeStream,
    required this.qrCodeService,
    required this.openQrCodeBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: qrCodeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> qrCodesList = snapshot.data!.docs;
          return Scrollbar(
            child: ListView.builder(
              itemCount: qrCodesList.length + 1, // Add 1 for SizedBox
              itemBuilder: (context, index) {
                if (index < qrCodesList.length) {
                  DocumentSnapshot document = qrCodesList[index];
                  String docID = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String name = data['name'];
                  String url = data['url'];

                  return QrCodeItem(
                    docID: docID,
                    name: name,
                    url: url,
                    qrCodeService: qrCodeService,
                    openQrCodeBox: openQrCodeBox,
                  );
                } else {
                  return const SizedBox(height: 35.0);
                }
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
