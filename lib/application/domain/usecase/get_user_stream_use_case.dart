import 'dart:async';

import 'package:uniscan/application/domain/core/use_case.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';

class GetUserStreamUseCase extends StreamUseCaseNoParams<UserEntity?> {
  GetUserStreamUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  StreamSubscription<UserEntity?> listen(
    final void Function(UserEntity? event)? onData, {
    final Function? onError,
    final void Function()? onDone,
    final bool? cancelOnError,
  }) =>
      _authRepository.currentUserStream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}
