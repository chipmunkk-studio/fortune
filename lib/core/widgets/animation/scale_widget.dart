import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class ScaleWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final bool isRipple;
  final double scaleX;
  final double scaleY;

  const ScaleWidget({
    super.key,
    required this.child,
    this.onTapDown,
    this.onTapUp,
    this.scaleX = 0.9,
    this.scaleY = 0.9,
    this.isRipple = false,
  });

  @override
  State<StatefulWidget> createState() => _ScaleWidgetState();
}

class _ScaleWidgetState extends State<ScaleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Matrix4> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    final matrixTween = Matrix4Tween(
      begin: Matrix4.identity(),
      end: Matrix4.identity()
        ..scale(
          widget.scaleX,
          widget.scaleY,
        ),
    );

    _animation = matrixTween.animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.onTapDown != null) {
      widget.onTapDown!();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.onTapUp != null) {
      widget.onTapUp!();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      splashColor: widget.isRipple ? ColorName.grey800 : Colors.transparent,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            transform: _animation.value,
            alignment: FractionalOffset.center,
            child: widget.child,
          );
        },
      ),
    );
  }

  void _onTapCancel() {
    _controller.reverse();
  }
}
