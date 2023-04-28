import 'dart:math' as math;

import 'package:flutter/material.dart';

class LinearBounceAnimation extends StatefulWidget {
  final Widget child;
  final int duration;

  const LinearBounceAnimation({
    Key? key,
    required this.child,
    this.duration = 2000,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LinearBounceAnimationState();
}

class _LinearBounceAnimationState extends State<LinearBounceAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.duration),
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double offset = math.sin(_animation.value * math.pi) * 8;
        return Transform.translate(
          offset: Offset(0, offset),
          child: widget.child,
        );
      },
    );
  }
}
