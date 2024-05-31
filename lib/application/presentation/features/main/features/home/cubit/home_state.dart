part of 'home_cubit.dart';

class HomeState extends Equatable {
  HomeState({this.qrCodes = const []});

  final List<QrCodeEntity> qrCodes;

  @override
  List<Object?> get props => [qrCodes];

  HomeState copyWith({
    final List<QrCodeEntity>? qrCodes,
  }) =>
      HomeState(
        qrCodes: qrCodes ?? this.qrCodes,
      );
}
