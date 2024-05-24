import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/user_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';

class QrCodeService {
  // get collection
  final CollectionReference qrCodes =
      FirebaseFirestore.instance.collection('qr_codes');

  //* CREATE
  Future<void> addQrCode(QrCode qrCode) async {
    DocumentReference docRef = await qrCodes.add({
      'name': qrCode.name,
      'url': qrCode.url,
      'createdAt': qrCode.createdAt,
      'updatedAt': qrCode.updatedAt,
    });
    String docID = docRef.id;
    getIt<UserService>()
        .addQrCodeToUser(getIt<AuthRepository>().currentUserStream, docID);
  }

//* READ/GET
  Stream<QuerySnapshot> getAllQrCodesStream() {
    final qrCodesStream =
        qrCodes.orderBy('updatedAt', descending: true).snapshots();
    return qrCodesStream;
  }

  Stream<QuerySnapshot> getQrCodesStream() async* {
    UserEntity? u = await getIt<AuthRepository>().currentUserStream.first;
    CollectionReference users = getIt<UserService>().users;
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

  Future<Map<String, dynamic>>? getQrCodeById(String docID) async {
    try {
      DocumentSnapshot doc = await qrCodes.doc(docID).get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Error getting document: $e");
    }
  }
//* UPDATE

  Future<void> updateQrCode(String docID, QrCode newQrCode) {
    return qrCodes.doc(docID).update({
      'name': newQrCode.name,
      'url': newQrCode.url,
      'updatedAt': DateTime.now()
    });
  }
//* DELETE

  Future<void> deleteQrCode(String docID) {
    return qrCodes.doc(docID).delete();
  }
}
