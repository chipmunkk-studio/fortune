import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';

class FortuneSwitchButton extends StatefulWidget {
  final dartz.Function1<bool, void> onToggle;

  const FortuneSwitchButton({
    Key? key,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<FortuneSwitchButton> createState() => _FortuneSwitchButtonState();
}

class _FortuneSwitchButtonState extends State<FortuneSwitchButton> {
  bool _isOn = false;
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

    setState(() {
      _isOn = !_isOn;
      widget.onToggle(_isOn);
    });

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
          color: _isOn ? ColorName.secondary : Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
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
