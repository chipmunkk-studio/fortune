import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class GridPainter extends CustomPainter {
  final double gridSpacing;

  GridPainter({required this.gridSpacing});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = ColorName.primary
      ..style = PaintingStyle.stroke;

    final Paint backgroundPaint = Paint()
      ..color = ColorName.grey900
      ..style = PaintingStyle.fill;

    // 배경색으로 빨간색을 칠합니다.
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    for (var i = 0.0; i <= size.width; i += gridSpacing) {
      for (var j = 0.0; j <= size.height; j += gridSpacing) {
        canvas.drawRect(Rect.fromLTWH(i, j, gridSpacing, gridSpacing), gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
