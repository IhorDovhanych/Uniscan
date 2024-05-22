import 'package:auto_route/auto_route.dart';
import 'package:uniscan/application/domain/entities/user_entity.dart';
import 'package:uniscan/application/presentation/router/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/auth_cubit.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) =>
      BlocListener<AuthCubit, UserEntity?>(
        listenWhen: (final prev, final next) =>
            (prev == null && next != null) ||
            (prev != null && next == null) ||
            (prev?.id != next?.id),
        listener: (final context, final state) {
          final router = AutoRouter.innerRouterOf(context, InitialRoute.name) ??
              context.router;
          if (state != null) {
            if (router.current.name == MainRoute.name) return;
            router.popUntil(ModalRoute.withName('/'));
            router.replace(MainRoute());
          } else {
            if (router.current.name == UnAuthorizedRouter.name) return;
            router.popUntil(ModalRoute.withName('/'));
            router.replace(const UnAuthorizedRouter());
          }
        },
        child: const AutoRouter(),
      );
}
