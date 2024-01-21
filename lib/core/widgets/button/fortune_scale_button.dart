import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';

class FortuneScaleButton extends StatelessWidget {
  final String text;
  final dartz.Function0 onPress;
  final bool? isEnabled;
  final ButtonStyle? style;

  const FortuneScaleButton({
    super.key,
    required this.text,
    required this.onPress,
    this.isEnabled,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return _FortuneAnimatedButton(
      onPressed: isEnabled == false ? null : onPress,
      style: style,
      child: Text(
        text,
      ),
    );
  }
}

class _FortuneAnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const _FortuneAnimatedButton({
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<StatefulWidget> createState() => _FortuneAnimatedButtonState();
}

class _FortuneAnimatedButtonState extends State<_FortuneAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 0.95).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        ),
        child: ElevatedButton(
          style: widget.style,
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }
}
