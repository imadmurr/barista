import 'package:flutter/material.dart';

class FogPainter extends CustomPainter {
  final double intensity;

  FogPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06 * intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final w = size.width;
    final h = size.height;

    canvas.drawCircle(Offset(w * 0.3, h * 0.1), 60, paint);
    canvas.drawCircle(Offset(w * 0.7, h * 0.08), 50, paint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.18), 70, paint);
  }

  @override
  bool shouldRepaint(covariant FogPainter oldDelegate) {
    return oldDelegate.intensity != intensity;
  }
}
