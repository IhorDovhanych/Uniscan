import 'package:dartz/dartz.dart';
import 'package:uniscan/application/domain/core/use_case.dart';
import 'package:uniscan/application/domain/repository/auth_repository.dart';
import 'package:uniscan/core/error/base_exception.dart';

class LogInWithGoogleUseCase extends AsyncUseCaseNoInput<void> {
  const LogInWithGoogleUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<BaseException, void>> call() => _authRepository.logInWithGoogle();
}
