import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_item.dart';
import 'package:uniscan/application/presentation/widgets/buttons/logout/widget/logout.dart'; // Importing QrCodeItem

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
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
                  return Flex(
                    direction: Axis.vertical,
                    children: [LogoutButton(), SizedBox(height: 35.0)],
                  );
                }
              },
            ),
          );
        } else {
          return Center(
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(50),
                  child: Flex(direction: Axis.vertical, children: [
                    Container(
                        width: 200,
                        height: 200,
                        child: SvgPicture.asset(
                          'assets/svg/fake_qr.svg',
                          colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcIn),
                        )),
                    SizedBox(height: 20),
                    Container(
                      width: 200,
                      child: Text(
                        'No scanned QR codes yet',
                        style: TextStyle(fontSize: 20, color: Colors.black26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    LogoutButton()
                  ])));
        }
      },
    );
  }
}
