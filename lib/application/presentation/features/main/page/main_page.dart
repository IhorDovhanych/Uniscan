import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/presentation/features/main/cubit/main_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/camera/page/camera_page.dart';
import 'package:uniscan/application/presentation/features/main/features/home/cubit/home_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/home/page/home_page.dart';

class MainPage extends StatefulWidget implements AutoRouteWrapper {
  MainPage({
    final Key? key,
    this.initialTabIndex = 0,
  }) : super(key: key);

  final int initialTabIndex;

  @override
  Widget wrappedRoute(final BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<MainCubit>(
            create: (final _) => getIt<MainCubit>(),
          ),
          BlocProvider<HomeCubit>(
            create: (final _) => getIt<HomeCubit>(),
          ),
        ],
        child: this,
      );

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    _pageController.addListener(() {
      context.read<MainCubit>().setValue(_pageController.page!.round());
    });
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: BlocListener<MainCubit, MainState>(
          listenWhen: (final previous, final current) => previous != current,
          listener: (final context, final state) {
            if (_pageController.page!.round() != state.page) {
              _pageController.animateToPage(
                state.page,
                duration: const Duration(milliseconds: 333),
                curve: Curves.bounceIn,
              );
            }
          },
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            children: [
              const HomePage(
                barcode: '',
              ),
              CameraPage()
            ],
          ),
        ),
      );
}
