import 'package:dartz/dartz.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/core/error/base_exception.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get currentUserStream;
  Future<Either<BaseException, void>> logInWithGoogle();
  Future<Either<BaseException, void>> logOut();
}
