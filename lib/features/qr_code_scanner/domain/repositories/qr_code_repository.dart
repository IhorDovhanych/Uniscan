import 'package:uniscan/core/error/failures.dart';
import 'package:uniscan/features/qr_code_scanner/domain/entities/qr_code_entity.dart';
import 'package:uniscan/models/qr_code.dart';
import 'package:dartz/dartz.dart';

abstract class QrCodeRepository {
  Future<Either<Failure, QrCodeEntity>> getUsersQrCodes(List<QrCode> qrCodesList);
  
  Future<void> addQrCode(QrCode qrCode);
}