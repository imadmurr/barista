import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/cocktail.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const CocktailCard({
    super.key,
    required this.cocktail,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        // Navigate to detail
        context.push('/cocktail/${cocktail.id}');
      },
      child: Hero(
        tag: 'cocktail-card-${cocktail.id}',
        child: AspectRatio(
          // Matches roughly your grid's childAspectRatio (.72) but kept safe
          aspectRatio: 3 / 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: cocktail.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Subtle overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.35),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Tag chip (first tag)
                  if (cocktail.tags.isNotEmpty)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.black.withOpacity(0.35),
                        ),
                        child: Text(
                          cocktail.tags.first,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),

                  // Favorite icon
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      onPressed: onToggleFavorite,
                      icon: Icon(
                        isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 20,
                        color: isFavorite ? scheme.secondary : Colors.white70,
                      ),
                    ),
                  ),

                  // Bottom text (name + subtitle)
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cocktail.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cocktail.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
