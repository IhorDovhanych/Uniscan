part of 'qr_code_cubit.dart';

class QrCodeState extends Equatable{
  const QrCodeState({this.docID, this.qrCode});
  final String? docID;
  final QrCode? qrCode;

  
  @override
  List<Object?> get props => [docID, qrCode];
  QrCodeState copyWith({
      final String? docID,
      final QrCode? qrCode
  }) =>
      QrCodeState(
        docID: docID,
        qrCode: qrCode,
      );
}