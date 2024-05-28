import 'package:equatable/equatable.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';

class HomeState extends Equatable{

  HomeState({this.qrCodes = const []});

  final List<QrCodeEntity> qrCodes;

  @override
  List<Object?> get props => [qrCodes];
}