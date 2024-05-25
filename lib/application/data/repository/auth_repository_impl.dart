import 'package:dartz/dartz.dart';
import 'package:uniscan/application/data/mapper/user_mapper.dart';
import 'package:uniscan/application/data/services/auth_service.dart';
import 'package:uniscan/application/data/services/user_service.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';
import 'package:uniscan/core/error/base_exception.dart';
import 'package:uniscan/core/error/custom_dio_error.dart';
import 'package:uniscan/core/error/error_codes.dart';
import 'package:uniscan/core/utils/print_utils.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(
    this._authService,
    this._userService,
  );

  final AuthService _authService;
  final UserService _userService;

  @override
  Stream<UserEntity?> get currentUserStream =>
      _userService.currentUserStream.map((final user) => user == null ? null : user.toEntity).asBroadcastStream();

  @override
  Future<Either<BaseException, void>> logInWithGoogle() async {
    try {
      await _authService.logInWithGoogle();
      return const Right(null);
    } catch (e, st) {
      const message = 'Failed to log in with google';
      printError(message, e, st);
      return e is CustomDioError
          ? Left(e.toBaseException(st, message))
          : Left(BaseException(error: e, stack: st, code: ecNonDio, message: message));
    }
  }

  @override
  Future<Either<BaseException, void>> logOut() async {
    try {
      await _authService.logOut();
      return const Right(null);
    } catch (e, st) {
      const message = 'Failed to log out';
      printError(message, e, st);
      return e is CustomDioError
          ? Left(e.toBaseException(st, message))
          : Left(BaseException(error: e, stack: st, code: ecNonDio, message: message));
    }
  }
}
