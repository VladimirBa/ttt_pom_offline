import 'package:flutter/material.dart';

class CrossPainter extends CustomPainter {
  final double opacity;

  CrossPainter({this.opacity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(opacity) // Используем переданную прозрачность
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Линия 1: от верхнего левого угла к нижнему правому (под 45 градусов)
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );

    // Линия 2: от верхнего правого угла к нижнему левому (под 45 градусов)
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}