import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniscan/application/presentation/features/main/features/home/cubit/home_cubit.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_dialog.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/qr_code_item.dart';
import 'package:uniscan/application/presentation/widgets/buttons/logout/widget/logout.dart';
import 'package:uniscan/generated/l10n.dart';

class QrCodeList extends StatelessWidget {
  const QrCodeList({
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) => BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (final previous, final current) => previous.qrCodes != current.qrCodes,
        builder: (final context, final state) => state.qrCodes.isEmpty
            ? Center(
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(50),
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        child: SvgPicture.asset(
                          'assets/svg/fake_qr.svg',
                          colorFilter: ColorFilter.mode(
                            Colors.black26,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 200,
                        child: Text(
                          S.of(context).no_scanned_qr_codes_yet,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      LogoutButton(),
                    ],
                  ),
                ),
              )
            : Scrollbar(
                child: ListView.builder(
                  itemCount: state.qrCodes.length + 1, // Add 1 for SizedBox
                  itemBuilder: (final context, final index) => index < state.qrCodes.length
                      ? QrCodeItem(
                          qrCode: state.qrCodes[index],
                          openQrCode: () {
                            QrCodeDialog.show(context, qrCode: state.qrCodes[index]);
                          },
                          deleteQrCode: () {
                            context.read<HomeCubit>().deleteQrCode(state.qrCodes[index]);
                          },
                        )
                      : Flex(
                          direction: Axis.vertical,
                          children: [LogoutButton(), SizedBox(height: 35.0)],
                        ),
                ),
              ),
      );
}
