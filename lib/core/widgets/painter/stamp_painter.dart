import 'package:flutter/material.dart';

class StampPainter extends CustomPainter {
  final Color color;

  StampPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) async {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(Rect.fromLTWH(0, 0, size.width, size.height),
          bottomRight: Radius.circular(size.width * 0.2608696),
          bottomLeft: Radius.circular(size.width * 0.2608696),
          topLeft: Radius.circular(size.width * 0.2608696),
          topRight: Radius.circular(size.width * 0.2608696)),
      paint,
    );
  }

  @override
  bool shouldRepaint(StampPainter oldDelegate) => false;
}
