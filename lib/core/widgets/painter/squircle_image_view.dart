import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_painter.dart';
import 'package:http/http.dart' as http;

class SquircleNetworkImageView extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color backgroundColor;
  final SvgPicture? placeHolder;
  final EdgeInsets? placeHolderPadding;

  const SquircleNetworkImageView({
    super.key,
    required this.imageUrl,
    required this.size,
    this.backgroundColor = ColorName.deActiveDark,
    this.placeHolder,
    this.placeHolderPadding,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image?>(
      future: getImage(imageUrl),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? CustomPaint(
                painter: _NetworkPainter(
                  snapshot.requireData,
                  size,
                  backgroundColor,
                ),
                size: Size.square(size),
              )
            : CustomPaint(
                painter: SquirclePainter(color: backgroundColor),
                child: SizedBox.square(
                  dimension: size,
                  child: Padding(
                    padding: placeHolderPadding ?? const EdgeInsets.all(0),
                    child: placeHolder ?? Assets.images.ivDefaultProfile.svg(fit: BoxFit.cover),
                  ),
                ),
              );
      },
    );
  }

  Future<ui.Image?> getImage(String imageUrl) async {
    if (imageUrl.isEmpty) return null;
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final Uint8List bytes = response.bodyBytes;
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class _NetworkPainter extends CustomPainter {
  final ui.Image? image;
  final double size;
  final Color backgroundColor;

  _NetworkPainter(
    this.image,
    this.size,
    this.backgroundColor,
  );

  @override
  void paint(Canvas canvas, Size size) async {
    final _image = image;
    final rect = Rect.fromLTRB(0, 0, this.size, this.size);
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    // 스쿼클 모양
    Path squirclePath = Path()
      ..moveTo(0, size.height * 0.5000000)
      ..cubicTo(0, size.height * 0.1250000, size.width * 0.1250000, 0, size.width * 0.5000000, 0)
      ..cubicTo(size.width * 0.8750000, 0, size.width, size.height * 0.1250000, size.width, size.height * 0.5000000)
      ..cubicTo(
          size.width, size.height * 0.8750000, size.width * 0.8750000, size.height, size.width * 0.5000000, size.height)
      ..cubicTo(size.width * 0.1250000, size.height, 0, size.height * 0.8750000, 0, size.height * 0.5000000)
      ..close();
    canvas.clipPath(squirclePath);

    if (_image != null) {
      canvas.drawImageRect(
        _image,
        Rect.fromLTRB(0.0, 0.0, _image.width.toDouble(), _image.height.toDouble()),
        rect,
        paint,
      );
    } else {
      Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
      paint_1_fill.color = backgroundColor;
      canvas.drawPath(squirclePath, paint_1_fill);
    }
  }

  @override
  bool shouldRepaint(_NetworkPainter oldDelegate) => image != oldDelegate.image;
}
