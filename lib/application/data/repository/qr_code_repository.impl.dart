import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniscan/application/data/mapper/qr_code_mapper.dart';
import 'package:uniscan/application/data/services/qr_code_service.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/domain/repository/qr_code_repository.dart';

class QrCodeRepositoryImpl implements QrCodeRepository {
  QrCodeRepositoryImpl(this._qrCodeService);

  final QrCodeService _qrCodeService;

  @override
  CollectionReference get qrCodes => _qrCodeService.qrCodes;

  @override
  Stream<List<QrCodeEntity>> getQrCodesStream() => _qrCodeService
      .getQrCodesStream()
      .map((final qrCodes) =>
          qrCodes.map((final qrCode) => qrCode.toEntity).toList())
      .asBroadcastStream();

  @override
  Future<QrCodeEntity>? getQrCodeById(final String docID) => _qrCodeService
      .getQrCodeById(docID)!
      .then((final qrCode) => qrCode.toEntity);
}
