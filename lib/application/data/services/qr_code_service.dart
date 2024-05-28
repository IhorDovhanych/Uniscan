import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uniscan/application/data/models/geo_position.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/geo_position_service.dart';
import 'package:uniscan/application/data/services/user_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';

abstract class QrCodeService {
  CollectionReference get qrCodes;
  Future<void> addQrCode(final QrCodeModel qrCode);
  Stream<QuerySnapshot> getQrCodesStream();
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
    await _userService.addQrCodeToUser(docRef.id);
  }
  //* CREATE

  @override
  Stream<QuerySnapshot> getQrCodesStream() async* {
    UserEntity? u = await getIt<AuthRepository>().currentUserStream.first;
    CollectionReference users =
        await getIt<FirebaseFirestore>().collection('users');
    if (u != null) {
      final userQuerySnapshot = await users.where('id', isEqualTo: u.id).get();
      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDocumentSnapshot = userQuerySnapshot.docs.first;
        List<String> userQrCodes =
            List<String>.from(userDocumentSnapshot['qrCodes']);

        if (userQrCodes.isNotEmpty) {
          yield* qrCodes
              .orderBy('updatedAt', descending: true)
              .where(FieldPath.documentId, whereIn: userQrCodes)
              .snapshots();
        } else {
          yield* Stream<QuerySnapshot>.empty();
        }
      } else {
        print('User document not found');
        yield* Stream<QuerySnapshot>.empty();
      }
    } else {
      print('Empty user data');
      yield* Stream<QuerySnapshot>.empty();
    }
  }
//* READ/GET

  @override
  Future<QrCodeModel>? getQrCodeById(final String docID) async {
    try {
      final DocumentSnapshot doc = await qrCodes.doc(docID).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
