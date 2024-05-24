import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniscan/application/data/models/user.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';

abstract class UserService {
  Future<void> createUser();
  Future<void> addQrCodeToUser(Stream<UserEntity?> userStream, String docID);
  Future<void> getUsersQrCodes();
  Future<void> deleteQrCodeFromUser(Stream<UserEntity?> userStream, String docID);
  CollectionReference get users;
}

class UserServiceImpl extends UserService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  UserModel? user;
  Stream<UserEntity?> userStream = getIt<AuthRepository>().currentUserStream;

  Future<void> createUser() async {
    UserEntity? u = await userStream.first;
    if (u != null) {
      user = UserModel(
        id: u.id,
        email: u.email,
        name: u.name,
        avatar: u.avatar,
        qrCodes: [],
      );
      var querySnapshot = await users.where('id', isEqualTo: user?.id).get();
      if (querySnapshot.docs.isEmpty) {
        await users.add({
          'id': user?.id,
          'email': user?.email,
          'name': user?.name,
          'avatar': user?.avatar,
          'qrCodes': user?.qrCodes,
        });
      } else {
        print('User already exists');
      }
    } else {
      print('Empty user data');
    }
  }

  Future<void> addQrCodeToUser(Stream<UserEntity?> userStream, String docID) async {
    UserEntity? u = await userStream.first;
    if (u != null) {
      user = UserModel(
        id: u.id,
        email: u.email,
        name: u.name,
        avatar: u.avatar,
        qrCodes: [],
      );
      var querySnapshot = await users.where('id', isEqualTo: user?.id).get();
      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs.first;
        await documentSnapshot.reference.update({
          'qrCodes': FieldValue.arrayUnion([docID]),
        });
        print('QR code added successfully');
      } else {
        print('User document not found');
      }
    } else {
      print('Empty user data');
    }
  }

  Future<List<String>> getUsersQrCodes() async {
    UserEntity? u = await userStream.first;
    if (u != null) {
      var querySnapshot = await users.where('id', isEqualTo: u.id).get();
      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs.first;
        List<String> qrCodes = List<String>.from(documentSnapshot['qrCodes']);
        return qrCodes;
      } else {
        print('User document not found');
        return [];
      }
    } else {
      print('Empty user data');
      return [];
    }
  }
  Future<void> deleteQrCodeFromUser(Stream<UserEntity?> userStream, String docID) async {
    UserEntity? u = await userStream.first;
    if (u != null) {
      var querySnapshot = await users.where('id', isEqualTo: u.id).get();
      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs.first;
        List<String> qrCodes = List<String>.from(documentSnapshot['qrCodes']);
        qrCodes.remove(docID); // Remove the specified docID from qrCodes array
        await documentSnapshot.reference.update({
          'qrCodes': qrCodes,
        });
        print('QR code deleted successfully');
      } else {
        print('User document not found');
      }
    } else {
      print('Empty user data');
    }
  }
}
