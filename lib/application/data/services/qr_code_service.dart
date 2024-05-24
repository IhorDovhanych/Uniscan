import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniscan/application/data/models/qr_code.dart';
import 'package:uniscan/application/data/services/user_service.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';

class QrCodeService {
  // get collection
  final CollectionReference qrCodes = FirebaseFirestore.instance.collection('qr_codes');

  //* CREATE
  Future<void> addQrCode(QrCode qrCode) async{
    DocumentReference docRef = await qrCodes.add({
      'name': qrCode.name,
      'url': qrCode.url,
      'createdAt': qrCode.createdAt,
      'updatedAt': qrCode.updatedAt,
    });
    String docID = docRef.id;
    getIt<UserService>().addQrCodeToUser(getIt<AuthRepository>().currentUserStream, docID);
  }

//* READ/GET
  Stream<QuerySnapshot> getQrCodesStream() {
    final qrCodesStream = qrCodes.orderBy('updatedAt', descending: true).snapshots();
    return qrCodesStream;
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
    return qrCodes.doc(docID).update({'name': newQrCode.name, 'url': newQrCode.url, 'updatedAt': DateTime.now()});
  }
//* DELETE

  Future<void> deleteQrCode(String docID) {
    return qrCodes.doc(docID).delete();
  }
}
