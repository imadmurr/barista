import 'dart:ui';

import 'ingredient.dart';

class Cocktail {
  final String id;
  final String name;
  final String subtitle;
  final List<Color> gradient;
  final List<String> tags;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final List<Color> layerColors;

  const Cocktail({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.gradient,
    required this.tags,
    required this.ingredients,
    required this.steps,
    required this.layerColors,
  });
}
