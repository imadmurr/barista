import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'components/creator_preview_glass.dart';

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  String _baseFlavor = 'Tropical';
  String _sweetness = 'Medium';
  double _colorHue = 190;
  bool _isSparkling = true;
  bool _isAlcoholFree = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color previewColor = HSLColor.fromAHSL(
      1,
      _colorHue,
      0.7,
      0.5,
    ).toColor();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Creator Studio',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Describe your ideal drink and preview it visually (mock only).',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 20),

          // FLAVOR
          Text(
            'Base flavor',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Tropical', 'Citrus', 'Berry', 'Creamy', 'Herbal'].map((
              label,
            ) {
              return ChoiceChip(
                label: Text(label),
                selected: _baseFlavor == label,
                onSelected: (_) => setState(() => _baseFlavor = label),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // SWEETNESS
          Text(
            'Sweetness',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Low', 'Medium', 'High'].map((label) {
              return ChoiceChip(
                label: Text(label),
                selected: _sweetness == label,
                onSelected: (_) => setState(() => _sweetness = label),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // COLOR PICKER
          Text(
            'Color accent',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _colorHue,
                  min: 0,
                  max: 360,
                  onChanged: (v) => setState(() => _colorHue = v),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: const [
                      Colors.red,
                      Colors.yellow,
                      Colors.green,
                      Colors.cyan,
                      Colors.blue,
                      Colors.purple,
                      Colors.red,
                    ],
                    transform: GradientRotation(_colorHue * math.pi / 180),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // SWITCHES
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Sparkling'),
                  value: _isSparkling,
                  onChanged: (v) => setState(() => _isSparkling = v),
                ),
              ),
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Alcohol-free'),
                  value: _isAlcoholFree,
                  onChanged: (v) => setState(() => _isAlcoholFree = v),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // PREVIEW GLASS
          Text(
            'Visual preview',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: CreatorPreviewGlass(
                color: previewColor,
                sparkling: _isSparkling,
              ),
            ),
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: () {
              final mockName =
                  '${_sweetness} ${_baseFlavor.toLowerCase()} ${_isSparkling ? 'Fizz' : 'Blend'}';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Generated mock cocktail: $mockName')),
              );
            },
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Generate mock cocktail'),
          ),
        ],
      ),
    );
  }
}
