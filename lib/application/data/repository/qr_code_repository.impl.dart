import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:uniscan/application/data/mapper/qr_code_mapper.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/domain/repository/qr_code_repository.dart';
import 'package:uniscan/core/error/base_exception.dart';
import 'package:uniscan/core/error/error_codes.dart';
import 'package:uniscan/core/utils/print_utils.dart';

class QrCodeRepositoryImpl implements QrCodeRepository {
  QrCodeRepositoryImpl(this._qrCodeService);

  final QrCodeService _qrCodeService;

  @override
  Stream<List<QrCodeEntity>> getQrCodesStream() => _qrCodeService.getCreatedByMeQrCodesStream
      .map((final qrCodes) => qrCodes.map((final qrCode) => qrCode.toEntity).toList())
      .asBroadcastStream();

  @override
  Future<Either<BaseException, QrCodeEntity?>> getQrCodeById(final String docID) async {
    try {
      final qrCode = await _qrCodeService.getQrCodeById(docID);
      return Right(qrCode?.toEntity);
    } catch (e, st) {
      const message = 'Failed to getQrCodeById';
      printError(message, e, st);
      return Left(BaseException(error: e, stack: st, code: ecNonDio, message: message));
    }
  }

  @override
  Future<Either<BaseException, void>> addQrCode(final QrCodeEntity qrCode) async {
    try {
      await _qrCodeService.addQrCode(qrCode.toModel);
      return const Right(null);
    } catch (e, st) {
      const message = 'Failed to addQrCode';
      printError(message, e, st);
      return Left(BaseException(error: e, stack: st, code: ecNonDio, message: message));
    }
  }

  @override
  Future<Either<BaseException, void>> updateQrCode(final QrCodeEntity qrCode) async {
    try {
      await _qrCodeService.updateQrCode(qrCode.toModel);
      return const Right(null);
    } catch (e, st) {
      const message = 'Failed to updateQrCode';
      printError(message, e, st);
      return Left(BaseException(error: e, stack: st, code: ecNonDio, message: message));
    }
  }

  @override
  Future<Either<BaseException, void>> deleteQrCode(final String qrCodeId) async {
    try {
      await _qrCodeService.deleteQrCode(qrCodeId);
      return const Right(null);
    } catch (e, st) {
      const message = 'Failed to deleteQrCode';
      printError(message, e, st);
      return Left(BaseException(error: e, stack: st, code: ecNonDio, message: message));
    }
  }
}
