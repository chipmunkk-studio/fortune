import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class FortuneRadarBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = ColorName.primary; // 선 색상 설정

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = ColorName.primary.withOpacity(0.05); // 내부 색상의 투명도를 낮춤

    final Offset center = Offset(size.width / 2, size.height / 2);
    const double radiusInPixels = 150;

    // 원 그리기
    for (int i = 1; i <= 5; i++) {
      final double radiusStep = radiusInPixels * (i / 5);
      if (i == 5) {
        strokePaint
          ..strokeWidth = 3
          ..color = ColorName.primary.withOpacity(0.2); // 가장 바깥쪽 원은 두껍고 진하게
      } else {
        strokePaint
          ..strokeWidth = 1
          ..color = ColorName.primary.withOpacity(0.2); // 나머지 원은 보다 투명하게
      }

      canvas.drawCircle(center, radiusStep, fillPaint);
      canvas.drawCircle(center, radiusStep, strokePaint);
    }

    // 십자선 그리기
    const double lineLength = radiusInPixels * 2;
    strokePaint
      ..strokeWidth = 1
      ..color = ColorName.primary.withOpacity(0.2); // 십자선은 기본 스타일로 설정

    canvas.drawLine(
      Offset(center.dx, center.dy - lineLength / 2),
      Offset(center.dx, center.dy + lineLength / 2),
      strokePaint,
    ); // 수직선
    canvas.drawLine(
      Offset(center.dx - lineLength / 2, center.dy),
      Offset(center.dx + lineLength / 2, center.dy),
      strokePaint,
    ); // 수평선
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
