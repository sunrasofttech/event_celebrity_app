import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

const s = 0.2;

class NavCustomPainter extends CustomPainter {
  late double loc;
  late double bottom;
  Color color;
  bool hasLabel;
  TextDirection textDirection;

  NavCustomPainter({required double startingLoc, required int itemsLength, required this.color, required this.textDirection, this.hasLabel = false}) {
    final span = 1.0 / itemsLength;
    final l = startingLoc + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
    bottom = hasLabel ? (Platform.isAndroid ? 0.45 : 0.35) : (Platform.isAndroid ? 0.6 : 0.5);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = 30;
    final double centerX = size.width * (loc + s / 2);
    final double centerY = radius;

    /*final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(centerX - radius, 0)
          ..cubicTo(
            centerX - radius,
            0, // control point 1
            centerX - radius,
            centerY, // control point 2
            centerX,
            centerY, // end point (center bottom)
          )
          ..cubicTo(
            centerX + radius,
            centerY, // smooth control from center
            centerX + radius,
            0, // control point near top
            centerX + radius,
            0, // end point gently raised (was 0)
          )
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();*/

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width * (loc - 0.05), 0)
          ..cubicTo(
            size.width * (loc + s * 0.2), // topX
            size.height * 0.05, // topY
            size.width * loc, // bottomX
            size.height * bottom, // bottomY
            size.width * (loc + s * 0.5), // centerX
            size.height * bottom, // centerY
          )
          ..cubicTo(
            size.width * (loc + s), // bottomX
            size.height * bottom, // bottomY
            size.width * (loc + s * 0.8), // topX
            size.height * 0.05, // topY
            size.width * (loc + s + 0.05),
            0,
          )
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
    // final path =
    //     Path()
    //       ..moveTo(0, 0)
    //       ..lineTo(size.width * (loc - 0.001), 0.05)
    //       ..cubicTo(
    //         size.width * (loc + s * 0.2), // topX
    //         size.height * 0.01, // topY
    //         size.width * loc, // bottomX
    //         size.height * bottom, // bottomY
    //         size.width * (loc + s * 0.70), // centerX
    //         size.height * bottom, // centerY
    //       )
    //       ..cubicTo(
    //         size.width * (loc * 1.85), // bottomX
    //         size.height * bottom, // bottomY
    //         size.width * (loc + s * 0.8), // topX
    //         size.height * 0.0, // topY
    //         size.width * (loc + s + 0.01),
    //         0,
    //       )
    //       ..lineTo(size.width, 0)
    //       ..lineTo(size.width, size.height)
    //       ..lineTo(0, size.height)
    //       ..close();
    // final path =
    //     Path()
    //       ..moveTo(0, 0)
    //       ..lineTo(size.width * (loc - 0.05), 0)
    //       ..cubicTo(
    //         size.width * (loc + s * 0.3), // topX
    //         size.height * 0.01, // topY
    //         size.width * loc, // bottomX
    //         size.height * bottom, // bottomY
    //         size.width * (loc + s * 0.5), // centerX
    //         size.height * bottom, // centerY
    //       )
    //       ..cubicTo(
    //         size.width * (loc + s), // bottomX
    //         size.height * bottom, // bottomY
    //         size.width * (loc + s * 0.8), // topX
    //         size.height * 0.1, // topY
    //         size.width * (loc + s + 0.01),
    //         0,
    //       )
    //       ..lineTo(size.width, 0)
    //       ..lineTo(size.width, size.height)
    //       ..lineTo(0, size.height)
    //       ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
