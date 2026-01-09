import 'package:flutter/material.dart';

import 'painter/creator_glass_painter.dart';

class CreatorPreviewGlass extends StatefulWidget {
  final Color color;
  final bool sparkling;

  const CreatorPreviewGlass({
    super.key,
    required this.color,
    required this.sparkling,
  });

  @override
  State<CreatorPreviewGlass> createState() => _CreatorPreviewGlassState();
}

class _CreatorPreviewGlassState extends State<CreatorPreviewGlass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant CreatorPreviewGlass oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.color != widget.color ||
        oldWidget.sparkling != widget.sparkling) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = Curves.easeInOut.transform(_controller.value);
        final wobble = (t - 0.5) * 0.12;

        return Transform.rotate(
          angle: wobble,
          child: CustomPaint(
            size: const Size(140, 200),
            painter: CreatorGlassPainter(
              color: widget.color,
              sparkling: widget.sparkling,
              bubblePhase: _controller.value,
            ),
          ),
        );
      },
    );
  }
}
