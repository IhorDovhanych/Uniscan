import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeItem extends StatelessWidget {
  const QrCodeItem({
    final Key? key,
    required this.qrCode,
    required this.openQrCode,
    required this.deleteQrCode,
  }) : super(key: key);

  final QrCodeEntity qrCode;
  final VoidCallback openQrCode;
  final VoidCallback deleteQrCode;

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        decoration: ShapeDecoration(
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 15,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: QrImageView(
                          data: qrCode.url,
                          size: 200.0,
                        ),
                      )
                    ],
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          qrCode.name,
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: deleteQrCode,
                                icon: SvgPicture.asset(
                                  'assets/icons/delete.svg',
                                  colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.color),
                                  width: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: openQrCode,
                                icon: SvgPicture.asset(
                                  'assets/icons/edit.svg',
                                  colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.color),
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
                          onTap: () => launchUrl(Uri.parse(qrCode.url)),
                          child: Text(
                            '${S.of(context).url}: ${qrCode.url}',
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
      );
}
