import 'package:flutter/material.dart';

const double _defaultScaleMinValue = 0.85;
const double _defaultOpacityMinValue = 0.75;
const Curve _defaultScaleCurve = Curves.linear;
const Curve _defaultOpacityCurve = Curves.linear;
const double _moveDistanceThreshold = 10.0;
const Duration _defaultDuration = Duration(milliseconds: 125);

class ScaleTap extends StatefulWidget {
  const ScaleTap({
    final Key? key,
    this.onPressed,
    this.onLongPress,
    required this.child,
    this.duration,
    this.scaleMinValue,
    this.opacityMinValue,
    this.scaleCurve,
    this.opacityCurve,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;
  final Duration? duration;
  final double? scaleMinValue;
  final Curve? scaleCurve;
  final Curve? opacityCurve;
  final double? opacityMinValue;

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  PointerDownEvent? _downEvent;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
    _scale = Tween<double>(begin: 1.0, end: 1.0).animate(_animationController);
    _opacity = Tween<double>(begin: 1.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animate({final double? scale, final double? opacity, final Duration? duration}) async {
    if (!mounted) return;
    _animationController.stop();
    _animationController.duration = duration ?? Duration.zero;

    _scale = Tween<double>(
      begin: _scale.value,
      end: scale,
    ).animate(CurvedAnimation(
      curve: widget.scaleCurve ?? _defaultScaleCurve,
      parent: _animationController,
    ));
    _opacity = Tween<double>(
      begin: _opacity.value,
      end: opacity,
    ).animate(CurvedAnimation(
      curve: widget.opacityCurve ?? _defaultOpacityCurve,
      parent: _animationController,
    ));
    _animationController.reset();
    return _animationController.forward();
  }

  Future<void> _onTapDown(final _event) async {
    _downEvent = _event;
    return _animate(
      scale: widget.scaleMinValue ?? _defaultScaleMinValue,
      opacity: widget.opacityMinValue ?? _defaultOpacityMinValue,
      duration: widget.duration ?? _defaultDuration,
    );
  }

  Future<void> _onTapUp(final _) async {
    if (_animationController.isAnimating && _animationController.status == AnimationStatus.reverse) return;
    return _animate(
      scale: 1.0,
      opacity: 1.0,
      duration: widget.duration ?? _defaultDuration,
    );
  }

  Future<void> _onTapMove(final PointerMoveEvent _event) async {
    if (_downEvent == null) return;
    final moveDistance = (_downEvent!.position - _event.position).distance;
    if (moveDistance < _moveDistanceThreshold) return;
    _downEvent = null;
    return _onTapUp(_event);
  }

  Future<void> _onTapCancel(final _) => _onTapUp(_);

  @override
  Widget build(final BuildContext context) {
    final isTapEnabled = widget.onPressed != null || widget.onLongPress != null;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (final _, final Widget? child) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: child,
        ),
      ),
      child: Listener(
        onPointerDown: isTapEnabled ? _onTapDown : null,
        onPointerCancel: _onTapCancel,
        onPointerMove: _onTapMove,
        onPointerUp: _onTapUp,
        child: GestureDetector(
          onTap: isTapEnabled ? widget.onPressed : null,
          onLongPress: isTapEnabled ? widget.onLongPress : null,
          onTapCancel: () => _onTapCancel(null),
          // TODO: Find a way to get rid of this ColoredBox, the issue is related to tap area that is working in wrong way without it.
          child: ColoredBox(
            color: Colors.transparent,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
