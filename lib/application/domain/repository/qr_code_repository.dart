import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';

abstract class QrCodeRepository {
  CollectionReference get qrCodes;
  Stream<List<QrCodeEntity>> getQrCodesStream();
  Future<QrCodeEntity>? getQrCodeById(final String docID);
}
