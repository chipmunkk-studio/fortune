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
    const radius = 150.0; // 아크의 반지름

    const startAngle = -math.pi / 2; // 시작 각도를 -90도로 설정
    const sweepAngle = math.pi / 2; // 스윕 각도를 90도로 설정 (1/4 원)

    final Offset gradientStart = Offset(
      centerX + radius * math.cos(startAngle + 0.1), // 그라데이션 시작점 조정
      centerY + radius * math.sin(startAngle + 0.1),
    );

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        gradientStart,
        Offset(centerX + radius, centerY),
        [
          Colors.transparent, // 시작 부분 완전 투명
          Colors.transparent, // 시작 부분 완전 투명
          ColorName.primary.withOpacity(0.1), // 중간 부분 약간 투명한 초록색
          ColorName.primary.withOpacity(0.4), // 더 진한 초록색
          ColorName.primary, // 끝 부분 완전 불투명한 초록색
        ],
        [0.0,0.0, 0.3, 0.7, 1.0], // colorStops: 시작, 중간, 끝
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
