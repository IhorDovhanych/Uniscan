import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/presentation/cubit/auth_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/camera/page/camera_page.dart';
import 'package:uniscan/application/presentation/features/main/features/home/page/home_page.dart';
import 'package:uniscan/application/presentation/router/router.gr.dart';
import 'package:uniscan/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _provideBlocAndRunApp();
}

Future<void> _provideBlocAndRunApp() async {
  await pushScopeAsync(appScope);
  runApp(
    BlocProvider<AuthCubit>(
      create: (final _) => getIt<AuthCubit>(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //final PageController _pageController = PageController();

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'NAMU'),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (final context, final child) => child!
    );
  }
}
