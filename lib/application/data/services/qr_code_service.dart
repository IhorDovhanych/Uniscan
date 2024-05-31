import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uniscan/application/data/models/geo_position.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/geo_position_service.dart';
import 'package:uniscan/application/data/services/user_service.dart';

abstract class QrCodeService {
  CollectionReference<Map<String, dynamic>> get qrCodes;
  Future<void> addQrCode(final QrCodeModel qrCode);
  Stream<List<QrCodeModel>> get getCreatedByMeQrCodesStream;
  Future<QrCodeModel>? getQrCodeById(final String docID);
  Future<void> updateQrCode(final QrCodeModel newQrCode);
  Future<void> deleteQrCode(final String docID);
}

class QrCodeServiceImpl extends QrCodeService {
  QrCodeServiceImpl(this._userService, this._geoPositionService, this.qrCodes);

  final UserService _userService;
  final GeoPositionService _geoPositionService;
  @override
  final CollectionReference<Map<String, dynamic>> qrCodes;

  @override
  Future<void> addQrCode(final QrCodeModel qrCode) async {
    final Position pos = await _geoPositionService.determinePosition();
    final GeoPositionModel geoPosition = GeoPositionModel(latitude: pos.latitude, longitude: pos.longitude);

    final updatedQrCode = qrCode.copyWith(
      geoPosition: geoPosition,
      creatorId: _userService.currentUserId,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    final docRef = await qrCodes.add(updatedQrCode.toJson());
    await qrCodes.doc(docRef.id).set(updatedQrCode.copyWith(id: docRef.id).toJson());
    await _userService.addQrCodeToUser(docRef.id);
  }
  //* CREATE

  @override
  Stream<List<QrCodeModel>> get getCreatedByMeQrCodesStream async* {
    yield* qrCodes.where('creatorId', isEqualTo: _userService.currentUserId).snapshots().map((final event) {
      final docs = event.docs;
      return docs.map((final e) => QrCodeModel.fromJson(e.data())).toList();
    });
  }
//* READ/GET

  @override
  Future<QrCodeModel>? getQrCodeById(final String docID) async {
    try {
      final doc = await qrCodes.doc(docID).get();
      return QrCodeModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Error getting document: $e');
    }
  }
//* READ/GET

  @override
  Future<void> updateQrCode(final QrCodeModel qrCode) => qrCodes.doc(qrCode.id).update(qrCode
      .copyWith(
        updatedAt: DateTime.now(),
      )
      .toJson());
//* UPDATE

  @override
  Future<void> deleteQrCode(final String docID) {
    _userService.deleteQrCodeFromUser(docID);
    return qrCodes.doc(docID).delete();
  }
//* DELETE
}
