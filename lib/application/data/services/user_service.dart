import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniscan/application/data/models/user.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';

abstract class UserService {
  // Future<void> createUser();
  // Future<void> addQrCodeToUser();
  // Future<QrCode> getUsersQrCodes();
}

class UserServiceImpl extends UserService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  UserModel? user;

  Future<void> createUser(Stream<UserEntity?> userStream) async {
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
      user = UserModel(
        id: '',
        email: '',
        name: '',
        avatar: '',
        qrCodes: [],
      );
    }
  }
}
