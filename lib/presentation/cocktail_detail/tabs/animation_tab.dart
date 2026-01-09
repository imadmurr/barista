import 'package:flutter/material.dart';

import '../../../models/cocktail.dart';
import '../widgets/cocktail_animation_canvas.dart';

class AnimationTab extends StatefulWidget {
  final Cocktail cocktail;

  const AnimationTab({super.key, required this.cocktail});

  @override
  State<AnimationTab> createState() => _AnimationTabState();
}

class _AnimationTabState extends State<AnimationTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> iceProgress;
  late final Animation<double> pourProgress;
  late final Animation<double> layerProgress;
  late final Animation<double> shakeProgress;
  late final Animation<double> garnishProgress;
  late final Animation<double> fogProgress;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    iceProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
    );

    pourProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.55, curve: Curves.easeInOutCubic),
    );

    layerProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.75, curve: Curves.easeInOutCubic),
    );

    shakeProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.8, curve: Curves.easeInOut),
    );

    garnishProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOutBack),
    );

    fogProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play() {
    _controller.forward(from: 0);
  }

  void _stop() {
    _controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          // ANIMATION AREA
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return CocktailAnimationCanvas(
                  cocktail: widget.cocktail,
                  iceProgress: iceProgress.value,
                  pourProgress: pourProgress.value,
                  layerProgress: layerProgress.value,
                  shakeProgress: shakeProgress.value,
                  garnishProgress: garnishProgress.value,
                  fogProgress: fogProgress.value,
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // DESCRIPTION
          Text(
            'Step-by-step animated builder',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Ice drop · Pour base · Add layer · Shake · Garnish & mist',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),

          const SizedBox(height: 16),

          // CONTROLS
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _play,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Play sequence'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: _stop,
                icon: const Icon(Icons.stop_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
