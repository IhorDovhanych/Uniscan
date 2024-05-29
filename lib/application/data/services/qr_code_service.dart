import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uniscan/application/data/models/geo_position.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/geo_position_service.dart';
import 'package:uniscan/application/data/services/user_service.dart';

abstract class QrCodeService {
  CollectionReference get qrCodes;
  Future<void> addQrCode(final QrCodeModel qrCode);
  Stream<List<QrCodeModel>> getQrCodesStream();
  Future<QrCodeModel>? getQrCodeById(final String docID);
  Future<void> updateQrCode(final String docID, final QrCodeModel newQrCode);
  Future<void> deleteQrCode(final String docID);
}

class QrCodeServiceImpl extends QrCodeService {
  QrCodeServiceImpl(this._userService, this._geoPositionService, this.qrCodes);

  final UserService _userService;
  final GeoPositionService _geoPositionService;
  @override
  final CollectionReference qrCodes;

  @override
Future<void> addQrCode(final QrCodeModel qrCode) async {
  final Position pos = await _geoPositionService.determinePosition();
  final GeoPositionModel geoPosition =
      GeoPositionModel(latitude: pos.latitude, longitude: pos.longitude);
  final DocumentReference docRef =
      await qrCodes.add(toMap(qrCode, position: geoPosition));
  final String documentId = docRef.id;
  final QrCodeModel updatedQrCode = qrCode.copyWith(id: documentId);
  await qrCodes.doc(documentId).set(toMap(updatedQrCode, position: geoPosition));
  await _userService.addQrCodeToUser(documentId);
}
  //* CREATE

  @override
  Stream<List<QrCodeModel>> getQrCodesStream() async* {
    final user = await _userService.currentUser;
    yield* qrCodes.where(FieldPath.documentId, whereIn: user?.qrCodes).snapshots().map((final event) {
      final docs = event.docs;
      return docs.map((final e) => QrCodeModel.fromJson(e.data()! as Map<String, dynamic>)).toList();
    });
  }
//* READ/GET

  @override
  Future<QrCodeModel>? getQrCodeById(final String docID) async {
    try {
      final DocumentSnapshot doc = await qrCodes.doc(docID).get();
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return QrCodeModel(name: data['name'], url: data['url']);
    } catch (e) {
      throw Exception("Error getting document: $e");
    }
  }
//* READ/GET

  @override
  Future<void> updateQrCode(final String docID, final QrCodeModel newQrCode) =>
      qrCodes.doc(docID).update(toMap(newQrCode, updated: true));
//* UPDATE

  @override
  Future<void> deleteQrCode(final String docID) {
    _userService.deleteQrCodeFromUser(docID);
    return qrCodes.doc(docID).delete();
  }
//* DELETE

  Map<String, dynamic> toMap(final QrCodeModel qrCode,
          {final bool updated = false, final GeoPositionModel? position}) =>
      {
        if(qrCode.id != null)
          'id': qrCode.id,
        'name': qrCode.name,
        'url': qrCode.url,
        if (position != null)
          'position': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'meters': position.meters
          },
        if (updated)
          'updatedAt': DateTime.now()
        else
          'updatedAt': qrCode.updatedAt,
        'createdAt': qrCode.createdAt,
      };
}
