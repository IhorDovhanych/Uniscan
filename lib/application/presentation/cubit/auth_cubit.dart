import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/domain/usecase/get_user_stream_use_case.dart';
import 'package:uniscan/application/domain/usecase/log_out_use_case.dart';
import 'package:uniscan/core/cubit/cubit_base.dart';

class AuthCubit extends CubitBase<UserEntity?> {
  AuthCubit(
    this._getUserStreamUseCase,
    this._logOutUseCase,
  ) : super(null) {
    _subscribeToUserChanges();
  }

  final GetUserStreamUseCase _getUserStreamUseCase;
  final LogOutUseCase _logOutUseCase;

  void _subscribeToUserChanges() {
    executeStream(_getUserStreamUseCase.listen((final user) {
      emit(user);
    }));
  }

  Future<void> logOut() async {
    await executeAsync(_logOutUseCase());
  }
}
