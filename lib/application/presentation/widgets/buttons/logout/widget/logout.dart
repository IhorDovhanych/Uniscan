import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uniscan/application/presentation/cubit/auth_cubit.dart';
import 'package:uniscan/application/presentation/widgets/buttons/scale_tap.dart';
import 'package:uniscan/generated/l10n.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => ScaleTap(
        onPressed: () {
          context.read<AuthCubit>().logOut();
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
                S.of(context).log_out,
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
