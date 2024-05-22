import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniscan/application/presentation/features/main/features/home/page/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    final Key? key,
    this.initialTabIndex = 0,
  }) : super(key: key);

  final int initialTabIndex;

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: HomePage(barcode: '')
      );
}
