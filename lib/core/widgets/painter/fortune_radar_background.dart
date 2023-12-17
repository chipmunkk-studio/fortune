import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class FortuneRadarBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.green.withOpacity(0.3);

    final Offset center = Offset(size.width / 2, size.height / 2);
    const double radiusInPixels = 130; // 예시를 위해 캔버스 크기의 절반을 반경으로 설정

    for (int i = 1; i <= 5; i++) {
      final double radiusStep = radiusInPixels * (i / 5);
      if (i == 5) {
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = ColorName.primary.withOpacity(0.8);
      } else {
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = ColorName.primary.withOpacity(0.5);
      }

      canvas.drawCircle(center, radiusStep, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
