import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<int> {
  MainCubit() : super(0);

  void setValue(final int value) => emit(value);

  void goToHomePage() {
    emit(0);
  }

  void goToCameraPage() => emit(1);
}
