part of 'logout_cubit.dart';

class LogoutState extends Equatable {
  const LogoutState({
    this.isLoading = false,
    this.error,
  });
  final bool isLoading;
  final dynamic error;

  @override
  List<Object?> get props => [isLoading, error];

  LogoutState copyWith({
    final bool? isLoading,
    final dynamic error,
  }) =>
      LogoutState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}
