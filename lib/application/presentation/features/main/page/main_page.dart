import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniscan/application/presentation/features/main/features/camera/page/camera_page.dart';
import 'package:uniscan/application/presentation/features/main/features/home/page/home_page.dart';

class MainPage extends StatelessWidget {
  MainPage({
    final Key? key,
    this.initialTabIndex = 0,
  }) : super(key: key);

  final int initialTabIndex;

  final PageController _pageController = PageController();
  @override
  Widget build(final BuildContext context) => Scaffold(
          body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        children: List.unmodifiable([
          const HomePage(
            barcode: '',
          ),
          CameraPage(pageController: _pageController)
        ]),
      ));
}
