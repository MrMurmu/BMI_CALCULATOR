import 'dart:ui';

import 'package:flutter/material.dart';

class HeightSelectRulerPainter extends CustomPainter {
  final double currentHeight;
  final double width;

  HeightSelectRulerPainter({required this.currentHeight, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    const double bigTick = 40;
    const double smallTick = 20;
    const int totalTicks = 21;
    const int intervals = totalTicks - 1;

    final Paint paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2;

    final Paint highlightPaint = Paint()
      ..color = const Color.fromARGB(255, 216, 161, 57)
      ..strokeWidth = 4;

    double spacing = width / intervals;

    for (int i = 0; i < totalTicks; i++) {
      double x = i * spacing;
      double tickValue = (340 / intervals) * i;

      bool isBigTick = i % 5 == 0;
      double tickHeight = isBigTick ? bigTick : smallTick;

      bool isCurrentTick = (tickValue - currentHeight).abs() < 0.5;

      canvas.drawLine(
        Offset(x, size.height - tickHeight),
        Offset(x, size.height),
        isCurrentTick ? highlightPaint : paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HeightSelectRulerPainter oldDelegate) =>
      oldDelegate.currentHeight != currentHeight || oldDelegate.width != width;
}

