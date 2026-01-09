import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreSeeder {
  static const _seedMarkerDoc =
      'seed_v1'; // change if you want to re-seed later

  /// Call this once (e.g. from a hidden dev button).
  static Future<void> seedIfNeeded({int count = 40}) async {
    if (!kDebugMode) {
      throw Exception('Seeding is intended for debug builds only.');
    }

    final db = FirebaseFirestore.instance;

    // Marker document to prevent re-seeding
    final markerRef = db.collection('_meta').doc(_seedMarkerDoc);
    final markerSnap = await markerRef.get();
    if (markerSnap.exists) {
      debugPrint('✅ Firestore already seeded ($_seedMarkerDoc). Skipping.');
      return;
    }

    final cocktails = _generateMockCocktails(count: count);

    // Firestore batch limit is 500 writes. Keep count <= ~400 safely.
    final batch = db.batch();

    for (final c in cocktails) {
      final docRef = db.collection('cocktails').doc(c['id'] as String);
      batch.set(docRef, c);
    }

    // Create marker after successful write
    batch.set(markerRef, {
      'seededAt': FieldValue.serverTimestamp(),
      'count': cocktails.length,
      'version': _seedMarkerDoc,
    });

    await batch.commit();
    debugPrint('🎉 Seeded ${cocktails.length} cocktails into Firestore.');
  }

  /// Generates random cocktail documents matching your model shape.
  static List<Map<String, dynamic>> _generateMockCocktails({
    required int count,
  }) {
    final rnd = Random(42); // deterministic randomness for repeatable mock data

    final baseNames = [
      'Neon Mule',
      'Sunset Spritz',
      'Velvet Sour',
      'Midnight Fizz',
      'Citrus Bloom',
      'Ruby Highball',
      'Amber Wave',
      'Lavender Rush',
      'Tropical Static',
      'Smoked Honey',
      'Pearl Collins',
      'Electric Daiquiri',
      'Arctic Mojito',
      'Crimson Smash',
      'Golden Tonic',
      'Jasmine Slinger',
      'Cocoa Old-Fashioned',
      'Lime Orbit',
      'Rosemary Paloma',
      'Berry Bramble',
    ];

    final subtitles = [
      'bright & zesty',
      'silky and aromatic',
      'easy summer sip',
      'bold and bubbly',
      'refreshing twist',
      'bar-style classic',
      'fruity with bite',
      'herbal and crisp',
    ];

    final tagPool = [
      'Refreshing',
      'Boozy',
      'Fruity',
      'Citrusy',
      'Herbal',
      'Sweet',
      'Smoky',
      'Bitter',
      'Party',
      'Date Night',
      'Classic Twist',
      'Low Effort',
      'Shaken',
      'Stirred',
      'On Ice',
    ];

    final ingredientPool = [
      'Vodka',
      'Gin',
      'White Rum',
      'Dark Rum',
      'Tequila',
      'Bourbon',
      'Whiskey',
      'Triple Sec',
      'Vermouth',
      'Campari',
      'Aperol',
      'Lime Juice',
      'Lemon Juice',
      'Orange Juice',
      'Pineapple Juice',
      'Cranberry Juice',
      'Simple Syrup',
      'Honey Syrup',
      'Grenadine',
      'Soda Water',
      'Tonic Water',
      'Ginger Beer',
      'Mint',
      'Basil',
      'Rosemary',
      'Angostura Bitters',
      'Egg White',
    ];

    final glassware = [
      'Highball',
      'Coupe',
      'Rocks',
      'Collins',
      'Martini',
      'Nick & Nora',
    ];

    // Some nice gradients & layer palettes (ARGB ints)
    final gradients = <List<int>>[
      [0xFF1A2A6C, 0xFFB21F1F, 0xFFFDBB2D],
      [0xFF00C6FF, 0xFF0072FF],
      [0xFFFC5C7D, 0xFF6A82FB],
      [0xFF11998E, 0xFF38EF7D],
      [0xFFEE0979, 0xFFFF6A00],
      [0xFF41295A, 0xFF2F0743],
      [0xFF56CCF2, 0xFF2F80ED],
      [0xFFFF512F, 0xFFDD2476],
    ];

    final layerPalettes = <List<int>>[
      [0xFFFFD54F, 0xFFFF8A65, 0xFFBA68C8],
      [0xFF81D4FA, 0xFF4DB6AC, 0xFFAED581],
      [0xFFFFAB91, 0xFFFFCC80, 0xFFE6EE9C],
      [0xFFB39DDB, 0xFF80CBC4, 0xFFFFF59D],
      [0xFFFFCDD2, 0xFFF8BBD0, 0xFFBBDEFB],
    ];

    String pickName(int i) {
      final base = baseNames[i % baseNames.length];
      final suffix = (i >= baseNames.length) ? ' #${i + 1}' : '';
      return '$base$suffix';
    }

    Map<String, dynamic> makeCocktail(int i) {
      final id = 'cocktail_${i + 1}';
      final name = pickName(i);
      final subtitle =
          '${subtitles[rnd.nextInt(subtitles.length)]} · ${glassware[rnd.nextInt(glassware.length)]}';

      final gradient = gradients[rnd.nextInt(gradients.length)];
      final layerColors = layerPalettes[rnd.nextInt(layerPalettes.length)];

      final tagCount = 3 + rnd.nextInt(3); // 3..5 tags
      final tags = <String>{};
      while (tags.length < tagCount) {
        tags.add(tagPool[rnd.nextInt(tagPool.length)]);
      }

      final ingCount = 4 + rnd.nextInt(4); // 4..7 ingredients
      final ingredients = <Map<String, dynamic>>[];

      // Ensure at least one base spirit
      final spirits = [
        'Vodka',
        'Gin',
        'White Rum',
        'Tequila',
        'Bourbon',
        'Whiskey',
        'Dark Rum',
      ];
      final baseSpirit = spirits[rnd.nextInt(spirits.length)];
      ingredients.add({
        'amount': _randomAmount(rnd, forSpirit: true),
        'name': baseSpirit,
      });

      while (ingredients.length < ingCount) {
        final ing = ingredientPool[rnd.nextInt(ingredientPool.length)];
        if (ingredients.any((e) => e['name'] == ing)) continue;
        ingredients.add({'amount': _randomAmount(rnd), 'name': ing});
      }

      final steps = _buildSteps(rnd, name: name);

      return {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'gradient': gradient, // List<int> ARGB
        'tags': tags.toList(),
        'ingredients': ingredients, // List<Map>
        'steps': steps, // List<String>
        'layerColors': layerColors, // List<int> ARGB
        'createdAt': FieldValue.serverTimestamp(),
      };
    }

    return List.generate(count, makeCocktail);
  }

  static String _randomAmount(Random rnd, {bool forSpirit = false}) {
    if (forSpirit) {
      final spiritAmounts = ['45 ml', '50 ml', '60 ml', '2 oz', '1.5 oz'];
      return spiritAmounts[rnd.nextInt(spiritAmounts.length)];
    }
    final amounts = [
      '10 ml',
      '15 ml',
      '20 ml',
      '25 ml',
      '1 tsp',
      '2 tsp',
      '1 dash',
      '2 dashes',
      '30 ml',
      '60 ml',
      'Top up',
      'To taste',
    ];
    return amounts[rnd.nextInt(amounts.length)];
  }

  static List<String> _buildSteps(Random rnd, {required String name}) {
    final templates = <List<String>>[
      [
        'Fill a shaker with ice.',
        'Add all ingredients (except any soda/tonic).',
        'Shake hard for 10–12 seconds.',
        'Strain into a chilled glass.',
        'Garnish and serve.',
      ],
      [
        'Add ingredients to a mixing glass with ice.',
        'Stir until well chilled (15–20 seconds).',
        'Strain over fresh ice in a rocks glass.',
        'Express citrus oils (optional) and garnish.',
      ],
      [
        'Muddle herbs gently in the glass.',
        'Add ice and pour in the spirits and juices.',
        'Top up with sparkling mixer.',
        'Give a gentle lift-stir and garnish.',
      ],
    ];

    final base = templates[rnd.nextInt(templates.length)];
    // Add a tiny personalized finishing note sometimes
    if (rnd.nextBool()) {
      return [...base, 'Tip: Adjust sweetness to match the vibe of $name.'];
    }
    return base;
  }
}
