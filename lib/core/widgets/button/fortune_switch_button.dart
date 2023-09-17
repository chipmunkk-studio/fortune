import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class FortuneSwitchButton extends StatefulWidget {
  final dartz.Function1<bool, void> onToggle;
  final bool isOn;

  const FortuneSwitchButton({
    Key? key,
    required this.onToggle,
    required this.isOn,
  }) : super(key: key);

  @override
  State<FortuneSwitchButton> createState() => _FortuneSwitchButtonState();
}

class _FortuneSwitchButtonState extends State<FortuneSwitchButton> {
  late DateTime _lastToggleTime;

  @override
  void initState() {
    _lastToggleTime = DateTime.now();
    super.initState();
  }

  void _toggleSwitch() {
    final now = DateTime.now();

    // 토글버튼은 1초 디바운스 타임을 가짐.
    if (now.difference(_lastToggleTime) < const Duration(milliseconds: 1000)) {
      return;
    }

    widget.onToggle(widget.isOn);

    _lastToggleTime = now;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: Container(
        width: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: widget.isOn ? ColorName.secondary : Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            alignment: widget.isOn ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
