import 'package:equatable/equatable.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/domain/repository/qr_code_repository.dart';
import 'package:uniscan/core/cubit/cubit_base.dart';

part 'qr_code_state.dart';

class QrCodeCubit extends CubitBase<QrCodeState> {
  QrCodeCubit(this._qrCodeRepository)
      : super(QrCodeState(
          qrCode: QrCodeEntity.empty(),
        ));

  final QrCodeRepository _qrCodeRepository;

  void init(final QrCodeEntity? qrCode, final String? url) {
    emit(state.copyWith(qrCode: qrCode));
    final newQrCode = state.qrCode.copyWith(url: url);
    emit(state.copyWith(qrCode: newQrCode));
  }

  void onChangeName(final String name) {
    final qrCode = state.qrCode.copyWith(name: name);
    emit(state.copyWith(qrCode: qrCode));
  }

  void onChangeUrl(final String url) {
    final qrCode = state.qrCode.copyWith(url: url);
    emit(state.copyWith(qrCode: qrCode));
  }

  Future<void> addQrCode() async {
    emit(state.copyWith(isLoading: true));
    final result = await executeAsync(_qrCodeRepository.addQrCode(state.qrCode));
    result.fold(
      (final l) => emit(state.copyWith(error: l, isLoading: false)),
      (final r) => emit(state.copyWith(success: true)),
    );
  }

  Future<void> updateQrCode() async {
    emit(state.copyWith(isLoading: true));

    final result = await executeAsync(_qrCodeRepository.updateQrCode(state.qrCode));
    result.fold(
      (final l) => emit(state.copyWith(error: l, isLoading: false)),
      (final r) => emit(state.copyWith(success: true)),
    );
  }
}
