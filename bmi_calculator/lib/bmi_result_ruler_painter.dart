import 'package:flutter/material.dart';

class BmiResultRulerPainter extends CustomPainter {
  final double currentBmiPosition;
  final double width;

  BmiResultRulerPainter({required this.currentBmiPosition, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    const int totalTicks = 40;
    const int intervals = totalTicks - 1;
    const double tickHeight = 20;
    const double spacing = 7.5;
    
    
    final Paint highlightPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 6;

    Color getColorForTick(int index) {
      if (index < 8) return Colors.blue;       // Underweight
      if (index < 21) return Colors.green;     // Normal
      if (index < 30) return Colors.orange;    // Overweight
      return Colors.red;                        // Obese
    }


    // Draw all ticks
    for (int i = 0; i < totalTicks; i++) {
      double x = i * spacing;
      double tickValue = (340 / intervals) * i;

      bool isCurrentTick = (tickValue - currentBmiPosition).abs() < 0.5;

      final Paint paint = Paint()
        ..color = getColorForTick(i)
        ..strokeWidth = 3;

      canvas.drawLine(
        Offset(x, size.height - tickHeight),
        Offset(x, size.height),
        isCurrentTick ? highlightPaint : paint,
      );
    }

    // Determine which category currentBmiPosition falls in (by tick index)
    
    int currentTickIndex = (currentBmiPosition / spacing).round();

    String label = "";
    Color labelColor = Colors.green;

    if (currentTickIndex < 8) {
      label = "Underweight";
      labelColor = Colors.blue;
    } else if (currentTickIndex < 21) {
      label = "Normal";
      labelColor = Colors.green;
    } else if (currentTickIndex < 30) {
      label = "Overweight";
      labelColor = Colors.orange;
    } else {
      label = "Obese";
      labelColor = Colors.red;
    }

    // X position for the label box
    double xLabel = currentTickIndex * spacing;

    // Draw label inside a colored container (pill-shaped)
    const double padding = 6; 

    final textSpan = TextSpan(
      text: label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    final boxWidth = textPainter.width + padding * 2;
    final boxHeight = textPainter.height + padding;

    final boxOffset = Offset(
      xLabel - boxWidth / 2,
      size.height - tickHeight - boxHeight - 10,  // 10 px gap above 
    );

    final Rect rect = boxOffset & Size(boxWidth, boxHeight);
    final RRect roundedRect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    final Paint boxPaint = Paint()..color = labelColor;

    canvas.drawRRect(roundedRect, boxPaint);

    final textOffset = boxOffset.translate(padding, (boxHeight - textPainter.height) / 2);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant BmiResultRulerPainter oldDelegate) {
    return oldDelegate.currentBmiPosition != currentBmiPosition || oldDelegate.width != width;
  }
}