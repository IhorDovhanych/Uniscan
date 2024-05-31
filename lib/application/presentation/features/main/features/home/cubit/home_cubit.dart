import 'package:equatable/equatable.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/domain/repository/qr_code_repository.dart';
import 'package:uniscan/application/domain/usecase/get_qr_codes_stream_use_case.dart';
import 'package:uniscan/core/cubit/cubit_base.dart';

part 'home_state.dart';

class HomeCubit extends CubitBase<HomeState> {
  HomeCubit(
    this._getQrCodesStreamUseCase,
    this._qrCodeRepository,
  ) : super(HomeState()) {
    _subscribeToQrCodeChanges();
  }

  final GetQrCodesStreamUseCase _getQrCodesStreamUseCase;
  final QrCodeRepository _qrCodeRepository;

  void _subscribeToQrCodeChanges() {
    executeStream(_getQrCodesStreamUseCase.listen((final qrCodes) {
      emit(state.copyWith(qrCodes: qrCodes));
    }));
  }

  void deleteQrCode(final QrCodeEntity qrCode) {
    executeAsync(_qrCodeRepository.deleteQrCode(qrCode.id));
  }
}
