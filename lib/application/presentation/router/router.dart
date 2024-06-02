import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:uniscan/application/presentation/features/login/page/login_page.dart';
import 'package:uniscan/application/presentation/features/main/page/main_page.dart';
import 'package:uniscan/application/presentation/initial_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page|Screen|BottomSheet,Route',
  routes: [
    AutoRoute(
      path: '/',
      page: InitialPage,
      children: [
        CustomRoute(
          initial: true,
          path: 'login',
          page: EmptyRouterPage,
          name: 'UnAuthorizedRouter',
          transitionsBuilder: TransitionsBuilders.fadeIn,
          children: [
            CustomRoute(
              path: '',
              page: LoginPage,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        CustomRoute(
          path: 'main_page',
          page: MainPage,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
      ],
    ),
    RedirectRoute(
      path: '*',
      redirectTo: '/',
    ),
  ],
)
class $AppRouter {}