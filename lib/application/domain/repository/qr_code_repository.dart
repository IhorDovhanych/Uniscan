import 'package:dartz/dartz.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/core/error/base_exception.dart';

abstract class QrCodeRepository {
  Stream<List<QrCodeEntity>> getQrCodesStream();
  Future<Either<BaseException, void>> getQrCodeById(final String docID);
  Future<Either<BaseException, void>> addQrCode(final QrCodeEntity qrCode);
  Future<Either<BaseException, void>> updateQrCode(final QrCodeEntity qrCode);
  Future<Either<BaseException, void>> deleteQrCode(final String qrCodeId);
  Future<Either<BaseException,List<QrCodeEntity>>> getNearbyQrCodes(
      final double latitude, final double longitude);
}
