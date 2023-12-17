import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class FortuneRadarPainter extends CustomPainter {
  final double rotation;

  FortuneRadarPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const radius = 130.0; // 아크의 반지름
    const startAngle = -math.pi / 180 * 145; // 시작 각도
    const sweepAngle = math.pi / 180 * 37.5; // 스윕 각도

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(
          centerX + radius * math.cos(startAngle),
          centerY + radius * math.sin(startAngle),
        ),
        Offset(
          centerX + radius * math.cos(startAngle + sweepAngle),
          centerY + radius * math.sin(startAngle + sweepAngle),
        ),
        [
          ColorName.primary.withOpacity(0.0),
          ColorName.primary.withOpacity(0.02),
          ColorName.primary.withOpacity(0.3),
          ColorName.primary.withOpacity(0.8),
        ],
        [
          0.0,
          0.02,
          0.3,
          0.8,
        ], // colorStopsps
      )
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(rotation);
    canvas.translate(-centerX, -centerY);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      true,
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
