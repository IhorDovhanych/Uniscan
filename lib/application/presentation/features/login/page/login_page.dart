import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/presentation/features/login/cubit/login_cubit.dart';
import 'package:uniscan/application/presentation/widgets/buttons/scale_tap.dart';
import 'package:uniscan/application/presentation/widgets/loading/loading_view_widget.dart';
import 'package:uniscan/generated/l10n.dart';

class LoginPage extends StatelessWidget with AutoRouteWrapper {
  const LoginPage({final Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(final BuildContext context) => BlocProvider<LoginCubit>(
        create: (final _) => getIt<LoginCubit>(),
        child: this,
      );

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (final context, final state) => LoadingViewWidget(
            isLoading: state.isLoading,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svg/logo_full.svg'),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _GoogleLoginButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => ScaleTap(
        onPressed: () {
          context.read<LoginCubit>().loginWithGoogle();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.google, color: Colors.white),
              SizedBox(width: 16),
              Text(
                S.of(context).log_in_with_google,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
}
