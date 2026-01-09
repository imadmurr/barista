import 'package:flutter/material.dart';

class PourStreamPainter extends CustomPainter {
  final double progress;

  PourStreamPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final w = size.width;
    final h = size.height;

    final start = Offset(w * 0.46, h * 0.145);
    final end = Offset(w * 0.5, h * 0.42);
    final control = Offset(w * 0.48, h * 0.3);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

    final metric = path.computeMetrics().first;
    final length = metric.length;
    final current = length * progress.clamp(0.0, 1.0);
    final partial = metric.extractPath(0, current);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFB3E5FC).withOpacity(0.9);

    canvas.drawPath(partial, paint);
  }

  @override
  bool shouldRepaint(covariant PourStreamPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
