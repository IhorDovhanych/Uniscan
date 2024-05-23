import 'package:equatable/equatable.dart';
import 'package:uniscan/application/data/services/user_service.dart';
import 'package:uniscan/application/domain/usecase/log_in_with_google_use_case.dart';
import 'package:uniscan/core/cubit/cubit_base.dart';

part 'login_state.dart';

class LoginCubit extends CubitBase<LoginState> {
  LoginCubit(
    this._logInWithGoogleUseCase,
  ) : super(const LoginState());

  final LogInWithGoogleUseCase _logInWithGoogleUseCase;

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(isLoading: true));
    final result = await executeAsync(_logInWithGoogleUseCase());
    UserServiceImpl userService = UserServiceImpl();
    userService.createUser();
    result.fold(
      (final l) => emit(state.copyWith(error: l, isLoading: false)),
      (final r) => emit(state.copyWith(isLoading: false)),
    );
  }
}
