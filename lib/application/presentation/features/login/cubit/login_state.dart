part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
    this.error,
  });
  final bool isLoading;
  final dynamic error;

  @override
  List<Object?> get props => [isLoading, error];

  LoginState copyWith({
    final bool? isLoading,
    final dynamic error,
  }) =>
      LoginState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}
