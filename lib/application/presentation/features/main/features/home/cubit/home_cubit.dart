import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/domain/usecase/get_qr_codes_stream_use_case.dart';
import 'package:uniscan/core/cubit/cubit_base.dart';

part 'home_state.dart';

class HomeCubit extends CubitBase<List<QrCodeEntity>?> {

  HomeCubit(this._getQrCodesStreamUseCase) : super(null){
    _subscribeToQrCodeChanges();
  }

  final GetQrCodesStreamUseCase _getQrCodesStreamUseCase;
  StreamSubscription<QrCodeEntity?>? _subscription;
  final List<QrCodeEntity> _qrCodes = [];

  void _subscribeToQrCodeChanges() {
    _subscription = _getQrCodesStreamUseCase.listen((final qrCode) {
      if (qrCode != null) {
        _qrCodes.add(qrCode);
      } else {
        _qrCodes.clear();
      }
      emit(List<QrCodeEntity>.from(_qrCodes));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
