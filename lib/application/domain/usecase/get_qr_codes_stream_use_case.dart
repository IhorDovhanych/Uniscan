import 'dart:async';

import 'package:uniscan/application/domain/core/use_case.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/domain/repository/qr_code_repository.dart';

class GetQrCodesStreamUseCase extends StreamUseCaseNoParams<QrCodeEntity?> {
  GetQrCodesStreamUseCase(this._qrCodeRepository);

  final QrCodeRepository _qrCodeRepository;

  @override
  StreamSubscription<QrCodeEntity?> listen(
    final void Function(QrCodeEntity? event)? onData, {
    final Function? onError,
    final void Function()? onDone,
    final bool? cancelOnError,
  }) =>
      _qrCodeRepository
          .getQrCodesStream()
          .asyncExpand((final qrCodesList) =>
              Stream.fromIterable(qrCodesList.isNotEmpty ? qrCodesList : [null]))
          .listen(
            onData,
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError,
          );
}
