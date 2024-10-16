import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';

double degToRad(double deg) => deg * math.pi / 180;

class MoonPainter extends CustomPainter {
  const MoonPainter({
    required this.animation,
    required this.moon,
    required this.cloudT,
    required this.cloudB,
    required this.star,
  }) : super(repaint: animation);

  final Animation animation;
  final ui.Image moon;
  final ui.Image cloudT, cloudB;
  final ui.Image star;

  @override
  void paint(Canvas canvas, Size size) {
    final double progress = animation.value;
    final bgColor = Color.lerp(const Color(0xFF0F405B), const Color(0xFF5BA9D3), progress)!;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bgColor,
    );

    final moonSize = Size.square(size.height - 10);

    final moonPosition = Offset(
      (size.width - moonSize.width) * progress + moonSize.width / 2,
      size.height / 2,
    );

    final Path moonPath = Path()
      ..addOval(Rect.fromCenter(
        center: const Offset(0, 0),
        width: moonSize.width,
        height: moonSize.height,
      ));

    final Path cutOutPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(ui.lerpDouble(moonSize.width / 3, moonSize.width * 1.5, progress)!, -20),
        width: moonSize.width,
        height: moonSize.height,
      ));
    final Path combinedPath = Path.combine(PathOperation.difference, moonPath, cutOutPath);

    canvas.save();

    canvas.translate(moonPosition.dx, moonPosition.dy);
    canvas.rotate(degToRad(360 * progress));

    canvas.clipPath(combinedPath);

    Paint paint = Paint();

    if (progress > .5) {
      final alpha = ui.lerpDouble(-255, 255, progress)!.toInt();
      paint.colorFilter = ColorFilter.mode(
        const Color(0xFFF6D35A).withAlpha(alpha),
        BlendMode.srcATop,
      );
    }
    canvas.drawImageRect(
      moon,
      Rect.fromLTWH(0, 0, moon.width.toDouble(), moon.height.toDouble()),
      Rect.fromCenter(center: const Offset(0, 0), width: moonSize.width, height: moonSize.height),
      paint,
    );
    canvas.restore();

    //*Stars
    double starWidth = star.width.toDouble();
    double starHeight = star.height.toDouble();

    double initialStarRatio = size.height / starHeight;
    double scaleFactor = ui.lerpDouble(initialStarRatio, 0, progress)!;
    canvas.drawImageRect(
      star,
      Rect.fromLTWH(0, 0, starWidth, starHeight),
      Rect.fromLTWH(
        size.width - starWidth * scaleFactor,
        (size.height - starHeight * scaleFactor) / 2,
        starWidth * scaleFactor,
        starHeight * scaleFactor,
      ),
      Paint(),
    );

    //* Clouds1

    double cBw = cloudB.width.toDouble();
    double cBh = cloudB.height.toDouble();

    final cloudPaint = Paint()
      ..color = Colors.white.withAlpha(ui.lerpDouble(0, 255, progress)!.toInt())
      ..blendMode = ui.BlendMode.srcOver;

    double cloudScale = (size.height / cBh) * .8;

    canvas.drawImageRect(
      cloudB,
      Rect.fromLTWH(0, 0, cBw, cBh),
      Rect.fromLTWH(
        (cBw * cloudScale * .35),
        ui.lerpDouble(size.height, size.height - (cBh * cloudScale) * .75, progress)!,
        cBw * cloudScale,
        cBh * cloudScale,
      ),
      cloudPaint,
    );

    double cTw = cloudT.width.toDouble();
    double cTh = cloudT.height.toDouble();

    canvas.drawImageRect(
      cloudT,
      Rect.fromLTWH(0, 0, cTw, cTh),
      Rect.fromLTWH(
        ui.lerpDouble(-cTw * cloudScale, -cTw * cloudScale * .10, progress)!,
        size.height - (cTh * cloudScale) + cTw * cloudScale * .10,
        cTw * cloudScale,
        cTh * cloudScale,
      ),
      cloudPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
