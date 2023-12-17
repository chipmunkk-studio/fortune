import 'package:flutter/material.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/painter/squircle_painter.dart';

class CenterProfile extends StatelessWidget {
  final String imageUrl;
  final Color backgroundColor;

  const CenterProfile({
    super.key,
    required this.imageUrl,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 48,
          height: 53,
          child: CustomPaint(
            painter: _CenterProfileBackgroundPainter(backgroundColor),
          ),
        ),
        Positioned(
          left: 3,
          right: 3,
          top: 3,
          child: FortuneCachedNetworkImage(
            imageUrl: imageUrl,
            width: 42,
            height: 42,
            placeholder: CustomPaint(
              painter: SquirclePainter(),
              child: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            errorWidget: CustomPaint(
              painter: SquirclePainter(),
              child: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            imageShape: ImageShape.squircle,
          ),
        ),
      ],
    );
  }
}

class _CenterProfileBackgroundPainter extends CustomPainter {
  final Color backgroundColor;

  _CenterProfileBackgroundPainter(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.4500000);
    path_0.cubicTo(0, size.height * 0.1125000, size.width * 0.1250000, 0, size.width * 0.5000000, 0);
    path_0.cubicTo(size.width * 0.8750000, 0, size.width, size.height * 0.1125000, size.width, size.height * 0.4500000);
    path_0.cubicTo(size.width, size.height * 0.7875000, size.width * 0.8750000, size.height * 0.9000000,
        size.width * 0.5000000, size.height * 0.9000000);
    path_0.cubicTo(
        size.width * 0.1250000, size.height * 0.9000000, 0, size.height * 0.7875000, 0, size.height * 0.4500000);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = backgroundColor.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5622019, size.height * 0.9122133);
    path_1.cubicTo(size.width * 0.5400019, size.height * 0.9385317, size.width * 0.5289000, size.height * 0.9516917,
        size.width * 0.5156000, size.height * 0.9569033);
    path_1.cubicTo(size.width * 0.5014574, size.height * 0.9624467, size.width * 0.4853889, size.height * 0.9624467,
        size.width * 0.4712463, size.height * 0.9569033);
    path_1.cubicTo(size.width * 0.4579463, size.height * 0.9516917, size.width * 0.4468444, size.height * 0.9385317,
        size.width * 0.4246444, size.height * 0.9122133);
    path_1.cubicTo(size.width * 0.3925148, size.height * 0.8741233, size.width * 0.3764500, size.height * 0.8550783,
        size.width * 0.3758500, size.height * 0.8391983);
    path_1.cubicTo(size.width * 0.3752148, size.height * 0.8223733, size.width * 0.3840296, size.height * 0.8063917,
        size.width * 0.3993037, size.height * 0.7966733);
    path_1.cubicTo(size.width * 0.4137185, size.height * 0.7875017, size.width * 0.4402870, size.height * 0.7875017,
        size.width * 0.4934222, size.height * 0.7875017);
    path_1.cubicTo(size.width * 0.5465593, size.height * 0.7875017, size.width * 0.5731259, size.height * 0.7875017,
        size.width * 0.5875426, size.height * 0.7966733);
    path_1.cubicTo(size.width * 0.6028167, size.height * 0.8063917, size.width * 0.6116296, size.height * 0.8223733,
        size.width * 0.6109944, size.height * 0.8391983);
    path_1.cubicTo(size.width * 0.6103963, size.height * 0.8550783, size.width * 0.5943315, size.height * 0.8741233,
        size.width * 0.5622019, size.height * 0.9122133);
    path_1.close();

    Paint paint1 = Paint()..style = PaintingStyle.fill;
    paint1.color = backgroundColor.withOpacity(1.0);
    canvas.drawPath(path_1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
