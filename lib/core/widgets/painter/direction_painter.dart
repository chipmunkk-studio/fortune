import 'dart:math';

import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';

class DirectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final gradient = LinearGradient(
      colors: [
        ColorName.white.withOpacity(0.0),
        ColorName.white.withOpacity(0.1),
        ColorName.white.withOpacity(0.6),
        ColorName.white.withOpacity(0.8),
        ColorName.white.withOpacity(0.9),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final Rect rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: 120);
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // 1/4 원의 중간을 45도만 그리기
    canvas.drawArc(
      rect,
      1.35 * pi, // 시작 각도 (위쪽부터 시작하여 45도 회전)
      0.35 * pi, // 아크의 각도 (45도로 그림)
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
