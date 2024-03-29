import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class FortuneRadarBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = ColorName.primary.withOpacity(0.2); // 선 색상의 투명도를 0.05로 고정

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = ColorName.primary.withOpacity(0.0); // 내부 색상의 투명도도 0.05로 설정

    final Offset center = Offset(size.width / 2, size.height / 2);
    const double radiusInPixels = 150;

    // 원 그리기, 가장 안쪽 원을 제외함
    for (int i = 2; i <= 5; i++) {
      final double radiusStep = radiusInPixels * (i / 5);
      strokePaint.strokeWidth = (i == 5) ? 3.5 : 1.5; // 가장 바깥쪽 원은 두껍게, 나머지는 일반적으로

      canvas.drawCircle(center, radiusStep, fillPaint);
      canvas.drawCircle(center, radiusStep, strokePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
