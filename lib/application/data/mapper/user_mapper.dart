import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniscan/application/data/models/user.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';

extension UserEntityX on UserEntity {
  UserModel get toModel => UserModel(
        id: id,
        email: email,
        name: name,
        avatar: avatar,
        qrCodes: qrCodes,
      );
}

extension UserModelX on UserModel {
  UserEntity get toEntity => UserEntity(
        id: id,
        email: email,
        name: name,
        avatar: avatar,
        qrCodes: qrCodes,
      );
}

extension UserX on User {
  UserModel get toModel => UserModel(
        id: uid,
        name: displayName ?? '',
        email: email ?? '',
        avatar: photoURL ?? '',
        qrCodes: [],
      );
}
