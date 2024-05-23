import 'package:equatable/equatable.dart';
import 'package:uniscan/application/domain/usecase/log_out_use_case.dart';
import 'package:uniscan/core/cubit/cubit_base.dart';

part 'logout_state.dart';

class LogoutCubit extends CubitBase<LogoutState> {
  LogoutCubit(
    this._logOutUseCase,
  ) : super(const LogoutState());

  final LogOutUseCase _logOutUseCase;

  Future<void> logOut() async {
    emit(state.copyWith(isLoading: true));
    final result = await executeAsync(_logOutUseCase());
    result.fold(
      (final l) => emit(state.copyWith(error: l, isLoading: false)),
      (final r) => emit(state.copyWith(isLoading: false)),
    );
  }
}
