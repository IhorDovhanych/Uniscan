import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniscan/application/data/models/user.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';

abstract class UserService {
  Future<void> createUser();
  Future<void> addQrCodeToUser(String docID);
  Future<void> getUsersQrCodes();
  Future<void> deleteQrCodeFromUser(String docID);
}

class UserServiceImpl extends UserService {
  UserModel? user;
  final CollectionReference _users;
  final Stream<UserEntity?> _userStream;

  UserServiceImpl(this._users, this._userStream);

  Future<void> createUser() async {
    UserEntity? u = await _userStream.first;
    if (u != null) {
      user = UserModel(
        id: u.id,
        email: u.email,
        name: u.name,
        avatar: u.avatar,
        qrCodes: [],
      );
      var querySnapshot = await _users.where('id', isEqualTo: user?.id).get();
      if (querySnapshot.docs.isEmpty) {
        await _users.add({
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

  Future<void> addQrCodeToUser(String docID) async {
    UserEntity? u = await _userStream.first;
    if (u != null) {
      user = UserModel(
        id: u.id,
        email: u.email,
        name: u.name,
        avatar: u.avatar,
        qrCodes: [],
      );
      var querySnapshot = await _users.where('id', isEqualTo: user?.id).get();
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
    UserEntity? u = await _userStream.first;
    if (u != null) {
      var querySnapshot = await _users.where('id', isEqualTo: u.id).get();
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

  Future<void> deleteQrCodeFromUser(String docID) async {
    UserEntity? u = await _userStream.first;
    if (u != null) {
      var querySnapshot = await _users.where('id', isEqualTo: u.id).get();
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
