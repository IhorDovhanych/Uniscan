import 'package:flutter/material.dart';

class LoadingViewWidget extends StatelessWidget {
  const LoadingViewWidget({
    final Key? key,
    required this.isLoading,
    required this.child,
    this.backgroundColor = Colors.white,
    this.backgroundOpacity = 1,
  }) : super(key: key);

  final bool isLoading;
  final Widget child;
  final Color backgroundColor;
  final double backgroundOpacity;

  @override
  Widget build(final BuildContext context) => Stack(
        children: [
          child,
          Visibility(
            visible: isLoading,
            child: Container(
              color: backgroundColor.withOpacity(backgroundOpacity),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          ),
        ],
      );
}
