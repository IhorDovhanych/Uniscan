import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState());

  void setValue(final int value) => emit(state.copyWith(page: value));

  void goToHomePage() {
    emit(state.copyWith(page: 0));
  }

  void goToCameraPage() => emit(state.copyWith(page: 1));
}

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
