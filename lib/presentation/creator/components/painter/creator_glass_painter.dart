import 'dart:math' as math;

import 'package:flutter/material.dart';

class CreatorGlassPainter extends CustomPainter {
  final Color color;
  final bool sparkling;
  final double bubblePhase;

  CreatorGlassPainter({
    required this.color,
    required this.sparkling,
    required this.bubblePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final glassPath = Path()
      ..moveTo(w * 0.25, h * 0.15)
      ..lineTo(w * 0.75, h * 0.15)
      ..lineTo(w * 0.65, h * 0.8)
      ..quadraticBezierTo(w * 0.5, h * 0.9, w * 0.35, h * 0.8)
      ..close();

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.85);

    canvas.drawPath(glassPath, borderPaint);

    canvas.save();
    canvas.clipPath(glassPath);

    // Liquid fill
    final fillRect = Rect.fromLTWH(0, h * 0.35, w, h * 0.5);
    final fillGradient = LinearGradient(
      colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    canvas.drawRect(
      fillRect,
      Paint()..shader = fillGradient.createShader(fillRect),
    );

    // Bubbles
    if (sparkling) {
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      for (int i = 0; i < 10; i++) {
        final nx = i / 10;
        final baseY = h * (0.8 - 0.3 * nx);
        final offsetY = math.sin(bubblePhase * 2 * math.pi + i) * 4;

        final x = w * (0.3 + 0.4 * nx);
        final y = baseY + offsetY;

        canvas.drawCircle(Offset(x, y), 2.5, bubblePaint);
      }
    }

    canvas.restore();

    // Glow rim
    final rimRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.15),
      width: w * 0.6,
      height: h * 0.04,
    );
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6)
      ..color = color.withOpacity(0.9);
    canvas.drawOval(rimRect, rimPaint);
  }

  @override
  bool shouldRepaint(covariant CreatorGlassPainter old) {
    return old.color != color ||
        old.sparkling != sparkling ||
        old.bubblePhase != bubblePhase;
  }
}
