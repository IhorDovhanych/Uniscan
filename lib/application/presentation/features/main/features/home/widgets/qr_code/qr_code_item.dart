import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/cubit/qr_code_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeItem extends StatelessWidget {
  final String docID;
  final String name;
  final String url;
  final QrCodeService qrCodeService;
  final Function({String? docID}) openQrCodeBox;

  const QrCodeItem({
    Key? key,
    required this.docID,
    required this.name,
    required this.url,
    required this.qrCodeService,
    required this.openQrCodeBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => QrCodeCubit(getIt<QrCodeService>()),
        child: BlocBuilder<QrCodeCubit, QrCodeState>(
            builder: (final context, final state) => SingleChildScrollView(
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          margin: const EdgeInsets.only(top: 20.0),
                          decoration: ShapeDecoration(
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 15,
                                cornerSmoothing: 0.6,
                              ),
                            ),
                            color: const Color.fromARGB(255, 200, 212, 255),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    decoration: ShapeDecoration(
                                      shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                          cornerRadius: 15,
                                          cornerSmoothing: 0.6,
                                        ),
                                      ),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                    child: QrImageView(
                                      data: url,
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  )
                                ],
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: const TextStyle(fontSize: 30),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      alignment: Alignment.centerRight,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () => context
                                                .read<QrCodeCubit>()
                                                .deleteQrCode(docID),
                                            icon: SvgPicture.asset(
                                              'assets/icons/delete.svg',
                                              colorFilter: ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.color),
                                              width: 30,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                openQrCodeBox(docID: docID),
                                            icon: SvgPicture.asset(
                                              'assets/icons/edit.svg',
                                              colorFilter: ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.color),
                                              width: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () => launchUrl(Uri.parse(url)),
                                      child: Text(
                                        "URL: $url ",
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
  }
}
