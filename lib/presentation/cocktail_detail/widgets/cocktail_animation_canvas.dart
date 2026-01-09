import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/cocktail.dart';
import '../painters/bubbles_painter.dart';
import '../painters/cocktail_glass_painter.dart';
import '../painters/fog_painter.dart';
import '../painters/pour_stream_painter.dart';

class CocktailAnimationCanvas extends StatelessWidget {
  final Cocktail cocktail;

  final double iceProgress;
  final double pourProgress;
  final double layerProgress;
  final double shakeProgress;
  final double garnishProgress;
  final double fogProgress;

  const CocktailAnimationCanvas({
    super.key,
    required this.cocktail,
    required this.iceProgress,
    required this.pourProgress,
    required this.layerProgress,
    required this.shakeProgress,
    required this.garnishProgress,
    required this.fogProgress,
  });

  double _clamp(double v) => v.clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final double ice = _clamp(iceProgress);
    final double pour = _clamp(pourProgress);
    final double layer = _clamp(layerProgress);
    final double shake = _clamp(shakeProgress);
    final double garnish = _clamp(garnishProgress);
    final double fog = _clamp(fogProgress);

    // Derived wave + intensity values
    final double wavePhase = (pour + shake) % 1.0;
    final double waveIntensity = (shake * 0.8) + (pour * 0.2);

    final Color liquidColor = (cocktail.layerColors.isNotEmpty
        ? cocktail.layerColors.first
        : Colors.tealAccent);

    return Center(
      child: ClipRect(
        child: SizedBox(
          width: 300,
          height: 420,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient glow behind drink
              Positioned(
                bottom: 40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        liquidColor.withOpacity(0.35),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Fog
              CustomPaint(
                size: const Size(300, 420),
                painter: FogPainter(intensity: fog),
              ),

              // Bubbles
              CustomPaint(
                size: const Size(300, 420),
                painter: BubblesPainter(bubblePhase: pour),
              ),

              // Glass + liquid
              CustomPaint(
                size: const Size(220, 300),
                painter: CocktailGlassPainter(
                  pourLevel: pour,
                  layerLevel: layer,
                  layerColors: cocktail.layerColors,
                  wavePhase: wavePhase,
                  waveIntensity: waveIntensity,
                ),
              ),

              // Floating ice cubes with physics
              _IceCube(
                index: 0,
                progress: ice,
                wavePhase: wavePhase,
                waveIntensity: waveIntensity,
                shake: shake,
                liquidColor: liquidColor,
              ),
              _IceCube(
                index: 1,
                progress: ice,
                wavePhase: wavePhase,
                waveIntensity: waveIntensity,
                shake: shake,
                liquidColor: liquidColor,
              ),
              _IceCube(
                index: 2,
                progress: ice,
                wavePhase: wavePhase,
                waveIntensity: waveIntensity,
                shake: shake,
                liquidColor: liquidColor,
              ),

              // Garnish
              _Garnish(progress: garnish),

              // Shaker
              _Shaker(progress: shake),

              // Pour stream
              _PourStream(progress: pour),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
// ICE CUBE WITH FLOATING PHYSICS
///////////////////////////////////////////////////////////////////////////////

class _IceCube extends StatelessWidget {
  final int index;
  final double progress; // 0..1
  final double wavePhase;
  final double waveIntensity;
  final double shake;
  final Color liquidColor;

  const _IceCube({
    required this.index,
    required this.progress,
    required this.wavePhase,
    required this.waveIntensity,
    required this.shake,
    required this.liquidColor,
  });

  @override
  Widget build(BuildContext context) {
    final double t = progress.clamp(0.0, 1.0);

    // FALL → FLOAT physics
    final double startY = -80 - index * 20.0;
    final double endY = 40 + index * 8.0;

    double y;

    if (t < 0.55) {
      // FALLING PHASE
      final double fallT = (t / 0.55).clamp(0.0, 1.0);
      final double bounceT = Curves.bounceOut.transform(fallT);
      y = lerpDouble(startY, endY, bounceT)!;
    } else {
      // FLOATING PHASE
      final double floatT = ((t - 0.55) / 0.45).clamp(0.0, 1.0);
      final double seed = index * 1.37;

      final double wave = waveIntensity.clamp(0.0, 1.0);

      final double base = endY;

      final double bobAmp = (4.0 + index * 1.2) * (0.3 + wave * 0.7);

      final double bob =
          math.sin(wavePhase * 2 * math.pi + floatT * 4 * math.pi + seed) *
          bobAmp;

      y = base + bob;
    }

    // Horizontal slosh
    final double tiltShift = math.sin(wavePhase * 2 * math.pi) * 5.0;
    final double shakeShift = math.sin(t * 10 * math.pi + index) * 2.0 * shake;

    final double xOffset = (index - 1) * 26.0 + tiltShift + shakeShift;

    return Positioned(
      bottom: 120 + y,
      left: 140 + xOffset,
      child: Opacity(
        opacity: t,
        child: Transform.rotate(
          angle: (index - 1) * 0.3 * t,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Color.lerp(
                  Colors.white,
                  liquidColor,
                  0.4,
                )!.withOpacity(0.75),
                width: 1,
              ),
              color: Color.lerp(
                Colors.white,
                liquidColor,
                0.6,
              )!.withOpacity(0.22),
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
// GARNISH (unchanged)
///////////////////////////////////////////////////////////////////////////////

class _Garnish extends StatelessWidget {
  final double progress;

  const _Garnish({required this.progress});

  @override
  Widget build(BuildContext context) {
    final double t = Curves.easeOutBack.transform(progress.clamp(0.0, 1.0));
    final double slide = lerpDouble(60, 0, t)!;

    return Positioned(
      top: 60 - slide,
      right: 60 - slide * 0.4,
      child: Opacity(
        opacity: progress,
        child: Transform.rotate(
          angle: -0.4,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [
                  Color(0xFFFAF089),
                  Color(0xFFF6E05E),
                  Color(0xFFFAF089),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 1.4,
              ),
            ),
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
// SHAKER (unchanged)
///////////////////////////////////////////////////////////////////////////////

class _Shaker extends StatelessWidget {
  final double progress;

  const _Shaker({required this.progress});

  @override
  Widget build(BuildContext context) {
    final double t = Curves.easeInOut.transform(progress.clamp(0.0, 1.0));
    final double angle = math.sin(t * 10 * math.pi) * 0.35;
    final double dx = math.sin(t * 10 * math.pi) * 6;

    return Positioned(
      top: 10,
      left: 90 + dx,
      child: Opacity(
        opacity: progress.clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: angle,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 60,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFFEEEEEE), Color(0xFFB0BEC5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
// POUR STREAM
///////////////////////////////////////////////////////////////////////////////

class _PourStream extends StatelessWidget {
  final double progress;

  const _PourStream({required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: CustomPaint(
          painter: PourStreamPainter(progress: progress.clamp(0.0, 1.0)),
        ),
      ),
    );
  }
}
