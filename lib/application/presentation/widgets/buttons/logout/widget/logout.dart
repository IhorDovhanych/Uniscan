import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/usecase/log_out_use_case.dart';
import 'package:uniscan/application/presentation/widgets/buttons/logout/cubit/logout_cubit.dart';
import 'package:uniscan/application/presentation/widgets/buttons/scale_tap.dart';

class LogoutButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogoutCubit>(
        create: (context) => LogoutCubit(getIt<LogOutUseCase>()),
        child: BlocBuilder<LogoutCubit, LogoutState>(
            builder: (final context, final state) => ScaleTap(
                  onPressed: () {
                    context.read<LogoutCubit>().logOut();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: const [
                        Icon(FontAwesomeIcons.google, color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          'Вийти з акаунту',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }
}
