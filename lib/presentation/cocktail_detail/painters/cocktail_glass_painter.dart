import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CocktailGlassPainter extends CustomPainter {
  final double pourLevel; // 0..1 how full the glass is
  final double layerLevel; // 0..1 extra “accent” layer
  final List<Color> layerColors;

  /// - wavePhase: drives the wave surface animation
  /// - waveIntensity: how agitated the liquid looks
  final double wavePhase;
  final double waveIntensity;

  CocktailGlassPainter({
    required this.pourLevel,
    required this.layerLevel,
    required this.layerColors,
    this.wavePhase = 0,
    this.waveIntensity = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // -------------------------
    // Glass outline
    // -------------------------
    final glassPath = Path()
      ..moveTo(w * 0.25, h * 0.1)
      ..lineTo(w * 0.75, h * 0.1)
      ..lineTo(w * 0.65, h * 0.80)
      ..quadraticBezierTo(w * 0.5, h * 0.88, w * 0.35, h * 0.80)
      ..close();

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.85);

    canvas.drawPath(glassPath, basePaint);

    // -------------------------
    // Liquid inside glass
    // -------------------------
    canvas.save();
    canvas.clipPath(glassPath);

    final clampedPour = pourLevel.clamp(0.0, 1.0);
    final clampedLayer = layerLevel.clamp(0.0, 1.0);
    final clampedWaveIntensity = waveIntensity.clamp(0.0, 1.0);

    final bottomY = h * 0.86;
    final maxHeight = h * 0.6;
    final liquidHeight = maxHeight * clampedPour;
    final liquidTopY = bottomY - liquidHeight;

    // -------------------------
    // Wave parameters
    // -------------------------

    final double baseAmplitude = 2.0; // calm
    final double extraFromIntensity = 6.0 * clampedWaveIntensity;
    final double amplitude = baseAmplitude + extraFromIntensity;

    final double tilt = math.sin(wavePhase * 2 * math.pi) * 4.0;
    final double frequency = 1.6;
    final double phase = wavePhase * 2 * math.pi;

    final Path liquidPath = Path()
      ..moveTo(w * 0.28, bottomY)
      ..lineTo(w * 0.28, liquidTopY);

    const int segments = 40;

    for (int i = 0; i <= segments; i++) {
      final t = i / segments;
      final x = lerpDouble(w * 0.28, w * 0.72, t)! + tilt;
      final waveY =
          liquidTopY +
          math.sin(phase + t * frequency * 2 * math.pi) * amplitude;
      liquidPath.lineTo(x, waveY);
    }

    liquidPath
      ..lineTo(w * 0.72 + tilt, bottomY)
      ..close();

    final Color baseColor = layerColors.isNotEmpty
        ? layerColors.first
        : const Color(0xFF00C9FF);
    final Color accentColor = layerColors.length > 1
        ? layerColors.last
        : baseColor.withOpacity(0.8);

    final liquidGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(
          baseColor,
          accentColor,
          0.3 + 0.3 * clampedLayer,
        )!.withOpacity(0.95),
        Color.lerp(baseColor, accentColor, 0.8)!.withOpacity(0.75),
      ],
    );

    final Rect liquidRect = Rect.fromLTWH(
      0,
      liquidTopY,
      w,
      bottomY - liquidTopY,
    );

    final Paint liquidPaint = Paint()
      ..shader = liquidGradient.createShader(liquidRect);

    canvas.drawPath(liquidPath, liquidPaint);

    // -------------------------
    // Parallax secondary wave
    // -------------------------

    final Path parallaxPath = Path()
      ..moveTo(w * 0.30, bottomY)
      ..lineTo(w * 0.30, liquidTopY + 10);

    final double parallaxAmp = amplitude * 0.4;
    final double parallaxFreq = frequency * 1.3;
    final double parallaxPhase = phase + math.pi / 3;

    for (int i = 0; i <= segments; i++) {
      final t = i / segments;
      final x = lerpDouble(w * 0.30, w * 0.70, t)! + tilt * 0.5;
      final y =
          (liquidTopY + 10) +
          math.sin(parallaxPhase + t * parallaxFreq * 2 * math.pi) *
              parallaxAmp;
      parallaxPath.lineTo(x, y);
    }

    parallaxPath
      ..lineTo(w * 0.70 + tilt * 0.5, bottomY)
      ..close();

    final Paint parallaxPaint = Paint()
      ..shader = liquidGradient.createShader(liquidRect)
      ..colorFilter = ColorFilter.mode(
        Colors.black.withOpacity(0.12),
        BlendMode.srcATop,
      );

    canvas.drawPath(parallaxPath, parallaxPaint);

    // -------------------------
    // Inner highlight streak
    // -------------------------

    final Paint highlightPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white.withOpacity(0.18), Colors.transparent],
          ).createShader(
            Rect.fromLTWH(w * 0.34, liquidTopY, w * 0.14, bottomY - liquidTopY),
          );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          w * 0.34,
          liquidTopY + 8,
          w * 0.12,
          (bottomY - liquidTopY) - 16,
        ),
        const Radius.circular(14),
      ),
      highlightPaint,
    );

    canvas.restore();

    // -------------------------
    // Inner bottom shadow
    // -------------------------

    final Paint innerShadow = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Colors.black.withOpacity(0.18), Colors.transparent],
      ).createShader(Rect.fromLTWH(w * 0.32, bottomY - 30, w * 0.36, 30))
      ..blendMode = BlendMode.darken;

    canvas.save();
    canvas.clipPath(glassPath);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.32, bottomY - 30, w * 0.36, 30),
      innerShadow,
    );
    canvas.restore();

    // -------------------------
    // Reflection streak
    // -------------------------

    final Paint streakPaint = Paint()
      ..shader =
          LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromLTWH(w * 0.28, liquidTopY, w * 0.2, bottomY - liquidTopY),
          );

    canvas.save();
    canvas.clipPath(glassPath);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          w * 0.30,
          liquidTopY + 10,
          w * 0.18,
          (bottomY - liquidTopY) - 20,
        ),
        const Radius.circular(22),
      ),
      streakPaint,
    );
    canvas.restore();

    // -------------------------
    // Glass edge highlight
    // -------------------------

    final Paint leftHighlight = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path leftEdge = Path()
      ..moveTo(w * 0.25, h * 0.1)
      ..lineTo(w * 0.35, h * 0.80);

    canvas.drawPath(leftEdge, leftHighlight);

    // -------------------------
    // Rim glow
    // -------------------------

    final rimRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.1),
      width: w * 0.6,
      height: h * 0.04,
    );

    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6)
      ..color = baseColor.withOpacity(0.9);

    canvas.drawOval(rimRect, rimPaint);
  }

  @override
  bool shouldRepaint(covariant CocktailGlassPainter oldDelegate) {
    return oldDelegate.pourLevel != pourLevel ||
        oldDelegate.layerLevel != layerLevel ||
        oldDelegate.layerColors != layerColors ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.waveIntensity != waveIntensity;
  }
}
