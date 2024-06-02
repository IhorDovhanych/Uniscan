// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:auto_route/empty_router_widgets.dart' as _i2;
import 'package:flutter/material.dart' as _i6;
import 'package:uniscan/application/presentation/features/login/page/login_page.dart'
    as _i4;
import 'package:uniscan/application/presentation/features/main/page/main_page.dart'
    as _i3;
import 'package:uniscan/application/presentation/initial_page.dart' as _i1;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    InitialRoute.name: (routeData) {
      return _i5.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.InitialPage(),
      );
    },
    UnAuthorizedRouter.name: (routeData) {
      return _i5.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterPage(),
        transitionsBuilder: _i5.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    MainRoute.name: (routeData) {
      final args =
          routeData.argsAs<MainRouteArgs>(orElse: () => const MainRouteArgs());
      return _i5.CustomPage<dynamic>(
        routeData: routeData,
        child: _i3.MainPage(
          key: args.key,
          initialTabIndex: args.initialTabIndex,
        ),
        transitionsBuilder: _i5.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginRoute.name: (routeData) {
      return _i5.CustomPage<dynamic>(
        routeData: routeData,
        child: _i5.WrappedRoute(child: const _i4.LoginPage()),
        transitionsBuilder: _i5.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          InitialRoute.name,
          path: '/',
          children: [
            _i5.RouteConfig(
              '#redirect',
              path: '',
              parent: InitialRoute.name,
              redirectTo: 'login',
              fullMatch: true,
            ),
            _i5.RouteConfig(
              UnAuthorizedRouter.name,
              path: 'login',
              parent: InitialRoute.name,
              children: [
                _i5.RouteConfig(
                  LoginRoute.name,
                  path: '',
                  parent: UnAuthorizedRouter.name,
                ),
                _i5.RouteConfig(
                  '*#redirect',
                  path: '*',
                  parent: UnAuthorizedRouter.name,
                  redirectTo: '',
                  fullMatch: true,
                ),
              ],
            ),
            _i5.RouteConfig(
              MainRoute.name,
              path: 'main_page',
              parent: InitialRoute.name,
            ),
          ],
        ),
        _i5.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.InitialPage]
class InitialRoute extends _i5.PageRouteInfo<void> {
  const InitialRoute({List<_i5.PageRouteInfo>? children})
      : super(
          InitialRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'InitialRoute';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class UnAuthorizedRouter extends _i5.PageRouteInfo<void> {
  const UnAuthorizedRouter({List<_i5.PageRouteInfo>? children})
      : super(
          UnAuthorizedRouter.name,
          path: 'login',
          initialChildren: children,
        );

  static const String name = 'UnAuthorizedRouter';
}

/// generated route for
/// [_i3.MainPage]
class MainRoute extends _i5.PageRouteInfo<MainRouteArgs> {
  MainRoute({
    _i6.Key? key,
    int initialTabIndex = 0,
  }) : super(
          MainRoute.name,
          path: 'main_page',
          args: MainRouteArgs(
            key: key,
            initialTabIndex: initialTabIndex,
          ),
        );

  static const String name = 'MainRoute';
}

class MainRouteArgs {
  const MainRouteArgs({
    this.key,
    this.initialTabIndex = 0,
  });

  final _i6.Key? key;

  final int initialTabIndex;

  @override
  String toString() {
    return 'MainRouteArgs{key: $key, initialTabIndex: $initialTabIndex}';
  }
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '',
        );

  static const String name = 'LoginRoute';
}
