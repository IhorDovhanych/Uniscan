import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 100.0,
      title: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30.0, top: 28.0),
            child: SvgPicture.asset(
              'assets/svg/logo_col.svg',
              height: 45,
            ),
          )
        ],
      ),
    );
  }
}
