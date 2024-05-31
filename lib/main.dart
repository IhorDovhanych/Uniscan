import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/presentation/cubit/auth_cubit.dart';
import 'package:uniscan/application/presentation/router/router.gr.dart';
import 'package:uniscan/firebase_options.dart';
import 'package:uniscan/generated/l10n.dart';

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

  final _appRouter = AppRouter();

  @override
  Widget build(final BuildContext context) => MaterialApp.router(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'NAMU'),
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        builder: (final context, final child) => child!);
}
