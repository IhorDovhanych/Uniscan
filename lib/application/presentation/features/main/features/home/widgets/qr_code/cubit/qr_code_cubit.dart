import 'package:equatable/equatable.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/core/cubit/cubit_base.dart';

part 'qr_code_state.dart';

class QrCodeCubit extends CubitBase<QrCodeState> {
  QrCodeCubit(this._qrCodeService) : super(const QrCodeState());
  final QrCodeService _qrCodeService;

  Future<void> addQrCode(final QrCodeModel qrCode) =>
      _qrCodeService.addQrCode(qrCode);

  Future<void> updateQrCode(final String docID, final QrCodeModel qrCode) =>
      _qrCodeService.updateQrCode(docID, qrCode);

  Future<void> deleteQrCode(final String docID) =>
      _qrCodeService.deleteQrCode(docID);
}
