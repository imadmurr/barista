import 'package:flutter/material.dart';

import '../../data/cocktails_repository.dart';
import '../../models/cocktail.dart';
import '../shared/widgets/cocktail_list_tile.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String id) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final repo = CocktailsRepository.instance;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favorites',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: favorites.isEmpty
                ? const Center(child: Text("You haven't starred any yet."))
                : StreamBuilder<List<Cocktail>>(
                    stream: repo.watchByIds(favorites),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load favorites.\n${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final items = snapshot.data ?? const <Cocktail>[];
                      if (items.isEmpty) {
                        // This can happen if ids exist locally but not in Firestore
                        return const Center(
                          child: Text("You haven't starred any yet."),
                        );
                      }

                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final c = items[i];
                          return CocktailListTile(
                            cocktail: c,
                            isFavorite: favorites.contains(c.id),
                            onToggleFavorite: () => onToggleFavorite(c.id),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
