import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class FortuneMapGridPainter extends CustomPainter {
  final double gridSpacing;

  FortuneMapGridPainter({required this.gridSpacing});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = ColorName.primary.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = Platform.isIOS ? 0.3 : 0.1;

    final Paint thickCrossPaint = Paint()
      ..color = ColorName.primary.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = Platform.isIOS  ? 0.6: 0.2;  // 십자 부분을 좀 더 굵게 그리기 위해

    final Paint backgroundPaint = Paint()
      ..color = ColorName.grey900
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // 가로선과 세로선을 그림.
    for (var j = 0.0; j <= size.height; j += gridSpacing) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), gridPaint);
    }
    for (var i = 0.0; i <= size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }

    // 교차 지점에서 십자 모양만 굵게 그림.
    double crossHalfLength = gridSpacing / 5; // 격자의 너비의 1/3
    for (var i = 0.0; i <= size.width; i += gridSpacing * 3) {  // 3칸 간격 추가
      for (var j = 0.0; j <= size.height; j += gridSpacing * 3) {  // 3칸 간격 추가
        // 가로 십자
        canvas.drawLine(Offset(i - crossHalfLength, j), Offset(i + crossHalfLength, j), thickCrossPaint);
        // 세로 십자
        canvas.drawLine(Offset(i, j - crossHalfLength), Offset(i, j + crossHalfLength), thickCrossPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
