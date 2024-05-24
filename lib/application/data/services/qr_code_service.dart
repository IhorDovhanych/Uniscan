import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/user_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';

abstract class QrCodeService {
  CollectionReference get qrCodes;
  Future<void> addQrCode(QrCode qrCode);
  Stream<QuerySnapshot> getQrCodesStream();
  Future<QrCode>? getQrCodeById(String docID);
  Future<void> updateQrCode(String docID, QrCode newQrCode);
  Future<void> deleteQrCode(String docID);
}

class QrCodeServiceImpl extends QrCodeService {
  final UserService _userService;
  final CollectionReference qrCodes;

  QrCodeServiceImpl(this._userService, this.qrCodes);

  Future<void> addQrCode(QrCode qrCode) async {
    DocumentReference docRef = await qrCodes.add(toMap(qrCode));
    _userService.addQrCodeToUser(docRef.id);
  }
  //* CREATE

  Stream<QuerySnapshot> getQrCodesStream() async* {
    UserEntity? u = await getIt<AuthRepository>().currentUserStream.first;
    CollectionReference users =
        await getIt<FirebaseFirestore>().collection('users');
    if (u != null) {
      var userQuerySnapshot = await users.where('id', isEqualTo: u.id).get();
      if (userQuerySnapshot.docs.isNotEmpty) {
        var userDocumentSnapshot = userQuerySnapshot.docs.first;
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

  Future<QrCode>? getQrCodeById(String docID) async {
    try {
      final DocumentSnapshot doc = await qrCodes.doc(docID).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return QrCode(name: data['name'], url: data['url']);
    } catch (e) {
      throw Exception("Error getting document: $e");
    }
  }
//* READ/GET

  Future<void> updateQrCode(String docID, QrCode newQrCode) {
    return qrCodes.doc(docID).update(toMap(newQrCode, updated: true));
  }
//* UPDATE

  Future<void> deleteQrCode(String docID) {
    _userService.deleteQrCodeFromUser(docID);
    return qrCodes.doc(docID).delete();
  }
//* DELETE

  Map<String, dynamic> toMap(QrCode qrCode, {bool updated = false}) {
    return {
      'name': qrCode.name,
      'url': qrCode.url,
      if (updated)
        'updatedAt': DateTime.now()
      else
        'updatedAt': qrCode.updatedAt,
      'createdAt': qrCode.createdAt,
    };
  }
}
