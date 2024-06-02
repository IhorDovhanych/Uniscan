import 'package:flutter/material.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class NearestQrCodeDialog extends StatelessWidget {
  const NearestQrCodeDialog({
    final Key? key,
    required this.qrCode,
  }) : super(key: key);

  final QrCodeEntity qrCode;

  static void show(final BuildContext context, {required final QrCodeEntity qrCode}) {
    showDialog(
      context: context,
      builder: (final context) => NearestQrCodeDialog(qrCode: qrCode),
    );
  }

  @override
  Widget build(final BuildContext context) => AlertDialog(
      title: Text(S.of(context).nearest_qr_code),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${S.of(context).name}: ${qrCode.name}'),
          SizedBox(height: 8),
          InkWell(
            onTap: () => launchUrl(Uri.parse(qrCode.url)),
            child: Text(
              '${S.of(context).url}: ${qrCode.url}',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).close),
        ),
      ],
    );
}
