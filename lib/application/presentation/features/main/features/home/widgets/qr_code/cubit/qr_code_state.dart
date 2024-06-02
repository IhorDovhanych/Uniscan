part of 'qr_code_cubit.dart';

class QrCodeState extends Equatable {
  const QrCodeState({
    required this.qrCode,
    this.success = false,
    this.isLoading = false,
    this.error,
  });

  final QrCodeEntity qrCode;
  final bool success;
  final bool isLoading;
  final dynamic error;

  @override
  List<Object?> get props => [
        qrCode,
        success,
        isLoading,
        error,
      ];

  QrCodeState copyWith({
    final QrCodeEntity? qrCode,
    final bool? success,
    final bool? isLoading,
    final dynamic error,
  }) =>
      QrCodeState(
        qrCode: qrCode ?? this.qrCode,
        success: success ?? this.success,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}
