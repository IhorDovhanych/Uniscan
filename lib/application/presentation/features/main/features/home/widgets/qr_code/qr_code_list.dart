import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/presentation/features/main/features/home/cubit/home_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_item.dart';
import 'package:uniscan/application/presentation/widgets/buttons/logout/widget/logout.dart';

class QrCodeList extends StatelessWidget {
  const QrCodeList({
    final Key? key,
    required this.qrCodeService,
    required this.openQrCodeBox,
  }) : super(key: key);

  final QrCodeService qrCodeService;
  final void Function({String? docID}) openQrCodeBox;

  @override
  Widget build(final BuildContext context) =>
      BlocListener<HomeCubit, List<QrCodeEntity>?>(
        listenWhen: (final previous, final current) =>
            (previous == null && current != null) ||
            (previous != null && current == null) ||
            (previous?.length != current?.length),
        listener: (final context, final state) {
          print('hi');
        },
        child: BlocBuilder<HomeCubit, List<QrCodeEntity>?>(
          builder: (final context, final qrCodesList) {
            if (qrCodesList != null && qrCodesList.isNotEmpty) {
              return Scrollbar(
                child: ListView.builder(
                  itemCount: qrCodesList.length + 1, // Add 1 for SizedBox
                  itemBuilder: (final context, final index) {
                    if (index < qrCodesList.length) {
                      final QrCodeEntity qrCode = qrCodesList[index];
                      final String docID = qrCode.id;
                      final String name = qrCode.name;
                      final String url = qrCode.url;
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
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        child: SvgPicture.asset(
                          'assets/svg/fake_qr.svg',
                          colorFilter: ColorFilter.mode(
                            Colors.black26,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 200,
                        child: Text(
                          'No scanned QR codes yet',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      LogoutButton(),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      );
}
