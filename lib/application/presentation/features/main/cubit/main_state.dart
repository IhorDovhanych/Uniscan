part of 'main_cubit.dart';

class MainState extends Equatable {
  const MainState({
    this.page = 1,
  });

  final int page;

  @override
  List<Object?> get props => [page];

  MainState copyWith({
    final int? page,
  }) =>
      MainState(
        page: page ?? this.page,
      );
}
