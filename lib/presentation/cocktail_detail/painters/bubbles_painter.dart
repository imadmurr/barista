import 'dart:math' as math;

import 'package:flutter/material.dart';

class BubblesPainter extends CustomPainter {
  final double bubblePhase;

  BubblesPainter({required this.bubblePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final count = 22;
    final w = size.width;
    final h = size.height;

    for (int i = 0; i < count; i++) {
      final nx = i / count;
      final baseX = w * (0.25 + 0.5 * nx);
      final baseY = h * (0.55 + (i % 5) * 0.03);

      final floatOffset =
          math.sin((bubblePhase * 2 * math.pi) + (i * 0.7)) * 12;

      final x = baseX + math.sin(i * 1.3) * 6;
      final y = baseY - floatOffset;

      final radius = 2 + (i % 3) * 1.2;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BubblesPainter oldDelegate) {
    return oldDelegate.bubblePhase != bubblePhase;
  }
}
