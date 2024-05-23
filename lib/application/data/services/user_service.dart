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
  Stream<UserEntity?> get _currentUserStream =>
      getIt<AuthRepository>().currentUserStream;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  UserModel? user;

  UserServiceImpl() {
    _initializeUser();
  }

  void _initializeUser() {
    _currentUserStream.listen((u) {
      if (u != null) {
        user = UserModel(
          id: u.id,
          email: u.email,
          name: u.name,
          avatar: u.avatar,
          qrCodes: [],
        );
      } else {
        user = UserModel(
          id: '',
          email: '',
          name: '',
          avatar: '',
          qrCodes: [],
        );
      }
    });
  }

  Future<void> createUser() {
    return users.add({
      'id': user?.id,
      'email': user?.email,
      'name': user?.name,
      'avatar': user?.avatar,
      'qrCodes': [],
    });
  }
}
