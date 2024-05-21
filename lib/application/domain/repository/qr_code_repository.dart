import 'package:dartz/dartz.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/core/error/failures.dart';

abstract class QrCodeRepository {
  Future<Either<Failure, QrCodeEntity>> getUsersQrCodes(List<QrCode> qrCodesList);

  Future<void> addQrCode(QrCode qrCode);
}
