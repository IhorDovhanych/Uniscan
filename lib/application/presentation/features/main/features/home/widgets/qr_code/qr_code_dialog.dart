import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/cubit/qr_code_cubit.dart';
import 'package:uniscan/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeDialog extends StatelessWidget {
  const QrCodeDialog({
    final Key? key,
    required this.nameTextController,
    required this.urlTextController,
    required this.barcode,
    required this.docID,
    required this.qrCodeService,
  }) : super(key: key);

  final TextEditingController nameTextController;
  final TextEditingController urlTextController;
  final String? barcode;
  final String? docID;
  final QrCodeService qrCodeService;

  @override
  Widget build(final BuildContext context) => BlocProvider(
      create: (final context) => QrCodeCubit(getIt<QrCodeService>()),
      child: BlocBuilder<QrCodeCubit, QrCodeState>(
          builder: (final context, final state) => AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  children: [
                    Text(
                      docID == null ? S.of(context).add_qr_code : S.of(context).edit_qr_code,
                      style: const TextStyle(fontSize: 20),
                    ),
                    TextField(
                      controller: nameTextController,
                      decoration: InputDecoration(
                        labelText: S.of(context).name,
                        hintText: S.of(context).qr_code_name,
                      ),
                    ),
                    TextField(
                      controller: urlTextController,
                      decoration: InputDecoration(
                        labelText: S.of(context).url,
                        hintText: S.of(context).example_url,
                      ),
                    ),
                  ],
                ),
                actions: [
                  (this.barcode == '')
                      ? ElevatedButton(
                          onPressed: () {
                            try {
                              final QrCodeModel qrCode = QrCodeModel(
                                  name: nameTextController.text,
                                  url: urlTextController.text);
                              if (docID == null) {
                                context.read<QrCodeCubit>().addQrCode(qrCode);
                              } else {
                                context
                                    .read<QrCodeCubit>()
                                    .updateQrCode(docID!, qrCode);
                              }
                              Navigator.pop(context);
                            } catch (err) {
                              showDialog(
                                  context: context,
                                  builder: (final context) => AlertDialog(
                                        content: Text(err.toString()),
                                      ));
                              urlTextController.clear();
                            }
                          },
                          child: docID == null
                              ? Text(
                                  S.of(context).add,
                                  style: TextStyle(color: Colors.black),
                                )
                              : Text(
                                  S.of(context).update,
                                  style: TextStyle(
                                      color: Colors
                                          .black)
                                ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  try {
                                    final QrCodeModel qrCode = QrCodeModel(
                                        name: nameTextController.text,
                                        url: urlTextController.text);
                                    context
                                        .read<QrCodeCubit>()
                                        .addQrCode(qrCode);
                                    Navigator.pop(context);
                                  } catch (err) {
                                    showDialog(
                                        context: context,
                                        builder: (final context) => AlertDialog(
                                              content: Text(err.toString()),
                                            ));
                                    urlTextController.clear();
                                  }
                                },
                                child: Text(
                                  S.of(context).add,
                                  style: TextStyle(color: Colors.black),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  try {
                                    final QrCodeModel qrCode = QrCodeModel(
                                        name: nameTextController.text,
                                        url: urlTextController.text);
                                    qrCodeService.addQrCode(qrCode);
                                    launchUrl(
                                        Uri.parse(urlTextController.text));
                                    Navigator.pop(context);
                                  } catch (err) {
                                    showDialog(
                                        context: context,
                                        builder: (final context) => AlertDialog(
                                              content: Text(err.toString()),
                                            ));
                                    urlTextController.clear();
                                  }
                                },
                                child: Text(
                                  S.of(context).add_and_visit,
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        ),
                ],
              )));
}
